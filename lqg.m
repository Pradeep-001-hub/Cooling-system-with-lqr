Acl_lqg = [A - B*K     B*K;
           zeros(n)    A - L*C];

Bcl = [B;
       zeros(size(B))];

Ccl = [C zeros(size(C))];

Dcl = 0;

sys_lqg = ss(Acl_lqg,Bcl,Ccl,Dcl);

t = linspace(0,10,1000);

figure
step(sys_lqg,t)
grid on
title('LQG Closed Loop Response')