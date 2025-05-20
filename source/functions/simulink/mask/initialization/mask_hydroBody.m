classdef mask_hydroBody

    methods(Static)
 
        
        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle
        %  - MaskObject
        %  - MaskWorkspace - Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            body = maskInitContext.MaskWorkspace.get("body");
            % Hydro Body Morison Element: Off
            h = [gcb '/Morison Element and Viscous Damping Force Calculation/Morison Element Variant Subsystem/Morison Element Off'];
            responseName = ['sv_b' num2str(body.number) '_MEOff'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Morison Element: On
            h = [gcb '/Morison Element and Viscous Damping Force Calculation/Morison Element Variant Subsystem/Morison Element On'];
            responseName = ['sv_b' num2str(body.number) '_MEOn'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Nonlinear Froude Krylov Force: Off
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/No Nonlinear FroudeKrylov Force'];
            responseName = ['sv_b' num2str(body.number) '_linearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Nonlinear Froude Krylov Force: On
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/With Nonlinear FroudeKrylov Force'];
            responseName = ['sv_b' num2str(body.number) '_nonlinearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Nonlinear Restoring: Off
            h = [gcb '/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Linear Hydrostatic Restoring Force'];
            responseName = ['sv_b' num2str(body.number) '_linearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Nonlinear Restoring: On
            h = [gcb '/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Nonlinear Hydrostatic Restoring Force'];
            responseName = ['sv_b' num2str(body.number) '_nonlinearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Regular Excitation Passive Yaw: Off
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Linear Wave Excitation Force Variant Subsystem/Regular Wave ' newline 'Excitation Force'];
            responseName = ['sv_regularWaves_b' num2str(body.number)];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Regular Excitation Passive Yaw: On
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Linear Wave Excitation Force Variant Subsystem/Regular Wave ' newline 'NonLinear Yaw'];
            responseName = ['sv_regularWavesYaw_b' num2str(body.number)];
            set_param(h,'VariantControl',responseName);
            %%    
            % Hydro Body Irregular Excitation Passive Yaw: Off
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Linear Wave Excitation Force Variant Subsystem/Irregular Wave ' newline 'Excitation Force'];
            responseName = ['sv_irregularWaves_b' num2str(body.number)];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Irregular Excitation Passive Yaw: On
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Linear Wave Excitation Force Variant Subsystem/Irregular Wave ' newline 'NonLinearYaw'];
            responseName = ['sv_irregularWavesYaw_b' num2str(body.number)];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Nonlinear Froude Krylov or Restoring: Instantaneous Free Surface
            h = [gcb '/Nonlinear Wave Elevation/Linear or Instantaneous Free Surface/Instantaneous Water Free Surface'];
            responseName = ['sv_b' num2str(body.number) '_instFS'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body Nonlinear Froude Krylov or Restoring: Mean Free Surface
            h = [gcb '/Nonlinear Wave Elevation/Linear or Instantaneous Free Surface/Mean Water Free Surface'];
            responseName = ['sv_b' num2str(body.number) '_meanFS'];
            set_param(h,'VariantControl',responseName);
            %% Variable hydro on/off
            % Variable hydro control - variable hydro off
            h = [gcb '/Variable Hydrodynamics Control/Variable Hydrodynamics Subsystem/noVariableHydro'];
            responseName = ['sv_b' num2str(body.number) '_noVariableHydro'];
            set_param(h,'VariantControl',responseName);
            % Variable hydro control - variable hydro on
            h = [gcb '/Variable Hydrodynamics Control/Variable Hydrodynamics Subsystem/variableHydro'];
            responseName = ['sv_b' num2str(body.number) '_variableHydro'];
            set_param(h,'VariantControl',responseName);
            % CIC - variable hydro off
            h = [gcb '/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation/Convolution Variant Subsystem/Convolution Integral Calculation'];
            responseName = ['sv_b' num2str(body.number) '_noVariableHydro'];
            set_param(h,'VariantControl',responseName);
            % CIC - variable hydro on
            h = [gcb '/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation/Convolution Variant Subsystem/Convolution Integral Surface Calculation'];
            responseName = ['sv_b' num2str(body.number) '_variableHydro'];
            set_param(h,'VariantControl',responseName);
            %% 
            % Hydro Body QTF: Off
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Second Order Excitation Force Variant Subsystem/No Second Order Excitation Force'];
            responseName = ['sv_b' num2str(body.number) '_noSecondOrderExt'];
            set_param(h,'VariantControl',responseName);
            %%
            % Hydro Body QTF: On
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Second Order Excitation Force Variant Subsystem/With Second Order Excitation Force'];
            responseName = ['sv_b' num2str(body.number) '_secondOrderExt'];
            set_param(h,'VariantControl',responseName);
            %% is this necessary:
            % % Set zero active variant controls to prevent label issue
            % set_param(gcb,'AllowZeroVariantControls','on');
            %%
            % geometry file name
            h=[gcb '/Structure/Body Properties'];
            geomFile=body.geometryFile;
            set_param(h,'ExtGeomFileName',geomFile);
            geomType='STL';
            % split version e.g. '9.10.0.16028 (R2021a)' into 9, 10, 0, NaN.
            % cannot compare str2double('9.10') because it becomes '9.1' 
            ver=split(version,'.');
            ver=str2double(ver(1:3));
            if ver(1) < 9 || (ver(1) == 9 && ver(2) < 6)
               set_param(h,'ExtGeomFileType',geomType);
            end
            % toWorkSpace: outputs
            h=[gcb '/To Workspace'];
            responseName=['body' num2str(body.number) '_out'];
            set_param(h,'VariableName',responseName);
            % toWorkSpace: hydrostatic pressures
            h=[gcb '/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Nonlinear Hydrostatic Restoring Force/To Workspace1'];
            responseName=['body' num2str(body.number) '_hspressure_out'];
            set_param(h,'VariableName',responseName); 
            % toWorkSpace: wave pressures (non-linear Freude-Krylov)
            h=[gcb '/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/With Nonlinear FroudeKrylov Force/To Workspace'];
            responseName=['body' num2str(body.number) '_wavenonlinearpressure_out'];
            set_param(h,'VariableName',responseName);
            % toWorkSpace: wave pressures (linear Freude-Krylov)
            h=[gcb '/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/With Nonlinear FroudeKrylov Force/To Workspace1'];
            responseName=['body' num2str(body.number) '_wavelinearpressure_out'];
            set_param(h,'VariableName',responseName);
            % position GoTo 
            h=[gcb '/Goto'];
            responseName=['disp' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % position From
            h=[gcb '/From'];
            responseName=['disp' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % velocity GoTo 
            h=[gcb '/Goto1'];
            responseName=['vel' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % velocity From 
            h=[gcb '/From1'];
            responseName=['vel' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % acceleration GoTo
            h=[gcb '/Goto2'];
            responseName=['acc' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % acceleration From 
            h=[gcb '/From2'];
            responseName=['acc' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % excitation force GoTo
            h = [gcb '/Goto3'];
            responseName = ['b' num2str(body.number) '_f_excitation'];
            set_param(h, 'GotoTag', responseName);
            % total force GoTo
            h = [gcb '/Goto4'];
            responseName = ['b' num2str(body.number) '_f_total'];
            set_param(h, 'GotoTag', responseName);
            
            %% Variable Hydro:
            % Variant subsystem
            h = [gcb '/Variable Hydrodynamics Control/Variable Hydrodynamics Subsystem'];
            responseName = ['sv_b' num2str(body.number) '_variableHydro'];
            set_param(h,'VariantControl',responseName);
            % body_hydroForceIndex To Workspace tags
            h=[gcb '/Variable Hydrodynamics Control/Variable Hydrodynamics Subsystem/variableHydro/To Workspace'];
            responseName=['body' num2str(body.number) '_hydroForceIndex'];
            set_param(h,'VariableName',responseName); 
            % body_hydroForceIndex From tags
            h=[gcb '/Variable Hydrodynamics Control/Variable Hydrodynamics Subsystem/variableHydro/From'];
            responseName=['body' num2str(body.number) '_hydroForceIndex'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation/Convolution Variant Subsystem/Convolution Integral Surface Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForceIndex'];
            set_param(h,'GotoTag',responseName);
            % body_hydroForce GoTo
            h=[gcb '/Variable Hydrodynamics Control/Goto'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            % body_hydroForce From tags
            h=[gcb '/Wave Diffraction and Excitation Force Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Wave Radiation Forces Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Constant Coefficients/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation/Convolution Variant Subsystem/Convolution Integral Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Linear Hydrostatic Restoring Force/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Nonlinear Hydrostatic Restoring Force/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Hydrostatic Restoring Force Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/From3'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            % Update body.hydroForce constant data type
            h=[gcb '/Variable Hydrodynamics Control/Constant'];
            busName=['Bus: bus_body' num2str(body.number) '_hydroForce'];
            set_param(h,'OutDataTypeStr',busName);
        end
        



    end
end