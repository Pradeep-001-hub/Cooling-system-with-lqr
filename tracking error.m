clear; clc; close all;
load('lqg_system.mat');

[t,x] = ode45(@(t,x) lqg_system_function(t,x,K,L,A,B,D,C,T_ref), tspan, x0);

figure
plot(t,(x(:,1)-T_ref(1)),'LineWidth',2)
hold on
plot(t,(x(:,2)-T_ref(2)),'LineWidth',2)
plot(t,(x(:,3)-T_ref(3)),'LineWidth',2)
plot(t,(x(:,4)-T_ref(4)),'LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Tracking Error (K)')
title('Temperature Tracking Errors')
legend('Electronics','Battery','Radiator','Engine')