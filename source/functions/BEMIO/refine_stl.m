% Refine STL
% This function refines input STL mesh to a panel area that is less than
% the specified threshold via the midpoint method. The mesh panels that
% arise from this refinement will have the same normal vector as the panel
% from which they derive.

%INPUTS
% stl_file: A string, including .stl extension, designating the STL file to
%   refine.
% stl_eol: 1 or 2. See import_stl_fast description.
% maxPanelArea: the maximum allowable panel area. Panels in excess of this
%   area will be refined. 
% saveName: the name of the refined stl file to save, including the .stl
%   extension
% saveDir: the directory where the refined stl file will be saved. If
%   empty, saves to current directory.

%OUTPUTS
% stl_info: A 7-field structure containing inital and final mesh
%   information.
%       A_init contains initial panel area.
%       A_final contains final panel areas.
%       V_init contains initial vertex locations.
%       V_final contains final vertex locations.
%       N_init contains initial normal vectors.
%       N_final contains final normal vectors.
%       Refine_Name is a string containing the name of refined stl file.
% The refined stl file is automatically saved to 'saveDir' as 'saveName'.

% PLEASE: post questions, bug reports, feature requests, etc. to:
% https://github.com/WEC-Sim/wec-sim/issues.

function out=refine_stl(stl_file, stl_eol, maxPanelArea, saveName, saveDir);

%% read stl file

[V,N(:,[1:3])]=import_stl_fast(stl_file,2,stl_eol); %note that these are UNIT normals
FaceNum=length(N);

% place each panel into cell, calculate panel area

for k=1:FaceNum
    V_ref{k,1}=V((k*3)-2:k*3,:); % pulls 3 vertices per panel
    A_ref.init(k,1)=norm(cross(V_ref{k,1}(2,:)-V_ref{k,1}(1,:),...
        V_ref{k,1}(3,:)-V_ref{k,1}(1,:)))/2; % area of the panel, via cross product properties
    N_ref{k,1}=N(k,:); % unit normal vectors
end

%% MaxPanelArea method

%% flag large panels
% pre-allocate
largePanelFlag=zeros(FaceNum,1);

% Find large panels
fname{1}='init';
idx=find(A_ref.(fname{1})>maxPanelArea);
largePanelFlag(idx)=1;
itNum=1;
%% Perform centroid refinement on flagged panels
while ~isempty(idx)
    % pre-allocate to array size
    V_ref(1:length(V_ref(:,itNum))+3*length(idx),itNum+1)=...
        cell(length(V_ref(:,itNum))+3*length(idx),1);
    PanelNum=1;
    fname{itNum+1}=strcat('itNum',num2str(itNum));
    for k=1:length(largePanelFlag)
        if largePanelFlag(k)==0; % if panel not too large, replicated exactly
            V_ref{PanelNum,itNum+1}=V_ref{k,itNum};
            N_ref{PanelNum,itNum+1}= N_ref{k,itNum};
            A_ref.(fname{itNum+1})(PanelNum,1)=A_ref.(fname{itNum})(k);
            
            % update Panel Number
            PanelNum=PanelNum+1;
            
        else % if panel too large, refine using midpoint method
            % find midpoint of each panel boundary
            MP12=mean(V_ref{k,itNum}([1:2],:));
            MP23=mean(V_ref{k,itNum}([2:3],:));
            MP13=mean(V_ref{k,itNum}([1,3],:));
            
            % refine large panel
            V_ref{PanelNum,itNum+1}=[V_ref{k,itNum}(1,:);MP12; MP13];
            V_ref{PanelNum+1,itNum+1}=[V_ref{k,itNum}(2,:);MP12; MP23];
            V_ref{PanelNum+2,itNum+1}=[V_ref{k,itNum}(3,:);MP23; MP13];
            V_ref{PanelNum+3,itNum+1}=[MP12 ;MP23; MP13];
            
            % normal vectors are all the same as the seed panel
            N_ref{PanelNum,itNum+1}=N_ref{k,itNum};
            N_ref{PanelNum+1,itNum+1}=N_ref{k,itNum};
            N_ref{PanelNum+2,itNum+1}=N_ref{k,itNum};
            N_ref{PanelNum+3,itNum+1}=N_ref{k,itNum};
            
            % Calculate new areas
            A_ref.(fname{itNum+1})(PanelNum,1)=norm(cross(V_ref{PanelNum,itNum+1}(2,:)-...
                V_ref{PanelNum,itNum+1}(1,:),V_ref{PanelNum,itNum+1}(3,:)-...
                V_ref{PanelNum,itNum+1}(1,:)))/2;
            
            A_ref.(fname{itNum+1})(PanelNum+1,1)=norm(cross(V_ref{PanelNum+1,itNum+1}(2,:)-...
                V_ref{PanelNum+1,itNum+1}(1,:),V_ref{PanelNum+1,itNum+1}(3,:)-...
                V_ref{PanelNum+1,itNum+1}(1,:)))/2;
            
            A_ref.(fname{itNum+1})(PanelNum+2,1)=norm(cross(V_ref{PanelNum+2,itNum+1}(2,:)-...
                V_ref{PanelNum+2,itNum+1}(1,:),V_ref{PanelNum+2,itNum+1}(3,:)-...
                V_ref{PanelNum+2,itNum+1}(1,:)))/2;
            
            A_ref.(fname{itNum+1})(PanelNum+3,1)=norm(cross(V_ref{PanelNum+3,itNum+1}(2,:)-...
                V_ref{PanelNum+3,itNum+1}(1,:),V_ref{PanelNum+3,itNum+1}(3,:)-...
                V_ref{PanelNum+3,itNum+1}(1,:)))/2;
            
            % update panel number
            PanelNum=PanelNum+4;
            
        end
    end
    %% update large panel index
    % pre-allocate
    largePanelFlag=zeros(FaceNum,1);
    
    % Find large panels
    idx=find(A_ref.(fname{itNum+1})>maxPanelArea);
    largePanelFlag(idx)=1;
    itNum=itNum+1;
end

%% Format output structure

% vertices
out.Vfinal=cell2mat(V_ref(:,itNum));
out.Vinit=cell2mat(V_ref(:,1));

% areas
out.Afinal=A_ref.(fname{itNum});
out.Ainit=A_ref.(fname{1});

% normals
out.Nfinal=cell2mat(N_ref(:,itNum));
out.Ninit=cell2mat(N_ref(:,1));

% Save name 
out.RefineName=saveName;

%% Format and save refined STL file

% locate to saveDir
if nargin<5;
    cd(saveDir)
end

% open file to write
fileID=fopen(saveName,'w')

% Header (ASCII encoded STL file
solidName=strrep(saveName,'.stl','');
fprintf(fileID,'solid %s \n',solidName);

% print body
for k=1:length(out.Nfinal)
    fprintf(fileID,'   facet normal %.6e %.6e %.6e \n',out.Nfinal(k,1),out.Nfinal(k,2),out.Nfinal(k,3));
    fprintf(fileID,'      outer loop \n');
    fprintf(fileID,'         vertex %.6e %.6e %.6e \n',out.Vfinal(3*(k-1)+1,1),...
        out.Vfinal(3*(k-1)+1,2),out.Vfinal(3*(k-1)+1,3));
    fprintf(fileID,'         vertex %.6e %.6e %.6e \n',out.Vfinal(3*(k-1)+2,1),...
        out.Vfinal(3*(k-1)+2,2),out.Vfinal(3*(k-1)+2,3));
    fprintf(fileID,'         vertex %.6e %.6e %.6e \n',out.Vfinal(3*(k-1)+3,1),...
        out.Vfinal(3*(k-1)+3,2),out.Vfinal(3*(k-1)+3,3));
    fprintf(fileID,'      endloop \n');
    fprintf(fileID,'   endfacet \n');
end
% print last line
fprintf(fileID,'endsolid');
fclose(fileID);

end













