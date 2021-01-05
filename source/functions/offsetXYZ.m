function verts_out = offsetXYZ(verts,x)
% Function to move the position vertices 'verts' by 'x'
verts_out(:,1) = verts(:,1) + x(1);
verts_out(:,2) = verts(:,2) + x(2);
verts_out(:,3) = verts(:,3) + x(3);
end