classdef mask_dragBody

    methods(Static)

        
        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle
        %  - MaskObject
        %  - MaskWorkspace - Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            body = maskInitContext.MaskWorkspace.get("body");
            %%
            % Drag Body Morison Element: Off
            h = [gcb '/Morison Element and Viscous Damping Force Calculation/Morison Element Variant Subsystem/Morison Element Off'];
            responseName = ['sv_b' num2str(body.number) '_MEOff'];
            set_param(h,'VariantControl',responseName);
            %%
            % Drag Body Morison Element: On
            h = [gcb '/Morison Element and Viscous Damping Force Calculation/Morison Element Variant Subsystem/Morison Element On'];
            responseName = ['sv_b' num2str(body.number) '_MEOn'];
            set_param(h,'VariantControl',responseName);
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
        end
        



    end
end