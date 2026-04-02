clear; clc; close all;

% System (example 4-state cooling model — adjust if needed)
A = [0 1 0 0;
    -2 -0.5 1 0;
     0 0 0 1;
     0 -1 -2 -0.5];

B = [0; 1; 0; 1];
C = [1 0 0 0];
D = 0;

% Time
tspan = [0 20];
dt = 0.01;
t = tspan(1):dt:tspan(2);

% Initial conditions
x0 = [5; 0; 3; 0];
x_hat0 = [0; 0; 0; 0];

% LQR Design
Q = diag([10 1 10 1]);
R = 0.1;
K = lqr(A,B,Q,R);

% Kalman Filter (LQG)
Qn = 0.01*eye(4);
Rn = 0.05;
[L,~,~] = lqe(A, eye(4), C, Qn, Rn);

% PID gains
Kp = 5; Ki = 1; Kd = 2;

% Storage
x_lqr = zeros(length(t),4);
x_lqg = zeros(length(t),4);
x_pid = zeros(length(t),4);

u_lqr = zeros(length(t),1);
u_lqg = zeros(length(t),1);
u_pid = zeros(length(t),1);

x = x0;
x_hat = x_hat0;
x_p = x0;

e_prev = 0;
e_int = 0;

for i = 1:length(t)
    
    % Disturbance
    d = 0;
    if t(i) > 5
        d = 3;
    end
    E = [0;1;0;0];
    
    %LQR 
    u1 = -K*x;
    dx1 = A*x + B*u1 + E*d;
    x = x + dx1*dt;
    
    % LQG 
    y = C*x + 0.05*randn; % noise
    u2 = -K*x_hat;
    dx2 = A*x + B*u2 + E*d;
    dx_hat = A*x_hat + B*u2 + L*(y - C*x_hat);
    
    x_hat = x_hat + dx_hat*dt;
    
    % PID 
    y_pid = C*x_p;
    e = 0 - y_pid;
    e_int = e_int + e*dt;
    e_der = (e - e_prev)/dt;
    
    u3 = Kp*e + Ki*e_int + Kd*e_der;
    dx3 = A*x_p + B*u3 + E*d;
    x_p = x_p + dx3*dt;
    
    e_prev = e;
    
    % Store
    x_lqr(i,:) = x';
    x_lqg(i,:) = x_hat';
    x_pid(i,:) = x_p';
    
    u_lqr(i) = u1;
    u_lqg(i) = u2;
    u_pid(i) = u3;
end

% =function [x_hat,P] = kalman_filter(x_hat,P,u,y,A,B,C,Qn,Rn)

x_pred = A*x_hat + B*u;
P_pred = A*P*A' + Qn;

Kf = P_pred*C'/(C*P_pred*C' + Rn);

x_hat = x_pred + Kf*(y - C*x_pred);
P = (eye(size(A)) - Kf*C)*P_pred;

endfunction [x_hat,P] = kalman_filter(x_hat,P,u,y,A,B,C,Qn,Rn)

x_pred = A*x_hat + B*u;
P_pred = A*P*A' + Qn;

Kf = P_pred*C'/(C*P_pred*C' + Rn);

x_hat = x_pred + Kf*(y - C*x_pred);
P = (eye(size(A)) - Kf*C)*P_pred;

endfunction [x_hat,P] = kalman_filter(x_hat,P,u,y,A,B,C,Qn,Rn)

x_pred = A*x_hat + B*u;
P_pred = A*P*A' + Qn;

Kf = P_pred*C'/(C*P_pred*C' + Rn);

x_hat = x_pred + Kf*(y - C*x_pred);
P = (eye(size(A)) - Kf*C)*P_pred;

end

% State comparison
figure
plot(t,x_lqr(:,1),'LineWidth',2)
hold on
plot(t,x_lqg(:,1),'LineWidth',2)
plot(t,x_pid(:,1),'LineWidth',2)
xlabel('Time')
ylabel('State (Temperature)')
title('PID vs LQR vs LQG')
legend('LQR','LQG','PID')
grid on

% Control effort
figure
plot(t,u_lqr,'LineWidth',2)
hold on
plot(t,u_lqg,'LineWidth',2)
plot(t,u_pid,'LineWidth',2)
xlabel('Time')
ylabel('Control Input')
title('Control Effort Comparison')
legend('LQR','LQG','PID')
grid on

% Disturbance response zoom
figure
plot(t,x_lqr(:,1),'LineWidth',2)
hold on
plot(t,x_lqg(:,1),'LineWidth',2)
xline(5,'--r','Disturbance')
xlabel('Time')
ylabel('Temperature')
title('Disturbance Response (LQR vs LQG)')
legend('LQR','LQG')
grid on
