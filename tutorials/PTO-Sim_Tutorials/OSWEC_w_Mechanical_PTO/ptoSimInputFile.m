%%  Linear Generator PTO-Sim  
 
ptosim = ptoSimClass('Direct Drive Linear Generator');

%% Linear Generator

ptosim.linearGenerator.Rs = 4.58;                   % Winding resistance [ohm]
ptosim.linearGenerator.Bfric = -100;                % Friction coefficient
ptosim.linearGenerator.tau_p = 0.072;               % Magnet pole pitch [m]
ptosim.linearGenerator.lambda_fd = 8;               % Flux linkage of the stator d winding due to flux produced by the rotor magnets [Wb-turns]
                                                    % (recognizing that the d-axis is always aligned with the rotor magnetic axis)                                                                                                                    
ptosim.linearGenerator.Ls = 0.285;                  % Inductance of the coil [H]
ptosim.linearGenerator.theta_d_0 = 0;
ptosim.linearGenerator.lambda_sq_0 = 0;
ptosim.linearGenerator.lambda_sd_0 = ptosim.linearGenerator.lambda_fd;
ptosim.linearGenerator.Rload = -117.6471;           % Load Resistance [ohm]

%% Rotary to Linear Adjustable Rod

ptosim.motionMechanism.crank = 3;
ptosim.motionMechanism.offset = 1.3;
ptosim.motionMechanism.rodInit = 5;

