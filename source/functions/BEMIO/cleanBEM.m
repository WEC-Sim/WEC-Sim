 function hydro = cleanBEM(hydro, despike)
% Original author: Dominic D. Forbush
% Contributors: Adam Keester

% Based on the paper: 
% Kelly, T., Zabala, I., Peña-Sanchez, Y., Penalba, M., Ringwood, J. V.,
% Henriques, J. C., & Blanco, J. M. (2022). A post-processing technique for
% removing ‘irregular frequencies’ and other issues in the results from BEM
% solvers. International Marine Energy Journal, 5(1), 123–131.
% https://doi.org/10.36688/imej.5.123-131
% 
% This function cleans noisy BEM coefficients (A, B, ex) by:
% - identifying and removing sharp peaks (IRR effects)
% - filtering to smooth fast changes in coefficients
%
% Call this function after reading a hydrodynamic dataset and combining any
% bodies. This function may be called after IRFs are calculated in the
% original, input dataset but IRFs must be recalculated after this
% function is called so that the cleaned coefficients are used.
% 
% Parameters
% ------------
%     hydro : {1 x 1} cell of strings
%         Defines the output file of interest. If the code is AQWA, this
%         needs to be {1x2} where {1} is the 'ah1' and {2} is the 'lis'
%
%     code : [1 1] string
%         Name of the BEM code, used to select the readBEM function. A
%         string either 'WAMIT','CAPYTAINE','NEMOH',or 'AQWA'
%
%     despike : [1 1] struct
%         Contains the parameters used in the filtering and peak
%         identification functions. For description and field names, look
%         at the line with "if isempty(despike)" to see what parameters are
%         available.
%
% Returns
% ------------
%     hydro : struct
%         Output BEMIO structure
%
% Example 1:
% >> hydro = readWAMIT(hydro, ...);
% >> hydro = combineBEM(hydro);
% >> hydro = cleanBEM(hydro, despike); 
% >> hydro = radiationIRF(hydro, ...);
% >> hydro = radiationIRFSS(hydro, ...);
% >> hydro = excitationIRF(hydro, ...);
% >> writeBEMIOH5(hydro);
% >> plotBEMIO(hydro);
% 
% Example 2:
% >> hydro = readWAMIT(hydro, ...);
% >> hydro = combineBEM(hydro);
% >> hydro = radiationIRF(hydro, ...);
% >> hydro = radiationIRFSS(hydro, ...);
% >> hydro = excitationIRF(hydro, ...);
% >> hydro_clean = cleanBEM(hydro, despike); 
% >> hydro_clean = radiationIRF(hydro_clean, ...);
% >> hydro_clean = radiationIRFSS(hydro_clean, ...);
% >> hydro_clean = excitationIRF(hydro_clean, ...);
% >> plotBEMIO(hydro, hydro_clean);
% 

%% de-spiking parameters
% maxPeakWidth is not recommended however as it has unexpected behavior
if isempty(despike) % if the third argument is empty will use some default values
    despike = struct();
    despike.negThresh = 1e-3; % the threshold below which negative damping will be removed
    despike.N = 5; % will loop the despiking procedure N time before filtering
    despike.appFilt = 1; % boolean, 1 to apply low pass filter after despiking

    % thresholds: applied to 'Threshold' argument of findpeaks
    despike.B.Threshold = 2e-4; % damping
    despike.A.Threshold = 1e-3; % added mass
    despike.ExRe.Threshold = 1e-3; % real part excitation
    despike.ExIm.Threshold = 1e-3; % imag part excitation

    % minimum peak prominence, applied to 'MinPeakProminence' argument of findpeaks
    despike.B.Prominence = 2e-4;
    despike.A.Prominence = 1e-3;
    despike.ExRe.Prominence = 1e-3;
    despike.ExIm.Prominence = 1e-3;

    % minimum peak distance, applied to 'MinPeakDistance' argument of findpeaks
    despike.A.MinPeakDistance = 3;
    despike.B.MinPeakDistance = 3;
    despike.ExRe.MinPeakDistance = 3;
    despike.ExIm.MinPeakDistance = 3;

    % the b and a inputs to MATLAB's filtfilt(b,a,x) function
    despike.Filter.b = 0.02008336556421123561544384017452102853 .* [1 2 1];
    despike.Filter.a = [1 -1.561018075800718163392843962355982512236 0.641351538057563175243558362126350402832];
end

%% Input structure clean-up
% rename so that original H5 is not overwritten
hydro.file = [hydro.file '_clean'];

% The IRFs and state-space fields need to be recalculated based on the
% cleaned coefficients. Forcibly remove these fields here so that the
% structure is self-consistent
fieldsToRemove = {'ex_K','ex_t','ex_w','ra_K','ra_t','ra_w',...
    'ss_A','ss_B','ss_C','ss_D','ss_K','ss_conv','ss_R2','ss_O'};
for i = 1:length(fieldsToRemove)
    if isfield(hydro, fieldsToRemove{i})
        hydro = rmfield(hydro, fieldsToRemove{i});
    end
end

% Parse negative radiation damping along diagonal
for k = 1:size(hydro.B,1)
    bMax(k,k) = max(squeeze(hydro.B(k,k,:)));
    mask = hydro.B(k,k,:) < -despike.negThresh * bMax(k,k);
    hydro.B(k,k,mask) = 0;
end

%% Peak smoothing
[row, col, ~] = size(hydro.A);
for k = 1:row
    for kk = 1:col
        hydro.A(k,kk,:) = peakSmoothing(squeeze(hydro.A(k,kk,:)), hydro.w, despike.A, despike.N);
        hydro.B(k,kk,:) = peakSmoothing(squeeze(hydro.B(k,kk,:)), hydro.w, despike.B, despike.N);
    end
    hydro.ex_re(k,1,:) = peakSmoothing(squeeze(hydro.ex_re(k,1,:)), hydro.w, despike.ExRe, despike.N);
    hydro.ex_im(k,1,:) = peakSmoothing(squeeze(hydro.ex_im(k,1,:)), hydro.w, despike.ExIm, despike.N);
end

%% Filtering
if despike.appFilt == 1
    for k = 1:row
        for kk = 1:col
            hydro.A(k,kk,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.A(k,kk,:)));
            hydro.B(k,kk,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.B(k,kk,:)));
        end
        hydro.ex_re(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.ex_re(k,1,:)));
        hydro.ex_im(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.ex_im(k,1,:)));
        % hydro.ex_ma(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.ex_ma(k,1,:)));
        % hydro.ex_ph(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.ex_ph(k,1,:)));

        % if isfield(hydro,'sc_re')
        %     hydro.sc_re(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.sc_re(k,1,:)));
        %     hydro.sc_im(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.sc_im(k,1,:)));
        %     % hydro.sc_ma(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.sc_ma(k,1,:)));
        %     % hydro.sc_ph(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.sc_ph(k,1,:)));
        % end

        % if isfield(hydro,'fk_re')
        %     hydro.fk_re(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.fk_re(k,1,:)));
        %     hydro.fk_im(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.fk_im(k,1,:)));
        %     % hydro.fk_ma(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.fk_ma(k,1,:)));
        %     % hydro.fk_ph(k,1,:) = filtfilt(despike.Filter.b,despike.Filter.a,squeeze(hydro.fk_ph(k,1,:)));
        % end
    end
end

%% Update magnitude and phase components
hydro.ex_ma = (hydro.ex_re.^2 + hydro.ex_im.^2).^0.5;
hydro.ex_ph = angle(hydro.ex_re + 1i*hydro.ex_im);
if isfield(hydro,'sc_re')
    hydro.sc_ma = (hydro.sc_re.^2 + hydro.sc_im.^2).^0.5;
    hydro.sc_ph = angle(hydro.sc_re + 1i*hydro.sc_im);
end
if isfield(hydro,'fk_re')
    hydro.fk_ma = (hydro.fk_re.^2 + hydro.fk_im.^2).^0.5;
    hydro.fk_ph = angle(hydro.fk_re + 1i*hydro.fk_im);
end

end

%% Functions
function outData = peakSmoothing(data, w, despike, n)
    % force consistent input formatting
    w = w(:);
    data = data(:);

    for it = 1:n
        %%% There is a "maxPeakWidth" argument: this does not work as
        %%% the developer intends and is not recommended for use.
        % positive peaks
        [peaks, peakLocs] = findpeaks(data,'MinPeakProminence',despike.Prominence,'Threshold',despike.Threshold,'MinPeakDistance',despike.MinPeakDistance);
        
        % negative peaks
        [peaksN, peakLocsN] = findpeaks(-1.*data,'MinPeakProminence',despike.Prominence,'Threshold',despike.Threshold,'MinPeakDistance',despike.MinPeakDistance);
        
        % ignore peaks at the edges
        edgeLocs = peakLocs==length(data) | peakLocs==1;
        peakLocs(edgeLocs) = [];
        peaks(edgeLocs) = [];
        edgeLocsN = peakLocsN==length(data) | peakLocsN==1;
        peakLocsN(edgeLocsN) = [];
        peaksN(edgeLocsN) = [];
        
        % smooth hyperbolic peaks via averaging.
        % It is possible to condense the following redundant for loop to
        % reduce run time but this comes at the cost of messier syntax.
        % Each iteration this will replace both the high and low peaks
        % with their average value. This will not eliminate smaller
        % peaks, but these will not be caught with successive
        % iterations unless the averaging window expands, hence 2+it-1
        dataLog = [];
        dataLogN = [];
        for k = 1:length(peakLocs) % B location pchip smoothing
            % check for consecutive +/- peaks, average them
            hidx = find(abs(peakLocsN-peakLocs(k)) < (2+it-1), 1); % finds a consecutive positive/negative hyperbolic peaks
            if ~isempty(hidx)
                dataLog = [dataLog; k];
                dataLogN = [dataLogN; hidx];
                % TODO: dataRep = mean([peaks(k+[-it:it]); -1.*peaksN(hidx)]); smooth all points between the neighboring positive and negative peaks 
                dataRep = mean([peaks(k); -1.*peaksN(hidx)]); % note dataPeaksN is already positive instead of negative, so this average correctly force the consecutive +- peaks to be the average value, not largely positive
                data(peakLocs(k)) = dataRep; % replace both high and low peak with mean value
                data(peakLocsN(hidx)) = dataRep;
                % remove these corrected peaks from despiking this
                % iteration
            end
        end
    
        % Remove the resolved consecutive +/- peaks from the list
        peaks(dataLog) = [];
        peakLocs(dataLog) = [];
        peaksN(dataLogN) = [];
        peakLocsN(dataLogN) = [];
    
        % Consolidate +/- peaks into one list
        peakLocs = [peakLocs; peakLocsN];
        peakFrequencies = w(peakLocs);
    
        % remove peaks from data and frequency list
        data(peakLocs) = [];
        w(peakLocs) = [];
        
        % Interpolate to the peak locations
        smoothedPeaks = interp1(w, data, peakFrequencies, 'linear', 'extrap');

        % Concatenate new data at the peaks and sort by frequency
        w = [w; peakFrequencies];
        data = [data; smoothedPeaks];
        [w, sortMask] = sort(w);
        data = data(sortMask);
    end
    outData = data;
end
