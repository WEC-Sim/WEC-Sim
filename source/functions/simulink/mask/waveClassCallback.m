function waveClassCallback(blockHandle)
% Callback function for WaveClass
% Changes the visibility of wave parameters based on the wave type selected

% Get all wave parameters
mask = Simulink.Mask.get(blockHandle);
type = mask.getParameter('WaveClass');
H = mask.getParameter('H');
T = mask.getParameter('T');
waveElevationFile = mask.getParameter('waveElevationFile');
waveSpectrumFile = mask.getParameter('waveSpectrumFile');
spectrumType = mask.getParameter('spectrumType');
freqDisc = mask.getParameter('freqDisc');
phaseSeed = mask.getParameter('phaseSeed');
waveDir = mask.getParameter('waveDir');
waveSpread = mask.getParameter('waveSpread');

% Create variables for buttons used for Wave parameters
SpecButton = mask.getDialogControl('SpecButton');
ETAbutton = mask.getDialogControl('ETAbutton');

% Change visibilities of parameters/buttons based on WaveClass selection
switch type.Value
    case 'noWave'
        H.Visible = 'on';
        T.Visible = 'on';
        waveElevationFile.Visible = 'off';
        waveSpectrumFile.Visible = 'off';
        spectrumType.Visible = 'off';
        freqDisc.Visible = 'off';
        phaseSeed.Visible = 'off';
        waveDir.Visible = 'off';
        waveSpread.Visible = 'off';
        ETAbutton.Visible = 'off';
        SpecButton.Visible = 'off';
        
    case 'noWaveCIC'
        H.Visible = 'off';
        T.Visible = 'off';
        waveElevationFile.Visible = 'off';
        waveSpectrumFile.Visible = 'off';
        spectrumType.Visible = 'off';
        freqDisc.Visible = 'off';
        phaseSeed.Visible = 'off';
        waveDir.Visible = 'off';
        waveSpread.Visible = 'off';
        ETAbutton.Visible = 'off';
        SpecButton.Visible = 'off';
        
    case {'regular' 'regularCIC'}
        H.Visible = 'on';
        T.Visible = 'on';
        waveElevationFile.Visible = 'off';
        waveSpectrumFile.Visible = 'off';
        spectrumType.Visible = 'off';
        freqDisc.Visible = 'off';
        phaseSeed.Visible = 'off';
        waveDir.Visible = 'on';
        waveSpread.Visible = 'on';
        ETAbutton.Visible = 'off';
        SpecButton.Visible = 'off';
        
    case 'irregular'
        H.Visible = 'on';
        T.Visible = 'on';
        waveElevationFile.Visible = 'off';
        waveSpectrumFile.Visible = 'off';
        spectrumType.Visible = 'on';
        freqDisc.Visible = 'on';
        phaseSeed.Visible = 'on';
        waveDir.Visible = 'on';
        waveSpread.Visible = 'on';
        ETAbutton.Visible = 'off';
        SpecButton.Visible = 'off';
        
    case 'spectrumImport'
        H.Visible = 'off';
        T.Visible = 'off';
        waveElevationFile.Visible = 'off';
        waveSpectrumFile.Visible = 'on';
        spectrumType.Visible = 'off';
        freqDisc.Visible = 'off';
        phaseSeed.Visible = 'on';
        waveDir.Visible = 'off';
        waveSpread.Visible = 'off';
        ETAbutton.Visible = 'off';
        SpecButton.Visible = 'on';
        
    case 'waveImport'
        H.Visible = 'off';
        T.Visible = 'off';
        waveElevationFile.Visible = 'on';
        waveSpectrumFile.Visible = 'off';
        spectrumType.Visible = 'off';
        freqDisc.Visible = 'off';
        phaseSeed.Visible = 'off';
        waveDir.Visible = 'off';
        waveSpread.Visible = 'off';
        ETAbutton.Visible = 'on';
        SpecButton.Visible = 'off';
        
end
