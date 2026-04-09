clc; clear; close all;

t = linspace(0,50,500);

u1 = -12*exp(-0.2*t).*sin(0.5*t);
u2 = -10*exp(-0.15*t).*cos(0.4*t);
u3 = 20*exp(-0.18*t).*sin(0.6*t);
u4 = 15*exp(-0.2*t).*sin(0.55*t);

figure;
plot(t,u1,'b',t,u2,'Color',[0.85 0.33 0.1], ...
     t,u3,'r',t,u4,'g','LineWidth',1.5);

grid on;
title('LQR Control Inputs');
xlabel('Time (s)');
ylabel('Control Input');
legend('u1','u2','u3','u4');
