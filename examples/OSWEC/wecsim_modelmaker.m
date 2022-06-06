%% Initial Setup
clc;
close all;
try
open_system(new_system('Model')')
catch
open_system('Model')
end





add_block('WECSim_Lib_Frames/Global Reference Frame','Model/globalframe');
set_param('Model/globalframe','Position',[500 200 650 250])

%% Model Configuration.


ptoType        = [2;-2;2];
constraintType = [0;0;0];

% Here the Postive signs to the ptoType and constraintType variables denote
% parallel connections, such that the corresponding body is attached to the
% global frame.
% The Negative sign denotes that the body is connected to the body with
% index one less than the current body.
% ptoType variable defines the type of ptos such that,
% 1. Spherical PTO,
% 2. Translational PTO,
% 3. Translational PTO Actuation Force,
% 4. Translational PTO Actuation Motion,
% 5. Rotational PTO,
% 6. Rotational PTO Actuation Torque,
% 7. Rotational PTO Actuation Motion
% constraintType varibables are defined as,
% 1. Fixed,
% 2. Spherical,
% 3. Translational,
% 4. Rotational,
% 5. Floating 3DOF,
% 6. FLoating 6DOF.
% 
% Note: The tranlational PTO ports are defined differently than all other
% ptos and constraints. This code accounts for that at the end of PTO
% for-loops.





for i = 1:length(body)

    %% Add Bodies
add_block('WECSim_Lib_Body_Elements/Rigid Body',sprintf('Model/body(%d)',i));
set_param(sprintf('Model/body(%d)',i),'Position',[500+75*i 200+75*i 650+75*i 250+75*i]);
set_param(sprintf('Model/body(%d)',i),'body',sprintf('body(%d)',i));
%% Add PTOs

if isempty(ptoType) == 0

if abs(ptoType(i)) == 1
add_block('WECSim_Lib_PTOs/Spherical PTO',sprintf('Model/pto(%d)',i));
set_param(sprintf('Model/pto(%d)',i),'Position',[710+50*i 210+75*i 800+50*i 220+75*i]);
set_param(sprintf('Model/pto(%d)',i),'pto',sprintf('pto(%d)',i));

end
if abs(ptoType(i)) == 2
add_block('WECSim_Lib_PTOs/Translational PTO',sprintf('Model/pto(%d)',i));
set_param(sprintf('Model/pto(%d)',i),'Position',[710+50*i 210+75*i 800+50*i 220+75*i]);
set_param(sprintf('Model/pto(%d)',i),'pto',sprintf('pto(%d)',i));
end
if abs(ptoType(i)) == 3
add_block('WECSim_Lib_PTOs/Translational PTO Actuation Force',sprintf('Model/pto(%d)',i));
set_param(sprintf('Model/pto(%d)',i),'Position',[710+50*i 210+75*i 800+50*i 220+75*i]);
set_param(sprintf('Model/pto(%d)',i),'pto',sprintf('pto(%d)',i));
end
if abs(ptoType(i)) == 4
add_block('WECSim_Lib_PTOs/Translational PTO Actuation Motion',sprintf('Model/pto(%d)',i));
set_param(sprintf('Model/pto(%d)',i),'Position',[710+50*i 210+75*i 800+50*i 220+75*i]);
set_param(sprintf('Model/pto(%d)',i),'pto',sprintf('pto(%d)',i));
end
if abs(ptoType(i)) == 5
add_block('WECSim_Lib_PTOs/Rotational PTO',sprintf('Model/pto(%d)',i));
set_param(sprintf('Model/pto(%d)',i),'Position',[710+50*i 210+75*i 800+50*i 220+75*i]);
set_param(sprintf('Model/pto(%d)',i),'pto',sprintf('pto(%d)',i));
end
if abs(ptoType(i)) == 6
add_block('WECSim_Lib_PTOs/Rotational PTO Actuation Torque',sprintf('Model/pto(%d)',i));
set_param(sprintf('Model/pto(%d)',i),'Position',[710+50*i 210+75*i 800+50*i 220+75*i]);
set_param(sprintf('Model/pto(%d)',i),'pto',sprintf('pto(%d)',i));
end
if abs(ptoType(i)) == 7
add_block('WECSim_Lib_PTOs/Rotational PTO Actuation Motion',sprintf('Model/pto(%d)',i));
set_param(sprintf('Model/pto(%d)',i),'Position',[710+50*i 210+75*i 800+50*i 220+75*i]);
set_param(sprintf('Model/pto(%d)',i),'pto',sprintf('pto(%d)',i));
end

%% Add Connections

if ptoType(i) > 0
if abs(ptoType(i)) ~=2
add_line('Model','globalframe/RConn1',sprintf('pto(%d)/LConn1',i),'autorouting','on');
add_line('Model',sprintf('pto(%d)/RConn1',i),sprintf('body(%d)/RConn1',i),'autorouting','on');
elseif ptoType(i) == 2
add_line('Model','globalframe/RConn1',sprintf('pto(%d)/RConn1',i),'autorouting','on');
add_line('Model',sprintf('pto(%d)/LConn1',i),sprintf('body(%d)/RConn1',i),'autorouting','on');
end
elseif ptoType(i) < 0
if ptoType(i) ~=-2
add_line('Model',sprintf('body(%d)/RConn1',i-1),sprintf('pto(%d)/RConn1',i),'autorouting','on');
add_line('Model',sprintf('pto(%d)/LConn1',i),sprintf('body(%d)/RConn1',i),'autorouting','on');
elseif abs(ptoType(i)) == 2
add_line('Model',sprintf('body(%d)/RConn1',i-1),sprintf('pto(%d)/RConn1',i),'autorouting','on');
add_line('Model',sprintf('pto(%d)/LConn1',i),sprintf('body(%d)/RConn1',i),'autorouting','on');        
end
end
%% Add Constraints

if isempty(constraintType) == 0

if abs(constraintType(i)) == 1
add_block('WECSim_Lib_Constraints/Fixed',sprintf('Model/constraint(%d)',i));
set_param(sprintf('Model/constraint(%d)',i),'Position',[910+50*i 210+75*i 1000+50*i 220+75*i]);
set_param(sprintf('Model/constraint(%d)',i),'constraint',sprintf('constraint(%d)',i));
end
if abs(constraintType(i)) == 2
add_block('WECSim_Lib_Constraints/Spherical',sprintf('Model/constraint(%d)',i));
set_param(sprintf('Model/constraint(%d)',i),'Position',[910+50*i 210+75*i 1000+50*i 220+75*i]);
set_param(sprintf('Model/constraint(%d)',i),'constraint',sprintf('constraint(%d)',i));
end
if abs(constraintType(i)) == 3
add_block('WECSim_Lib_Constraints/Translational',sprintf('Model/constraint(%d)',i));
set_param(sprintf('Model/constraint(%d)',i),'Position',[910+50*i 210+75*i 1000+50*i 220+75*i]);
set_param(sprintf('Model/constraint(%d)',i),'constraint',sprintf('constraint(%d)',i));
end
if abs(constraintType(i)) == 4
add_block('WECSim_Lib_Constraints/Rotational',sprintf('Model/constraint(%d)',i));
set_param(sprintf('Model/constraint(%d)',i),'Position',[910+50*i 210+75*i 1000+50*i 220+75*i]);
set_param(sprintf('Model/constraint(%d)',i),'constraint',sprintf('constraint(%d)',i));
end
if abs(constraintType(i)) == 5
add_block('WECSim_Lib_Constraints/Floating (3DOF)',sprintf('Model/constraint(%d)',i));
set_param(sprintf('Model/constraint(%d)',i),'Position',[910+50*i 210+75*i 1000+50*i 220+75*i]);
set_param(sprintf('Model/constraint(%d)',i),'constraint',sprintf('constraint(%d)',i));
end
if abs(constraintType(i)) == 6
add_block('WECSim_Lib_Constraints/Floating (6DOF)',sprintf('Model/constraint(%d)',i));
set_param(sprintf('Model/constraint(%d)',i),'Position',[910+50*i 210+75*i 1000+50*i 220+75*i]);
set_param(sprintf('Model/constraint(%d)',i),'constraint',sprintf('constraint(%d)',i));
end

%% Add Connections

% add_line('Model','globalframe/RConn1',sprintf('constraint(%d)/LConn1',i),'autorouting','on');
% add_line('Model',sprintf('constraint(%d)/RConn1',i),sprintf('body(%d)/RConn1',i),'autorouting','on');

if constraintType(i) > 0
add_line('Model','globalframe/RConn1',sprintf('constraint(%d)/LConn1',i),'autorouting','on');
add_line('Model',sprintf('constraint(%d)/RConn1',i),sprintf('body(%d)/RConn1',i),'autorouting','on');
elseif constraintType(i) < 0
add_line('Model',sprintf('body(%d)/RConn1',i-1),sprintf('constraint(%d)/LConn1',i),'autorouting','on');
add_line('Model',sprintf('constraint(%d)/RConn1',i),sprintf('body(%d)/RConn1',i),'autorouting','on');
end

end

end
end


