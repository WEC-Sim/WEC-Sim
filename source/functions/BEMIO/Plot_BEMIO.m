function Plot_BEMIO(hydro)

% Plots the added mass, radiation damping, radiation IRF, excitation force magnitude, excitation force phase, and excitation IRF for each body in the heave, surge and pitch degrees of freedom.
% 
% Plot_BEMIO(hydro)
%     hydro – data structure
% 
% See ‘…\WEC-Sim\tutorials\BEMIO\...’ for examples of usage.

p = waitbar(0,'Plotting BEMIO results…');  % Progress bar

%% Added Mass
clear X Y Legends
Fig1 = figure('Position',[50,500,975,521]);
Title = ['Normalized Added Mass: $$\bar{A}_{i,j}(\omega) = {\frac{A_{i,j}(\omega)}{\rho}}$$'];
Subtitles = {'Surge','Heave','Pitch'};
XLables = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
YLables = {'$$\bar{A}_{1,1}(\omega)$$','$$\bar{A}_{3,3}(\omega)$$','$$\bar{A}_{5,5}(\omega)$$'};
X = hydro.w;
a = 0;
for i = 1:hydro.Nb    
    m = hydro.dof(i);
    Y(1,i,:) = squeeze(hydro.A(a+1,a+1,:));
    Legends{1,i} = [hydro.body{i}];
    Y(2,i,:) = squeeze(hydro.A(a+3,a+3,:));
    Legends{2,i} = [hydro.body{i}];
    Y(3,i,:) = squeeze(hydro.A(a+5,a+5,:));
    Legends{3,i} = [hydro.body{i}];
    a = a + m;
end
Notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{A}_{i,j}(\omega)$$ should tend towards a constant, ',...
    '$$A_{\infty}$$, within the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{A}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system, ',...
    'that $$\bar{A}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};
FormatPlot(Fig1,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
waitbar(1/6);

%% Radiation Damping
clear X Y Legends
Fig2 = figure('Position',[50,300,975,521]);
Title = ['Normalized Radiation Damping: $$\bar{B}_{i,j}(\omega) = {\frac{B_{i,j}(\omega)}{\rho\omega}}$$'];
Subtitles = {'Surge','Heave','Pitch'};
XLables = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
YLables = {'$$\bar{B}_{1,1}(\omega)$$','$$\bar{B}_{3,3}(\omega)$$','$$\bar{B}_{5,5}(\omega)$$'};
X = hydro.w;
a = 0;
for i = 1:hydro.Nb
    m = hydro.dof(i);
    Y(1,i,:) = squeeze(hydro.B(a+1,a+1,:));
    Legends{1,i} = [hydro.body{i}];
    Y(2,i,:) = squeeze(hydro.B(a+3,a+3,:));
    Legends{2,i} = [hydro.body{i}];
    Y(3,i,:) = squeeze(hydro.B(a+5,a+5,:));
    Legends{3,i} = [hydro.body{i}];
    a = a + m;
end
Notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{B}_{i,j}(\omega)$$ should tend towards zero within ',...
    'the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{B}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system ',...
    'that $$\bar{B}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};
FormatPlot(Fig2,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
waitbar(2/6);

%% Radiation IRFs
clear X Y Legends
Fig3 = figure('Position',[50,100,975,521]);
Title = ['Normalized Radiation Impulse Response Functions: ',...
    '$$\bar{K}_{i,j}(t) = {\frac{2}{\pi}}\int_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega$$'];
Subtitles = {'Surge','Heave','Pitch'};
XLables = {'$$t (s)$$','$$t (s)$$','$$t (s)$$'};
YLables = {'$$\bar{K}_{1,1}(t)$$','$$\bar{K}_{3,3}(t)$$','$$\bar{K}_{3,3}(t)$$'};
X = hydro.ra_t;
n = 1;
a = 0;
for i = 1:hydro.Nb
    m = hydro.dof(i);
    Y(1,n,:) = squeeze(hydro.ra_K(a+1,a+1,:));
    Legends{1,n} = [hydro.body{i}];
    Y(2,n,:) = squeeze(hydro.ra_K(a+3,a+3,:));
    Legends{2,n} = [hydro.body{i}];
    Y(3,n,:) = squeeze(hydro.ra_K(a+5,a+5,:));
    Legends{3,n} = [hydro.body{i}];
    if isfield(hydro,'ss_A')==1
        n = n+1;
        Y(1,n,:) = squeeze(hydro.ss_K(a+1,a+1,:));
        Legends{1,n} = [hydro.body{i},' (SS)'];
        Y(2,n,:) = squeeze(hydro.ss_K(a+3,a+3,:));
        Legends{2,n} = [hydro.body{i},' (SS)'];
        Y(3,n,:) = squeeze(hydro.ss_K(a+5,a+5,:));
        Legends{3,n} = [hydro.body{i},' (SS)'];
    end
    n = n+1;
    a = a + m;
end
Notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the surge, heave, and pitch DOFs are plotted ',...
    'here. If another DOF is significant to the system, that IRF should also ',...
    'be plotted and verified before proceeding.']};
FormatPlot(Fig3,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
waitbar(3/6);

%% Excitation Force Magnitude
B=1;  % Wave heading index
clear X Y Legends
Fig4 = figure('Position',[950,500,975,521]);
Title = ['Normalized Excitation Force Magnitude: ',...
    '$$\bar{X_i}(\omega,\beta) = {\frac{X_i(\omega,\beta)}{{\rho}g}}$$'];
Subtitles = {'Surge','Heave','Pitch'};
XLables = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
YLables = {['$$\bar{X_1}(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_3}(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_5}(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)']};
X = hydro.w;
a = 0;
for i = 1:hydro.Nb
    m = hydro.dof(i);
    Y(1,i,:) = squeeze(hydro.ex_ma(a+1,B,:));
    Legends{1,i} = [hydro.body{i}];
    Y(2,i,:) = squeeze(hydro.ex_ma(a+3,B,:));
    Legends{2,i} = [hydro.body{i}];
    Y(3,i,:) = squeeze(hydro.ex_ma(a+5,B,:));
    Legends{3,i} = [hydro.body{i}];
    a = a + m;
end
Notes = {''};
FormatPlot(Fig4,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
waitbar(4/6);

%% Excitation Force Phase
B=1;  % Wave heading index
clear X Y Legends
Fig5 = figure('Position',[950,300,975,521]);
Title = ['Excitation Force Phase: $$\phi_i(\omega,\beta)$$'];
Subtitles = {'Surge','Heave','Pitch'};
XLables = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
YLables = {['$$\phi_1(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ})$$'],...
    ['$$\phi_3(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
    ['$$\phi_5(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)']};
X = hydro.w;
a = 0;
for i = 1:hydro.Nb
    m = hydro.dof(i);
    Y(1,i,:) = squeeze(hydro.ex_ph(a+1,B,:));
    Legends{1,i} = [hydro.body{i}];
    Y(2,i,:) = squeeze(hydro.ex_ph(a+3,B,:));
    Legends{2,i} = [hydro.body{i}];
    Y(3,i,:) = squeeze(hydro.ex_ph(a+5,B,:));
    Legends{3,i} = [hydro.body{i}];
    a = a + m;
end
Notes = {''};
FormatPlot(Fig5,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
waitbar(5/6);

%% Excitation IRFs
B=1;  % Wave heading index
clear X Y Legends
Fig6 = figure('Position',[950,100,975,521]);
Title = ['Normalized Excitation Impulse Response Functions:   ',...
    '$$\bar{K}_i(t) = {\frac{1}{2\pi}}\int_{-\infty}^{\infty}{\frac{X_i(\omega,\beta)e^{i{\omega}t}}{{\rho}g}}d\omega$$'];
Subtitles = {'Surge','Heave','Pitch'};
XLables = {'$$t (s)$$','$$t (s)$$','$$t (s)$$'};
YLables = {['$$\bar{K}_1(t,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{K}_3(t,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{K}_5(t,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)']};
X = hydro.ex_t;
a = 0;
for i = 1:hydro.Nb
    m = hydro.dof(i);
    Y(1,i,:) = squeeze(hydro.ex_K(a+1,B,:));
    Legends{1,i} = [hydro.body{i}];
    Y(2,i,:) = squeeze(hydro.ex_K(a+3,B,:));
    Legends{2,i} = [hydro.body{i}];
    Y(3,i,:) = squeeze(hydro.ex_K(a+5,B,:));
    Legends{3,i} = [hydro.body{i}];
    a = a + m;
end
Notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the first wave heading, surge, heave, and ',...
    'pitch DOFs are plotted here. If another wave heading or DOF is significant ',...
    'to the system, that IRF should also be plotted and verified before proceeding.']};
FormatPlot(Fig6,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
waitbar(6/6);

close(p);
% saveas(Fig1,'Added_Mass.png');
% saveas(Fig2,'Radiation_Damping.png');
% saveas(Fig3,'Radiation_IRFs.png');
% saveas(Fig4,'Excitation_Magnitude.png');
% saveas(Fig5,'Excitation_Phase.png');
% saveas(Fig6,'Excitation_IRFs.png');
end


%% Format
function FormatPlot(fig,heading,subtitle,x_lables,y_lables,X_data,Y_data,legends,notes)

axes1 = axes('Parent',fig,'Position',[0.0731 0.3645 0.2521 0.4720]);
hold(axes1,'on');
box(axes1,'on');
title(subtitle(1));
xlabel(x_lables(1),'Interpreter','latex');
ylabel(y_lables(1),'Interpreter','latex');

axes2 = axes('Parent',fig,'Position',[0.3983 0.3645 0.2521 0.4720]);
hold(axes2,'on');
box(axes2,'on');
title(subtitle(2));
xlabel(x_lables(2),'Interpreter','latex');
ylabel(y_lables(2),'Interpreter','latex');

axes3 = axes('Parent',fig,'Position',[0.7235 0.3645 0.2521 0.4720]);
hold(axes3,'on');
box(axes3,'on');
title(subtitle(3));
xlabel(x_lables(3),'Interpreter','latex');
ylabel(y_lables(3),'Interpreter','latex');

annotation(fig,'textbox',[0.0 0.9 1.0 0.1],...
    'String',heading,...
    'Interpreter','latex',...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'FontWeight','bold',...
    'FontSize',12,...
    'EdgeColor','none');
annotation(fig,'textbox',[0.0 0.0 1.0 0.2628],...
    'String',notes,...
    'Interpreter','latex',...
    'FitBoxToText','off',...
    'EdgeColor','none');

[p,b,s]=size(Y_data);
for i = 1:b
    plot(X_data,squeeze(Y_data(1,i,:)),'LineWidth',1,'Parent',axes1);
    plot(X_data,squeeze(Y_data(2,i,:)),'LineWidth',1,'Parent',axes2);
    plot(X_data,squeeze(Y_data(3,i,:)),'LineWidth',1,'Parent',axes3);
end
legend(axes1,legends(1,:),'location','best','Box','off','Interpreter','none')
legend(axes2,legends(2,:),'location','best','Box','off','Interpreter','none')
legend(axes3,legends(3,:),'location','best','Box','off','Interpreter','none')

end