s = tf('s');

G = 1/(s^2 + s + 0.5);

Kp = 10;
Ki = 1;
Kd = 1;

pid_c = pid(Kp,Ki,Kd);

sys_pid = feedback(pid_c*G,1);

t = linspace(0,10,1000);

figure
step(sys_pid,t)
grid on
title('PID Response')