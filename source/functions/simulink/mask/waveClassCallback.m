function waveClassCallback(blockHandle)
% Callback function for WaveClass
% Changes the visibility of wave parameters based on the wave type selected

    % Get all wave parameters
    mask = Simulink.Mask.get(blockHandle);
    type = mask.getParameter('WaveClass');
    height = mask.getParameter('height');
    period = mask.getParameter('period');
    elevationFile = mask.getParameter('elevationFile');
    spectrumFile = mask.getParameter('spectrumFile');
    spectrumType = mask.getParameter('spectrumType');
    option = mask.getParameter('option');
    phaseSeed = mask.getParameter('phaseSeed');
    direction = mask.getParameter('direction');
    spread = mask.getParameter('spread');

    % Create variables for buttons used for Wave parameters
    SpecButton = mask.getDialogControl('SpecButton');
    ETAbutton = mask.getDialogControl('ETAbutton');

    % Change visibilities of parameters/buttons based on WaveClass selection
    switch type.Value
        case 'noWave'
            height.Visible = 'on';
            period.Visible = 'on';
            elevationFile.Visible = 'off';
            spectrumFile.Visible = 'off';
            spectrumType.Visible = 'off';
            option.Visible = 'off';
            phaseSeed.Visible = 'off';
            direction.Visible = 'off';
            spread.Visible = 'off';
            ETAbutton.Visible = 'off';
            SpecButton.Visible = 'off';

        case 'noWaveCIC'
            height.Visible = 'off';
            period.Visible = 'off';
            elevationFile.Visible = 'off';
            spectrumFile.Visible = 'off';
            spectrumType.Visible = 'off';
            option.Visible = 'off';
            phaseSeed.Visible = 'off';
            direction.Visible = 'off';
            spread.Visible = 'off';
            ETAbutton.Visible = 'off';
            SpecButton.Visible = 'off';

        case {'regular' 'regularCIC'}
            height.Visible = 'on';
            period.Visible = 'on';
            elevationFile.Visible = 'off';
            spectrumFile.Visible = 'off';
            spectrumType.Visible = 'off';
            option.Visible = 'off';
            phaseSeed.Visible = 'off';
            direction.Visible = 'on';
            spread.Visible = 'on';
            ETAbutton.Visible = 'off';
            SpecButton.Visible = 'off';

        case 'irregular'
            height.Visible = 'on';
            period.Visible = 'on';
            elevationFile.Visible = 'off';
            spectrumFile.Visible = 'off';
            spectrumType.Visible = 'on';
            option.Visible = 'on';
            phaseSeed.Visible = 'on';
            direction.Visible = 'on';
            spread.Visible = 'on';
            ETAbutton.Visible = 'off';
            SpecButton.Visible = 'off';

        case 'spectrumImport'
            height.Visible = 'off';
            period.Visible = 'off';
            elevationFile.Visible = 'off';
            spectrumFile.Visible = 'on';
            spectrumType.Visible = 'off';
            option.Visible = 'off';
            phaseSeed.Visible = 'on';
            direction.Visible = 'off';
            spread.Visible = 'off';
            ETAbutton.Visible = 'off';
            SpecButton.Visible = 'on';

        case 'elevationImport'
            height.Visible = 'off';
            period.Visible = 'off';
            elevationFile.Visible = 'on';
            spectrumFile.Visible = 'off';
            spectrumType.Visible = 'off';
            option.Visible = 'off';
            phaseSeed.Visible = 'off';
            direction.Visible = 'off';
            spread.Visible = 'off';
            ETAbutton.Visible = 'on';
            SpecButton.Visible = 'off';

    end
end