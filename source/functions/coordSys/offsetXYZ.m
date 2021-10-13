function verts = offsetXYZ(verts,x)
% Function to move the position vertices 'verts' by 'x'
verts(:,1) = verts(:,1) + x(1);
verts(:,2) = verts(:,2) + x(2);
verts(:,3) = verts(:,3) + x(3);
end