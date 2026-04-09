info_lqr = stepinfo(y_lqr, t_lqr);
info_pid = stepinfo(y_pid, t_pid);

disp('LQR Performance:')
disp(info_lqr)

disp('PID Performance:')
disp(info_pid)
