function[] = plotting_function(y_data,y_name,x_data,x_name,Title,FS,LW,style)
% figure()
plot(x_data,y_data,style,'Linewidth',LW)
ylabel(y_name, 'FontSize', FS)
xlabel(x_name, 'FontSize', FS)
title(Title, 'FontSize', FS)
ax = gca;
ax.FontSize       =  FS;
grid on
