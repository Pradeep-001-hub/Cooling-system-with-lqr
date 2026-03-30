function dx = lqr_disturbance_function(t,x,K,A,B,D,T_ref)
disturbances = [2*sin(0.1*t); 1.5*sin(0.2*t); 1*sin(0.15*t)];
u = -K*(x - T_ref);
dx = A*x + B*u + D*disturbances;
end