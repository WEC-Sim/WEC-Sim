function   [string_norm,Nemoh_Failed] = readPressureFilesNEMOH(PressureFileRaw)
% function   [] = Read_Pressure()
% This function reads the pressure over the surface of the WEC
% Mohamed Shabara
% 06/06/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Read the Data
N = length(PressureFileRaw);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Read the pressure nodes
counter1 = 1;
counter2 = 1;
for n = 3:N
    % read the coordinates of the nodes
    tmp = textscan(PressureFileRaw{n},'%f');
    if length(tmp{1,1}) == 5
        Mesh_Coordinate(counter1,:) = transpose(tmp{1,1}(1:3));
        p_n_magTmp(counter1) = tmp{1,1}(4);
        p_n_angTmp(counter1) = tmp{1,1}(5);
        counter1 = counter1 + 1;
    else
        Mesh_index(counter2,:) = transpose(tmp{1,1}(1:4));
        counter2 = counter2 + 1;
    end
end

%% Panel calculation
Npanel = size(Mesh_index,1);
cc = 1;
Nemoh_Failed = 0;    
for i = 1:Npanel
    % read the panel corresponding nodes
    x_p = Mesh_Coordinate(Mesh_index(i,:),:);
    p_mag = p_n_magTmp(Mesh_index(i,:));
    p_ang = p_n_angTmp(Mesh_index(i,:));
    if ~isempty(find(p_mag ~= p_mag(1))) || ~isempty(find(p_ang ~= p_ang(1)))
        fprintf('*****\n')
        fprintf('WARNING: Nemoh Provided NaN Values For Pressures "Singularity Exists"\n')
        p_noEqual(cc,:) = [p_mag, p_ang];
        fprintf('*****\n')
        cc = cc +1;
        p_mag = zeros(1,length(p_mag));
        p_ang = zeros(1,length(p_ang));
        Nemoh_Failed = 1;
    end
    % compute w_1
    u1 = x_p(2,:) - x_p(1,:);
    v1 = x_p(3,:) - x_p(1,:);
    w1 = cross(u1,v1);
    % compute w_2
    u2 = x_p(3,:) - x_p(1,:);
    v2 = x_p(4,:) - x_p(1,:);
    w2 = cross(u2,v2);
    x_N = 0.5*(w1 + w2);
    % obtain the area of the panel
    S1 = 0.5*norm(w1);
    S2 = 0.5*norm(w2);
    SF = S1 + S2;
    Area = SF;
    % obtain the normalized normal vector
    x_nTemp = x_N/norm(x_N);
    % obtain the centroids of the panel
    x_c = (S1*1/3*(x_p(1,:) + x_p(2,:) + x_p(3,:)) + ...
        S2*1/3*(x_p(1,:) + x_p(3,:) + x_p(4,:)))/SF;
    % check the direction of the normal vector (pointing out)
    if (dot(x_nTemp,x_c)/(norm(x_nTemp)*norm(x_c))) > 0
        x_n = x_nTemp;
    elseif (dot(x_nTemp,x_c)/(norm(x_nTemp)*norm(x_c))) == 0
        warnning('Cannot decide the direction of the normal vector')
        break
    else
        x_n = -x_nTemp;
    end
    string_norm(i,:) = [x_c,x_n,Area,p_mag(1),p_ang(1)]; % Mesh centroid, mesh normal, elements area etc
end
end