classdef mask_flexBody

    methods(Static)

        
        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle
        %  - MaskObject
        %  - MaskWorkspace - Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            body = maskInitContext.MaskWorkspace.get("body");
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
            h=[gcb '/Hydrostatic Restoring Force Calculation/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Nonlinear Hydrostatic Restoring Force/To Workspace1'];
            responseName=['body' num2str(body.number) '_hspressure_out'];
            set_param(h,'VariableName',responseName); 
            % toWorkSpace: wave pressures (nonlinear Froude-Krylov)
            h=[gcb '/Wave Diffraction and Excitation Force Calculation/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/With Nonlinear FroudeKrylov Force/To Workspace'];
            responseName=['body' num2str(body.number) '_wavenonlinearpressure_out'];
            set_param(h,'VariableName',responseName);
            % toWorkSpace: wave pressures (linear Froude-Krylov)
            h=[gcb '/Wave Diffraction and Excitation Force Calculation/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/With Nonlinear FroudeKrylov Force/To Workspace1'];
            responseName=['body' num2str(body.number) '_wavelinearpressure_out'];
            set_param(h,'VariableName',responseName);
            % position: GoTo 
            h=[gcb '/Goto'];
            responseName=['disp' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % position: From
            h=[gcb '/From'];
            responseName=['disp' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % velocity: GoTo 
            h=[gcb '/Goto1'];
            responseName=['vel' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % velocity: From 
            h=[gcb '/From1'];
            responseName=['vel' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % acceleration: GoTo 
            h=[gcb '/Goto2'];
            responseName=['acc' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
            % acceleration: From 
            h=[gcb '/From2'];
            responseName=['acc' num2str(body.number)];
            set_param(h,'GotoTag',responseName);
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
            % body_hydroForce GoTo
            h=[gcb '/Variable Hydrodynamics Control/Goto'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            % body_hydroForce From tags
            h=[gcb '/Wave Diffraction and Excitation Force Calculation/Wave Diffraction and Excitation Force Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Wave Radiation Forces Calculation/Wave Radiation Forces Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Wave Radiation Forces Calculation/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Constant Coefficients/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Wave Radiation Forces Calculation/Wave Radiation Forces Calculation/SS CI and Constant-Damping-CoeVariant Subsystem/Convolution Integral Calculation/Convolution Variant Subsystem/Convolution Integral Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Hydrostatic Restoring Force Calculation/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Linear Hydrostatic Restoring Force/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Hydrostatic Restoring Force Calculation/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Nonlinear Hydrostatic Restoring Force/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Hydrostatic Restoring Force Calculation/Hydrostatic Restoring Force Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Morrison Element and Viscous Damping Force Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/Additional Linear Damping Force Calculation/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            h=[gcb '/FlexibleBody/From'];
            responseName=['body' num2str(body.number) '_hydroForce'];
            set_param(h,'GotoTag',responseName);
            % Update body.hydroForce constant data type
            h=[gcb '/Variable Hydrodynamics Control/Constant'];
            busName=['Bus: bus_body' num2str(body.number) '_hydroForce'];
            set_param(h,'OutDataTypeStr',busName);
            %%
            % Flex Body Morison Element: Off
            h = [gcb '/Morrison Element and Viscous Damping Force Calculation/Morison Element and Viscous Damping Force Calculation/Morison Element Variant Subsystem/Morison Element Off'];
            responseName = ['sv_b' num2str(body.number) '_MEOff'];
            set_param(h,'VariantControl',responseName);
            %%
            % Flex Body Morison Element: On
            h = [gcb '/Morrison Element and Viscous Damping Force Calculation/Morison Element and Viscous Damping Force Calculation/Morison Element Variant Subsystem/Morison Element On'];
            responseName = ['sv_b' num2str(body.number) '_MEOn'];
            set_param(h,'VariantControl',responseName);
            %%
            % Flex Body Nonlinear FroudeKrylov Force: Off
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/No Nonlinear FroudeKrylov Force'];
            responseName = ['sv_b' num2str(body.number) '_linearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Flex Body Nonlinear FroudeKrylov Force: On
            h = [gcb '/Wave Diffraction and Excitation Force Calculation/Wave Diffraction and Excitation Force Calculation/Nonlinear FK Force Variant Subsystem/With Nonlinear FroudeKrylov Force'];
            responseName = ['sv_b' num2str(body.number) '_nonlinearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Flex Body Nonlinear Restoring: Off
            h = [gcb '/Hydrostatic Restoring Force Calculation/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Linear Hydrostatic Restoring Force'];
            responseName = ['sv_b' num2str(body.number) '_linearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Flex Body Nonlinear Restoring: On
            h = [gcb '/Hydrostatic Restoring Force Calculation/Hydrostatic Restoring Force Calculation/Linear and Nonlinear Restoring Force Variant Subsystem/Nonlinear Hydrostatic Restoring Force'];
            responseName = ['sv_b' num2str(body.number) '_nonlinearHydro'];
            set_param(h,'VariantControl',responseName);
            %%
            % Flex Body Nonlinear FroudeKrylov or Restoring: Instantaneous Free Surface
            h = [gcb '/Nonlinear Wave Elevation/Linear or Instantaneous Free Surface/Instantaneous Water Free Surface'];
            responseName = ['sv_b' num2str(body.number) '_instFS'];
            set_param(h,'VariantControl',responseName);
            %%
            % Flex Body Nonlinear FroudeKrylov or Restoring: Mean Free Surface
            h = [gcb '/Nonlinear Wave Elevation/Linear or Instantaneous Free Surface/Mean Water Free Surface'];
            responseName = ['sv_b' num2str(body.number) '_meanFS'];
            set_param(h,'VariantControl',responseName);
            %%
        end
        



    end
end