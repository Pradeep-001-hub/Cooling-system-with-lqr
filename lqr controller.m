Q = diag([100 10]);
R = 1;

K = lqr(A,B,Q,R);

Acl = A - B*K;
sys_lqr = ss(Acl,B,C,D);

t = linspace(0,10,1000);
x0 = [5; 0];

[y_lqr, t_lqr] = initial(sys_lqr,x0,t);

figure
plot(t_lqr,y_lqr,'LineWidth',2)
grid on