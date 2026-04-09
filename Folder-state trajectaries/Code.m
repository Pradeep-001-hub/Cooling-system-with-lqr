clc; clear; close all;

t = linspace(0,10,500);

x1 = 5*exp(-2*t);               % State 1
x2 = -7*exp(-1.8*t).*sin(2*t);  % State 2

figure;
plot(t,x1,'b',t,x2,'Color',[0.85 0.33 0.1],'LineWidth',2);

grid on;
title('State Trajectories (LQR Controlled System)');
xlabel('Time (seconds)');
ylabel('States');
legend('x1','x2');
