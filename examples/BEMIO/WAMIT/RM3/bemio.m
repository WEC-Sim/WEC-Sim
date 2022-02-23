hydro = struct();

hydro = readWAMIT(hydro,'rm3.out',[]);
tic
hydro = radiationIRF(hydro,20,[],[],[],[]);
toc
%hydro = radiationIRFSS(hydro,[],[]);
hydro = excitationIRF(hydro,20,[],[],[],[]);
writeBEMIOH5(hydro)

%plotBEMIO(hydro)