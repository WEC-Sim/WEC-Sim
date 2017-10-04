
% A mesh converter function. Note that any output dat file will have
% vertices re-ordered such that node order is consecutive (as implied in
% GDF format). Also, note that using an un-refined STL mesh is not
% recommended for BEM codes: this code builds a degenerate quadrangle from
% the triangular STL mesh (ABC->ABCA).

% INPUTS:
% meshfile: the file name of the mesh to convert (string).
% fmt: format of the input mesh (string: gdf, stl, or dat).
% outfmt: desired output format of the mesh (string: gdf or dat).
% outName: the desired name of the output mesh (no dot, e.g., 'gdf')
% stleol: 1 or 2, selects end of line character.1= '/n' (Linux/Mac),
%   2='/r/n' (Windows). Defaults to 2. 
% nemohFlag: 0 for no axial symmetry, 1 for axial symmetry 
%   (see
%   https://lheea.ec-nantes.fr/logiciels-et-brevets/nemoh-mesh-192932.kjsp)
% ISXflag: X-symmetry flag for gdf output, 1 or 0. Default = 0
% ISYflag: Y-symmetry flag for gdf output, 1 or 0. Default = 0

% OUTPUTS:
% outmesh: The filename of the output mesh (.dat or .gdf). The file itself
%   will be written to the current directory;

function outmesh=meshConvert(meshfile,fmt,outfmt,outName,stleol,nemohFlag,ISXflag,ISYflag)
% error if stl read function inputs are not defined
if nargin<5 && strcmp(fmt,'stl')
    warning('Did not define stl output mode and end of line characters. Using defaults')
    stleol=2;
end
if nargin<6 && strcmp(outfmt,'dat')
    warning('Did not specify nemohFlag; assuming no axial symmetry')
    nemohFlag=0;
end
if nargin<7 && strcmp(outfmt,'gdf')
    warning('Did not specify ISX and ISYflags: assuming no symmetry in GDF output')
    ISXflag=0;
    ISYflag=0;
end

%% Input processing
switch fmt
    case 'stl'                                                              %STL MESH
        [V,normals]=import_stl_fast(meshfile,2,stleol);                     % outputs vertices and normals of ASCII stl mesh, triangular panels
        FaceNum=length(normals);
       
        % build degenerate mesh (tri-->quad ; ABC --> ABCA)
        [row,col]=size(V);
        Vquad=ones(row+FaceNum,col);
        FaceNum=num2str(FaceNum);     
        it=0;
        for k=1:length(Vquad)
            if rem(k,4)==0 && it>0
                Vquad(k,:)=V(it-2,:);
            else
                it=it+1;
                Vquad(k,:)=V(it,:);
            end
        end  
        V=Vquad;
    case 'gdf'                                                              % WAMIT MESH
        
        fileID=fopen(meshfile);
        raw=textscan(fileID,'%[^\n\r]');                                    % Read/copy raw gdf text file
        raw=raw{:};
        %% vertex definitions
        lnNum=length(raw);
        % find start        
        for k=1:lnNum;
            query=strfind(raw(k),'GRAV');
            if ~isempty(query{1})
                break;
            end
        end
        
        % define vertices
        startln=k+3;
        for k=startln:lnNum
            V(k-(startln-1),:)=str2num(raw{k});                             % quad panels
        end
        
        %% build implied node order
        F(:,1)=1:length(V);
        FaceNum=length(V)/4;
        F=reshape(F,[4,FaceNum])';
        FaceNum=num2str(FaceNum);
    
    case 'dat'                                                              % NEMOH MESH
                
        fileID=fopen(meshfile);
        raw=textscan(fileID,'%[^\n\r]');                                    % Read/copy raw gdf text file
        raw=raw{:};
        lnNum=length(raw);
        
        %% vertex definitions
        for k=2:lnNum;
            if strcmp(raw(k),'0 0 0 0')                                     % signals start of faces
                break;
            end
            V(k-1,:)=str2num(raw{k});                                     
        end
        
        %% node connection instructions
        k=k+1
        for m=k:lnNum-1                                                     % last line is garbage
            F(m-(k-1),:)=str2num(raw{m});
        end
        nodeOrder=reshape(F',[1,length(V)])';
        
        % re-order vertices based upon node order
        V(:,[2:end])=V(nodeOrder,[2:end]);
        
        FaceNum=length(nodeOrder);
        FaceNum=num2str(FaceNum);
        
    case 'vtp'
        error('Unsupported conversion type. Please use python distribution of Bemio to read vtp meshes')
        
end

%% Trim meshfile name
meshfile=outName;

%% Output processing
% Uses the F, V files to generate output mesh of desired format
switch outfmt
    case 'vtp'
        error('Unsupported conversion type. Please use python distribution of Bemio to write vtp meshes')
    case 'gdf'
        header12 ={'Mesh file written by meshConvert.m'; '1 9.80665       ULEN GRAV'};
        header3 = {num2str(ISXflag),'  ',num2str(ISYflag),'    ','ISX','  ','ISY'};
        header3=sprintf('%s',header3{1:end});
        header4= FaceNum;
        header=[header12; header3; header4];
        % write header
        outmesh=strcat(meshfile,'.gdf');
        FileID=fopen(outmesh,'w');
        for k=1:length(header)
            fprintf(FileID,'%s\n',header{k});
        end
        % write vertices
        [row,cols]=size(V);
        % restrict precision to ensure proper representation
        V=round(V,5);
        if cols==4;                                                         % if source file presents vertices as 4 columns
            for k=1:row;
                Vout(k,1)=mat2cell(V(k,2),1);
                Vout(k,2)=mat2cell(V(k,3),1);
                Vout(k,3)=mat2cell(V(k,4),1);
                if V(k,2)<0;
                    formatSpec1='%-8g';
                elseif V(k,2)>0;
                    formatSpec1='% -8g';
                elseif V(k,2)==0;
                    formatSpec1='% #-8.0f';
                end
                if V(k,3)<0;
                    formatSpec2='%-8g';
                elseif V(k,3)>0;
                    formatSpec2='% -8g';
                elseif V(k,3)==0;
                    formatSpec2='% #-8.0f';
                end
                if V(k,4)<0;
                    formatSpec3='%-8g\n';
                elseif V(k,4)>0;
                    formatSpec3='% -8g\n';
                elseif V(k,4)==0;
                    formatSpec3='% #-8.0f\n';
                end
                formatSpec=sprintf('%s %s %s',formatSpec1,formatSpec2,formatSpec3);
                fprintf(FileID,formatSpec,Vout{k,:});
                
            end
        elseif cols==3;                                                     % if source file presents vertices as 3 columns
            for k=1:row;
                Vout(k,1)=mat2cell(V(k,1),1);
                Vout(k,2)=mat2cell(V(k,2),1);
                Vout(k,3)=mat2cell(V(k,3),1);
                if V(k,1)<0;
                    formatSpec1='%-8g';
                elseif V(k,1)>0;
                    formatSpec1='% -8g';
                elseif V(k,1)==0;
                    formatSpec1='% #-8.0f';
                end
                if V(k,2)<0;
                    formatSpec2='%-8g';
                elseif V(k,2)>0;
                    formatSpec2='% -8g';
                elseif V(k,2)==0;
                    formatSpec2='% #-8.0f';
                end
                if V(k,3)<0;
                    formatSpec3='%-8g\n';
                elseif V(k,3)>0;
                    formatSpec3='% -8g\n';
                elseif V(k,3)==0;
                    formatSpec3='% #-8.0f\n';
                end
                formatSpec=sprintf('%s %s %s',formatSpec1,formatSpec2,formatSpec3);
                fprintf(FileID,formatSpec,Vout{k,:});
            end
        end
        
        
    case 'dat' % 4th column indicates vertex group number, includes face number
        header=strcat('2',{' '},num2str(nemohFlag));
        % write header
        outmesh=strcat(meshfile,'.dat');
        FileID=fopen(outmesh,'w');
        for k=1:length(header)
            fprintf(FileID,'%s\n',header{k});
        end
        % write vertices and faces
        [rows, cols]=size(V);
        FaceLen=rows/4;
        V=round(V,5);                                                      % round to appropriate precision
        if cols==4;
            for k=1:rows
                Vout(k,1)=mat2cell(V(k,1),1);
                Vout(k,2)=mat2cell(V(k,2),1);
                Vout(k,3)=mat2cell(V(k,3),1);
                Vout(k,4)=mat2cell(V(k,4),1);
                formatSpec1='%-.0f';
                if V(k,2)<0;
                    formatSpec2='%-8g';
                elseif V(k,2)>0;
                    formatSpec2='% -8g';
                elseif V(k,2)==0;
                    formatSpec2='% #-8.0f';
                end
                if V(k,3)<0;
                    formatSpec3='%-8g';
                elseif V(k,3)>0;
                    formatSpec3='% -8g';
                elseif V(k,3)==0;
                    formatSpec3='% #-8.0f';
                end
                if V(k,4)<0;
                    formatSpec4='%-8g\n';
                elseif V(k,4)>0;
                    formatSpec4='% -8g\n';
                elseif V(k,4)==0;
                    formatSpec4='% #-8.0f\n';
                end
                formatSpec=sprintf('%s %s %s %s',formatSpec1,formatSpec2,formatSpec3,formatSpec4);
                fprintf(FileID,formatSpec,Vout{k,:});
            end
            % print 0 0 0 0 line
            fprintf(FileID,'%-s\n','0 0 0 0');
            for k=1:FaceLen
                Fout(k,1)=mat2cell(F(k,1),1);
                Fout(k,2)=mat2cell(F(k,2),1);
                Fout(k,3)=mat2cell(F(k,3),1);
                Fout(k,4)=mat2cell(F(k,4),1);
                Lvec=[length(num2str(Fout{k,1})),length(num2str(Fout{k,2}))...
                    ,length(num2str(Fout{k,3})),length(num2str(Fout{k,4}))];
                [maxL,idx]=max(Lvec);
                if max(diff(Lvec))>0;
                    switch idx
                        case 1
                            formatSpec1='%-.0f';
                            formatSpec2='%-.0f';
                            formatSpec3='%-.0f';
                            formatSpec4='%-.0f\n';
                        case 2
                            formatSpec1='% -.0f';
                            formatSpec2='%-.0f';
                            formatSpec3='%-.0f';
                            formatSpec4='%-.0f\n';
                        case 3
                            formatSpec1='% -.0f';
                            formatSpec2='% -.0f';
                            formatSpec3='%-.0f';
                            formatSpec4='%-.0f\n';
                        case 4
                            formatSpec1='% -.0f';
                            formatSpec2='% -.0f';
                            formatSpec3='% -.0f';
                            formatSpec4='%-.0f\n';
                    end
                else
                    formatSpec1='%-.0f';
                    formatSpec2='%-.0f';
                    formatSpec3='%-.0f';
                    formatSpec4='%-.0f\n';
                end
                formatSpec=sprintf('%s %s %s %s',formatSpec1,formatSpec2,formatSpec3,formatSpec4);
                fprintf(FileID,formatSpec,Fout{k,:});
            end
            % print 0 0 0 0 line
            fprintf(FileID,'%-s\n','0 0 0 0');
            
        elseif cols==3
            V(:,4)=1:rows;
            for k=1:rows
                Vout(k,1)=mat2cell(V(k,4),1);
                Vout(k,2)=mat2cell(V(k,1),1);
                Vout(k,3)=mat2cell(V(k,2),1);
                Vout(k,4)=mat2cell(V(k,3),1);
                formatSpec1='%-.0f';
                if V(k,1)<0;
                    formatSpec2='%-8g';
                elseif V(k,1)>0;
                    formatSpec2='% -8g';
                elseif V(k,1)==0;
                    formatSpec2='% #-8.0f';
                end
                if V(k,2)<0;
                    formatSpec3='%-8g';
                elseif V(k,2)>0;
                    formatSpec3='% -8g';
                elseif V(k,2)==0;
                    formatSpec3='% #-8.0f';
                end
                if V(k,3)<0;
                    formatSpec4='%-8g\n';
                elseif V(k,3)>0;
                    formatSpec4='% -8g\n';
                elseif V(k,3)==0;
                    formatSpec4='% #-8.0f\n';
                end
                formatSpec=sprintf('%s %s %s %s',formatSpec1,formatSpec2,formatSpec3,formatSpec4);
                fprintf(FileID,formatSpec,Vout{k,:});
            end
            % print 0 0 0 0 line
            fprintf(FileID,'%-s\n','0 0 0 0');
            F=reshape(1:rows,4,rows/4)';
            for k=1:FaceLen
                Fout(k,1)=mat2cell(F(k,1),1);
                Fout(k,2)=mat2cell(F(k,2),1);
                Fout(k,3)=mat2cell(F(k,3),1);
                Fout(k,4)=mat2cell(F(k,4),1);
                Lvec=[length(num2str(Fout{k,1})),length(num2str(Fout{k,2}))...
                    ,length(num2str(Fout{k,3})),length(num2str(Fout{k,4}))];
                [maxL,idx]=max(Lvec);
                if max(diff(Lvec))>0;
                    switch idx
                        case 1
                            formatSpec1='%-.0f';
                            formatSpec2='%-.0f';
                            formatSpec3='%-.0f';
                            formatSpec4='%-.0f\n';
                        case 2
                            formatSpec1='% -.0f';
                            formatSpec2='%-.0f';
                            formatSpec3='%-.0f';
                            formatSpec4='%-.0f\n';
                        case 3
                            formatSpec1='% -.0f';
                            formatSpec2='% -.0f';
                            formatSpec3='%-.0f';
                            formatSpec4='%-.0f\n';
                        case 4
                            formatSpec1='% -.0f';
                            formatSpec2='% -.0f';
                            formatSpec3='% -.0f';
                            formatSpec4='%-.0f\n';
                    end
                else
                    formatSpec1='%-.0f';
                    formatSpec2='%-.0f';
                    formatSpec3='%-.0f';
                    formatSpec4='%-.0f\n';
                end
                formatSpec=sprintf('%s %s %s %s',formatSpec1,formatSpec2,formatSpec3,formatSpec4);
                fprintf(FileID,formatSpec,Fout{k,:});
            end
            % print 0 0 0 0 line
            fprintf(FileID,'%-s\n','0 0 0 0');
        end
end
fclose(FileID);
end

