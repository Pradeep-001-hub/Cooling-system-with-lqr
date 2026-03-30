clear; clc; close all;

A = [-0.05  0.02  0     0;
      0.01 -0.06  0.03  0;
      0     0.02 -0.07  0.02;
      0     0     0.01 -0.05];

B = [0.1 0   0   0;
     0   0.1 0   0;
     0   0   0.1 0;
     0   0   0   0.1];

C = eye(4);

x0 = [290;305;275;315];
xhat0 = [285;300;270;310];

tspan = [0 50];

W = 0.05*eye(4);
V = 0.5*eye(4);

[L,~,~] = lqe(A,eye(4),C,W,V);

[t,x] = ode45(@(t,x) system_dynamics(t,x,A,B), tspan, x0);

x_hat = zeros(length(t),4);
x_hat(1,:) = xhat0';

for i = 2:length(t)
    y = x(i,:)' + 0.5*randn(4,1);
    x_hat(i,:)' = x_hat(i-1,:)' + L*(y - x_hat(i-1,:)');
end

figure
plot(t,x(:,1),'LineWidth',2)
hold on
plot(t,x_hat(:,1),'--','LineWidth',2)
plot(t,x(:,2),'LineWidth',2)
plot(t,x_hat(:,2),'--','LineWidth',2)
plot(t,x(:,3),'LineWidth',2)
plot(t,x_hat(:,3),'--','LineWidth',2)
plot(t,x(:,4),'LineWidth',2)
plot(t,x_hat(:,4),'--','LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Temperature (K)')
title('Kalman Filter State Estimation')
legend('True T1','Estimated T1','True T2','Estimated T2','True T3','Estimated T3','True T4','Estimated T4')


% supporting function
function dx = system_dynamics(t,x,A,B)
u = zeros(4,1);
dx = A*x + B*u;
end