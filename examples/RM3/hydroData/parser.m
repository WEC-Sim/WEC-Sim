function area = parser(hydros, dofs, directions, bodies)

arguments 
hydros
dofs = [2, 1, 3]
directions = 0;
bodies = 1;
end



for i = length(hydros)
    disp(hydros{i})
end

disp(dofs)
disp(directions)
disp(bodies)