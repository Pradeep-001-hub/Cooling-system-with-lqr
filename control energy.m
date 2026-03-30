u_lqr = -K*(y_lqr');
energy_lqr = trapz(t,sum(u_lqr.^2));

error_pid = 1 - y_pid(:,1);
u_pid = Kp*error_pid + Ki*cumtrapz(t,error_pid);

energy_pid = trapz(t,u_pid.^2);

disp(['LQR Energy: ',num2str(energy_lqr)])
disp(['PID Energy: ',num2str(energy_pid)])