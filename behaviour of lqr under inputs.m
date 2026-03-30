clear; clc; close all;
load('lqg_system.mat');

[t,x] = ode45(@(t,x) lqg_system_function(t,x,K,L,A,B,D,C,T_ref), tspan, x0);

u = zeros(length(t),4);
for i = 1:length(t)
    x_est = x(i,:)';
    u(i,:) = -K*(x_est - T_ref)';
end

figure
plot(t,u(:,1),'LineWidth',2)
hold on
plot(t,u(:,2),'LineWidth',2)
plot(t,u(:,3),'LineWidth',2)
plot(t,u(:,4),'LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Control Input')
title('LQR Control Inputs')
legend('u1','u2','u3','u4')