A = [0 1; -0.5 -1];
B = [0; 1];
C = [1 0];
D = 0;

n = size(A,1);

sys = ss(A,B,C,D);