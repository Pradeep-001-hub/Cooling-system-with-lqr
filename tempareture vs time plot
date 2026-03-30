clear; clc; close all;
load('lqg_system.mat');

[t,x] = ode45(@(t,x) lqg_system_function(t,x,K,L,A,B,D,C,T_ref), tspan, x0);

figure
plot(t,x(:,1),'LineWidth',2)
hold on
plot(t,x(:,2),'LineWidth',2)
plot(t,x(:,3),'LineWidth',2)
plot(t,x(:,4),'LineWidth',2)
yline(T_ref(1),'r--')
yline(T_ref(2),'r--')
yline(T_ref(3),'r--')
yline(T_ref(4),'r--')
grid on
xlabel('Time (s)')
ylabel('Temperature (K)')
title('Node Temperatures vs Reference')
legend('Electronics','Battery','Radiator','Engine','Reference')