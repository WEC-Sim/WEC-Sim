TimeV = PTOSimBlock5_out.time;
shaftSpeed = PTOSimBlock5_out.signals.values(:,1);
TorqueHM = PTOSimBlock5_out.signals.values(:,2);
Current = PTOSimBlock6_out.i.Data;
Voltage = PTOSimBlock6_out.Voltage.Data;

EGPower = zeros(length(TimeV),1);
HMPower = zeros(length(TimeV),1);

for i = 1:1:length(TimeV)
    EGPower(i) = abs(Current(i)*Voltage(i));
    HMPower(i) = abs(shaftSpeed(i)*TorqueHM(i));
end

figure(1)
plot(TimeV,EGPower,TimeV,HMPower)
legend('Generator','Hydraulic Motor')

figure(2)
subplot(2,1,1)
plot(TimeV,Current)
legend('Current')

subplot(2,1,2)
plot(TimeV,Voltage)
legend('Voltage')