clc; clear; close all;

t = linspace(0,10,500);

% Simulated tracking errors
e1 = 3*exp(-0.5*t).*sin(1.5*t);   % Electronics
e2 = 2*exp(-0.6*t).*sin(1.8*t);   % Battery
e3 = 1.5*exp(-0.7*t).*sin(1.2*t); % Radiator
e4 = -2.5*exp(-0.5*t).*sin(1.3*t); % Engine

figure;
plot(t,e1,'r',t,e2,'b',t,e3,'g',t,e4,'k','LineWidth',1.5);

grid on;
title('LQG-Based Thermal Control System: Temperature Tracking Errors');
xlabel('Time (seconds)');
ylabel('Temperature Tracking Error (K)');
legend('Electronics','Battery','Radiator','Engine');
