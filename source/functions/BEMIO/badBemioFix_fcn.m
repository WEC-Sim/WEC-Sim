% Dominic D. Forbush 
% Copyright Sandia National Laboratories 2023.
% 
% This is a cleanup function for BEMIO coefficients. 
% 
% Parameters
% ------------
%     filename : {1 x 1} cell of strings
%         Defines the output file of interest. If the code is AQWA, this 
%         needs to be {1x2} where {1} is the 'ah1' and {2} is the 'lis'
% 
%     code : [1 1] string
%         Name of the BEM code, used to select the readBEM function. A
%         string either 'WAMIT','CAPYTAINE','NEMOH',or 'AQWA'
% 
%     deSpike : [1 1] struct
%         Contains the despike parameters. For description and field names,
%         look at the line with "if isempty(deSpike)" to see what 
%         parameters are available. 
% 
%     plotDofs: [2 x N] vector
%         Describes the dofs of interest to plot. For example, 
%         [1,1;3,3;3,5] will plot surge, heave, and cross coupling 
%         heave-to-pitch, respectively. 
%
% Returns
% ------------
%     hydro : struct
%         Output BEMIO structure
% 
%% This has to be run from the BEMIO output directory to work properly, otherwise
% the bemio call won't work.
function outHydro = badBemioFix_fcn(fileName,code,deSpike,plotDofs)

% first call BEMIO
hydro = struct();
switch code
    case  'WAMIT'
        hydro = readWAMIT(hydro,fileName{1},[]);
    case 'CAPYTAINE'
        hydro= readCAPYTAINE(hydro,fileName{1});
    case 'NEMOH'
        hydro = readNEMOH(hydro,fileName); 
    case 'AQWA'
        hydro = readAQWA(hydro,fileName{1},fileName{2});
end
dw=mean(diff(hydro.w));

%% de-spiking parameters
% you can still specify other arguments of findpeaks when the function is
% called, these are just the only ones initialized here. 

% maxPeakWidth is not recommended however as it has unexpected behavior

if isempty(deSpike) % if the third argument is empty will use some default values
    deSpike = struct();
    deSpike.negThresh = 1e-3; % the threshold below which negative damping will be removed
    deSpike.N = 6; % will loop the despiking procedure N time before filtering
    deSpike.appFilt = 1; % boolean, 1 to apply low pass filter after despiking
    
    % thresholds: applied to 'Threshold' argument of findpeaks
    deSpike.Threshold.B = 2e-3; % damping
    deSpike.Threshold.A = 1e-2; % added mass
    deSpike.Threshold.ExRe = 1e-2; % real part excitation
    deSpike.Threshold.ExIm = 1e-2; % imag part excitation
    
    % minimum peak prominence, applied to 'MinPeakProminence' argument of findpeaks 
    deSpike.Prominence.B = 2e-3;  
    deSpike.Prominence.A = 1e-2; 
    deSpike.Prominence.ExRe = 1e-2;  
    deSpike.Prominence.ExIm = 1e-2; 
    
    % minimum peak distance, applied to 'MinPeakDistance' argument of findpeaks 
    deSpike.MinPeakDistance.A = 0.52;
    deSpike.MinPeakDistance.B = 0.52;
    deSpike.MinPeakDistance.ExRe = 0.52;
    deSpike.MinPeakDistance.ExIm = 0.52;
    deSpike.Filter.b = 0.02008336556421123561544384017452102853 .* [1 2 1];
    deSpike.Filter.a = [1 -1.561018075800718163392843962355982512236 0.641351538057563175243558362126350402832];
    
    % IRF parameters
    deSpike.IRF.wMin = 0.1;
    deSpike.IRF.wMax = 15;
    deSpike.IRF.irfDur = 5;
    
    % debug plot
    deSpike.debugPlot =0;
end

% debugPlot = 1; % set 1 to make excitation debug plots.
%% calc original IRF and plot
hydro = radiationIRF(hydro,201,501,501,[],[]);
hydro = radiationIRFSS(hydro,5,0.85);
hydro = excitationIRF(hydro,201,[],[],[],[]);
% hydro = radiationIRF(hydro,deSpike.IRF.irfDur,[],[],deSpike.IRF.wMin,deSpike.IRF.wMax);
% hydro = radiationIRFSS(hydro,deSpike.IRF.irfDur,0.85);
% hydro = excitationIRF(hydro,deSpike.IRF.irfDur,[],[],deSpike.IRF.wMin,deSpike.IRF.wMax);
writeBEMIOH5(hydro);
hydro.plotDofs = plotDofs;%[1,1;3,3;5,5;7,7;3,7;7,3];
plotBEMIO(hydro);
figureNumber = length(get(findall(0, 'Type', 'figure'), 'Number'));
spreadfigures(figureNumber:-1:figureNumber-6+1)

%% rad and mass fixes
[row,col,~] = size(hydro.B);
% parse negative radiation damping
for k = 1:row
    for kk = 1:col
        bPks(k,kk) = max(squeeze(hydro.B(k,kk,:)));
        p1Idx = find(abs(hydro.B(k,kk,:)) > deSpike.negThresh * bPks(k,kk));
        p2Idx = find(hydro.B(k,kk,:) < 0);
        pIdx = intersect(p1Idx,p2Idx);
        hydro.B(k,kk,pIdx) = 0;
    end
end

for k = 1:row
    for kk = 1:col
        for it = deSpike.N
            % positive peaks
            testB = squeeze(hydro.B(k,kk,:));
            [BPeaks,BLocs] = findpeaks(testB,'MinPeakProminence',deSpike.Prominence.B,'Threshold',deSpike.Threshold.B,'MinPeakDistance',deSpike.MinPeakDistance.B);
            BLocs(BLocs>length(testB)-2) = []; % trim end extrema
            BLocs(BLocs<2) = []; % trim start extrema
            testA = squeeze(hydro.A(k,kk,:)); %
            [APeaks,ALocs] = findpeaks(testA,'MinPeakProminence',deSpike.Prominence.A,'Threshold',deSpike.Threshold.A,'MinPeakDistance',deSpike.MinPeakDistance.A);
            %%% There is a "maxPeakWidth" argument: this does not work as
            %%% the developer intends and is not recommended for use.
            ALocs(ALocs>length(testA)-2) = [];
            ALocs(ALocs<2) = []; % trim start extrema

            % negative peaks
            [BPeaksN,BLocsN] = findpeaks(-1.*testB,'MinPeakProminence',deSpike.Prominence.B,'Threshold',deSpike.Threshold.B,'MinPeakDistance',deSpike.MinPeakDistance.B);
            BLocsN(BLocsN>length(testB)-2) = []; % trim end extrema
            BLocsN(BLocsN<2) = []; % trim start extrema
            [APeaksN,ALocsN] = findpeaks(-1.*testA,'MinPeakProminence',deSpike.Prominence.A,'Threshold',deSpike.Threshold.A,'MinPeakDistance',deSpike.MinPeakDistance.A);
            ALocsN(ALocsN>length(testA)-2) = [];
            ALocsN(ALocsN<2) = []; % trim start extrema

            % smooth hyperbolic peaks via averaging
            BLog = [];
            BLogN = [];
            for kkk=1:length(BLocs) % B location pchip smoothing
                % check for consecutive +/- peaks, average them
                hidx = find(abs(BLocsN-BLocs(kkk))<(2+it-1),1); % finds a consecutive positive/negative hyperbolic peaks
                if ~isempty(hidx)
                   BLog = [BLog; kkk];  
                   BLogN = [BLogN; hidx];
                   BRep = mean([BPeaks(kkk); -1.*BPeaksN(hidx)]);
                   hydro.B(k,kk,BLocs(kkk)) = BRep; % replace both high and low peak with mean value
                   hydro.B(k,kk,BLocsN(hidx)) = BRep;
                   % remove these corrected peaks from despiking this
                   % iteration
                end
            end
            BPeaks(BLog) = []; BLocs(BLog)=[]; BPeaksN(BLogN) = []; BLocsN(BLogN)=[];
            %%% It is possible to condense the redundant for loop to
            %%% reduce run time but this comes at the cost of messier syntax
            % each iteration this will replace both the high and low peaks
            % with their average value. This will not eliminate smaller
            % peaks, but these will not be caught with successive
            % iterations unless the averaging window expands, hence 2+it-1

            % smooth positive peaks via interpolation amongst surrounding
            % points
            for kkk=1:length(BLocs)
                try
                BRep = interp1([hydro.w(BLocs(kkk)-2);hydro.w(BLocs(kkk)-1);hydro.w(BLocs(kkk)+1);hydro.w(BLocs(kkk)+2)],...
                    [hydro.B(k,kk,BLocs(kkk)-2);hydro.B(k,kk,BLocs(kkk)-1);hydro.B(k,kk,BLocs(kkk)+1);hydro.B(k,kk,BLocs(kkk)+2)],hydro.w(BLocs(kkk)),'linear');
                hydro.B(k,kk,BLocs(kkk))=BRep;
                catch
                    disp(0)
                    hydro.B(k,kk,BLocs(kkk))=hydro.B(k,kk,BLocs(kkk));
                end
            end

            ALog = [];
            ALogN = [];
           for kkk=1:length(ALocs) % B location pchip smoothing
                % check for consecutive +/- peaks, average them
                hidx = find(abs(ALocsN-ALocs(kkk))<(2+it-1),1); % finds a consecutive positive/negative hyperbolic peaks
                if ~isempty(hidx)
                   ALog = [ALog; kkk];
                   ALogN = [ALogN; hidx];
                   ARep = mean([APeaks(kkk);-1.*APeaksN(hidx)]); % flips N peaks back to correct sign 
                   hydro.A(k,kk,ALocs(kkk)) = ARep; % replace both high and low peak with mean value
                   hydro.A(k,kk,ALocsN(hidx)) = ARep;
                   % remove these corrected peaks from despiking this
                   % iteration
                end
           end
           APeaks(ALog) = []; ALocs(ALog)=[]; APeaksN(ALogN) = []; ALocsN(ALogN)=[];
            % smooth positive peaks via interpolation amongst surrounding
            % points
            for kkk=1:length(ALocs) % A location pchip smoothing
                try
                ARep =interp1([hydro.w(ALocs(kkk)-2),hydro.w(ALocs(kkk)-1),hydro.w(ALocs(kkk)+1),hydro.w(ALocs(kkk)+2)],...
                    [hydro.A(k,kk,ALocs(kkk)-2),hydro.A(k,kk,ALocs(kkk)-1),hydro.A(k,kk,ALocs(kkk)+1),hydro.A(k,kk,ALocs(kkk)+2)],hydro.w(ALocs(kkk)),'linear');
                hydro.A(k,kk,ALocs(kkk))=ARep;
                catch
                    disp(1)
                    hydro.A(k,kk,ALocs(kkk))=hydro.A(k,kk,ALocs(kkk));
                end
            end

            % smooth negative peaks via interpolation amongst surrounding
            % points
            for kkk=1:length(BLocsN) % B location pchip smoothing
                try
                BRep = interp1([hydro.w(BLocsN(kkk)-2);hydro.w(BLocsN(kkk)-1);hydro.w(BLocsN(kkk)+1);hydro.w(BLocsN(kkk)+2)],...
                    [hydro.B(k,kk,BLocsN(kkk)-2);hydro.B(k,kk,BLocsN(kkk)-1);hydro.B(k,kk,BLocsN(kkk)+1);hydro.B(k,kk,BLocsN(kkk)+2)],hydro.w(BLocsN(kkk)),'linear');
                hydro.B(k,kk,BLocsN(kkk))=BRep;
                catch
                    disp(2)
                    hydro.B(k,kk,BLocsN(kkk))=hydro.B(k,kk,BLocsN(kkk));
                end
            end
            for kkk=1:length(ALocsN) % A location pchip smoothing
                ARep = interp1([hydro.w(ALocsN(kkk)-2),hydro.w(ALocsN(kkk)-1),hydro.w(ALocsN(kkk)+1),hydro.w(ALocsN(kkk)+2)],...
                    [hydro.A(k,kk,ALocsN(kkk)-2),hydro.A(k,kk,ALocsN(kkk)-1),hydro.A(k,kk,ALocsN(kkk)+1),hydro.A(k,kk,ALocsN(kkk)+2)],hydro.w(ALocsN(kkk)),'linear');
                hydro.A(k,kk,ALocsN(kkk))=ARep;
            end
            clear testA testB BLocs BPeaks ALocs APeaks BLocsN BPeaksN ALocsN APeaksN
        end
        if deSpike.appFilt == 1
            B_smooth(k,kk,:) = filtfilt(deSpike.Filter.b,deSpike.Filter.a,squeeze(hydro.B(k,kk,:)));
            A_smooth(k,kk,:) = filtfilt(deSpike.Filter.b,deSpike.Filter.a,squeeze(hydro.A(k,kk,:)));
        end
    end
end

%% excitation fixes
for k=1:row
    for it =1:deSpike.N
        % real part despiking
        test = squeeze(hydro.ex_re(k,1,:));
        [ExPeaks,ExLocs] = findpeaks(test,'MinPeakProminence',deSpike.Prominence.ExRe,'Threshold',deSpike.Threshold.ExRe,'MinPeakDistance',deSpike.MinPeakDistance.ExRe);
        ExLocs(ExLocs>length(test)-2) = [];
        ExLocs(ExLocs<2) = [];
        [ExPeaksN,ExLocsN] = findpeaks(-.1*test,'MinPeakProminence',deSpike.Prominence.ExRe,'Threshold',deSpike.Threshold.ExRe,'MinPeakDistance',deSpike.MinPeakDistance.ExRe);
        ExLocsN(ExLocsN>length(test)-2) = [];
        ExLocsN(ExLocsN<2) = [];
        
        ExLog=[]; ExLogN = [];
        for kk=1:length(ExLocs)
            hidx = find(abs(ExLocsN-ExLocs(kk))<2,1);
            if ~isempty(hidx)
                ExLog = [ExLog; kk];
                ExLogN = [ExLogN; hidx];
                ExRep = mean([-1.*ExPeaksN(hidx);ExPeaks(kk)]);
                hydro.ex_re(k,1,ExLocs(kk))=ExRep;
                hydro.ex_re(k,1,ExLocsN(hidx))=ExRep;
            end
        end
        ExPeaks(ExLog) = []; ExLocs(ExLog)=[]; ExPeaksN(ExLogN) = []; ExLocsN(ExLogN)=[];

        for kk =1:length(ExLocs) % real part positive peaks
            try
            ExRep = interp1([hydro.w(ExLocs(kk)-2),hydro.w(ExLocs(kk)-1),hydro.w(ExLocs(kk)+1),hydro.w(ExLocs(kk)+2)],...
                [hydro.ex_re(k,1,ExLocs(kk)-2),hydro.ex_re(k,1,ExLocs(kk)-1),hydro.ex_re(k,1,ExLocs(kk)+1),hydro.ex_re(k,1,ExLocs(kk)+2)],hydro.w(ExLocs(kk)),'linear');
            hydro.ex_re(k,1,ExLocs(kk)) = ExRep;
            catch
                disp(3)
                hydro.ex_re(k,1,ExLocs(kk)) = hydro.ex_re(k,1,ExLocs(kk));
            end
        end

        for kk =1:length(ExLocsN) % real part negative peaks
            try
            ExRep = interp1([hydro.w(ExLocsN(kk)-2),hydro.w(ExLocsN(kk)-1),hydro.w(ExLocsN(kk)+1),hydro.w(ExLocsN(kk)+2)],...
                [hydro.ex_re(k,1,ExLocsN(kk)-2),hydro.ex_re(k,1,ExLocsN(kk)-1),hydro.ex_re(k,1,ExLocsN(kk)+1),hydro.ex_re(k,1,ExLocsN(kk)+2)],hydro.w(ExLocsN(kk)),'linear');
            hydro.ex_re(k,1,ExLocsN(kk)) = ExRep;
            catch
                disp(4)
                hydro.ex_re(k,1,ExLocsN(kk)) = hydro.ex_re(k,1,ExLocsN(kk));
            end
        end

        % imaginary part despiking
        test = squeeze(hydro.ex_im(k,1,:));
        [ExPeaks,ExLocs] = findpeaks(test,'MinPeakProminence',deSpike.Prominence.ExIm,'Threshold',deSpike.Threshold.ExIm,'MinPeakDistance',deSpike.MinPeakDistance.ExIm);
        ExLocs(ExLocs>length(test)-2) = [];
        ExLocs(ExLocs<2) = [];

        [ExPeaksN,ExLocsN] = findpeaks(-.1*test,'MinPeakProminence',deSpike.Prominence.ExIm,'Threshold',deSpike.Threshold.ExIm,'MinPeakDistance',deSpike.MinPeakDistance.ExIm);
        ExLocsN(ExLocsN>length(test)-2) = [];
        ExLocsN(ExLocsN<2) = [];

        ExLog=[]; ExLogN = [];
        for kk=1:length(ExLocs)
            hidx = find(abs(ExLocsN-ExLocs(kk))<2,1);
            if ~isempty(hidx)
                ExLog = [ExLog; kk];
                ExLogN = [ExLogN; hidx];
                ExRep = mean([-1.*ExPeaksN(hidx); ExPeaks(kk)]);
                hydro.ex_re(k,1,ExLocs(kk))=ExRep;
                hydro.ex_re(k,1,ExLocsN(hidx))=ExRep;
            end
        end
        ExPeaks(ExLog) = []; ExLocs(ExLog)=[]; ExPeaksN(ExLogN) = []; ExLocsN(ExLogN)=[];
       
        for kk =1:length(ExLocs) % real part positive peaks
            try
            ExRep = interp1([hydro.w(ExLocs(kk)-2),hydro.w(ExLocs(kk)-1),hydro.w(ExLocs(kk)+1),hydro.w(ExLocs(kk)+2)],...
                [hydro.ex_im(k,1,ExLocs(kk)-2),hydro.ex_im(k,1,ExLocs(kk)-1),hydro.ex_im(k,1,ExLocs(kk)+1),hydro.ex_im(k,1,ExLocs(kk)+2)],hydro.w(ExLocs(kk)),'linear');
            hydro.ex_im(k,1,ExLocs(kk)) = ExRep;
            catch
                disp(5)
                hydro.ex_im(k,1,ExLocs(kk)) = hydro.ex_im(k,1,ExLocs(kk));
            end
        end

        for kk =1:length(ExLocsN) % imaginary part negative peaks
            try
            ExRep = interp1([hydro.w(ExLocsN(kk)-2),hydro.w(ExLocsN(kk)-1),hydro.w(ExLocsN(kk)+1),hydro.w(ExLocsN(kk)+2)],...
                [hydro.ex_im(k,1,ExLocsN(kk)-2),hydro.ex_im(k,1,ExLocsN(kk)-1),hydro.ex_im(k,1,ExLocsN(kk)+1),hydro.ex_im(k,1,ExLocsN(kk)+2)],hydro.w(ExLocsN(kk)),'linear');
            hydro.ex_im(k,1,ExLocsN(kk)) = ExRep;
            catch
                disp(6)
                hydro.ex_im(k,1,ExLocsN(kk)) = hydro.ex_im(k,1,ExLocsN(kk));
            end
        end
        %     sc_ma_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.sc_ma(k,1,:)));
        %     sc_ph_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.sc_ph(k,1,:)));
        %     sc_re_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.sc_re(k,1,:)));
        %     sc_im_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.sc_im(k,1,:)));
        %     fk_ma_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.fk_ma(k,1,:)));
        %     fk_ph_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.fk_ph(k,1,:)));
        %     fk_re_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.fk_re(k,1,:)));
        %     fk_im_smooth(row,1,:) = filtfilt(b,a,squeeze(hydro.fk_im(k,1,:)));

        clear test ExLocs ExPeaks ExLocsN ExPeaksN

       
end
if deSpike.appFilt==1;
    %ex_ma_smooth(k,1,:) = filtfilt(b,a,squeeze(hydro.ex_ma(k,1,:)));
    %ex_ph_smooth(k,1,:) = filtfilt(b,a,squeeze(hydro.ex_ph(k,1,:)));
    ex_re_smooth(k,1,:) = filtfilt(deSpike.Filter.b,deSpike.Filter.a,squeeze(hydro.ex_re(k,1,:)));
    ex_im_smooth(k,1,:) = filtfilt(deSpike.Filter.b,deSpike.Filter.a,squeeze(hydro.ex_im(k,1,:)));
end
end

if deSpike.appFilt ==1
    hydro.A = A_smooth;
    hydro.B = B_smooth;
   %hydro.ex_ma = ex_ma_smooth;
    %hydro.ex_ph = ex_ph_smooth;
    hydro.ex_re = ex_re_smooth;
    hydro.ex_im = ex_im_smooth;
    hydro.ex_ma = (hydro.ex_re.^2 + hydro.ex_im.^2).^0.5;  % Magnitude of excitation force
    hydro.ex_ph = angle(hydro.ex_re + 1i*hydro.ex_im);     % Phase of excitation force
end
% hydro.sc_ma = sc_ma_smooth;
% hydro.sc_ph = sc_ph_smooth;
% hydro.sc_re = sc_re_smooth;
% hydro.sc_im = sc_im_smooth;
% hydro.fk_ma = fk_ma_smooth;
% hydro.fk_ph = fk_ph_smooth;
% hydro.fk_re = fk_re_smooth;
% hydro.fk_im = fk_im_smooth;

hydro.file = [hydro.file '_clean']; % rename so that original H5 is not overwritten
hydro = radiationIRF(hydro,201,501,501,[],[]);
hydro = radiationIRFSS(hydro,5,0.85);
hydro = excitationIRF(hydro,201,[],[],[],[]);
hydro.plotDofs = plotDofs;
writeBEMIOH5(hydro);
plotBEMIO(hydro);
figureNumber = length(get(findall(0, 'Type', 'figure'), 'Number'));
spreadfigures(figureNumber:-1:figureNumber-6+1)

outHydro = hydro;

if deSpike.debugPlot == 1
    % real part excitation
    figure; clf;
    for k=1:col
     subplot(2,col,k)
     plot(hydro.w,squeeze(hydro.ex_re(k,1,:)));
     ylabel('Re(Ex)')
     subplot(2,col,col+k)
     plot(hydro.w,squeeze(hydro.ex_im(k,1,:)));
     ylabel('Im(Ex)')
     xlabel('w (rad/s)')
    end
end

