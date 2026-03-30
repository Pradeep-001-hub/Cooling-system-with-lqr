clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];
C = [1 0];
D = 0;

n = size(A,1);

%% Controllability
Co = ctrb(A,B);
rank_Co = rank(Co)

if rank_Co == n
    disp('System is Controllable')
else
    disp('System is NOT Controllable')
end

%% Observability
Ob = obsv(A,C);
rank_Ob = rank(Ob)

if rank_Ob == n
    disp('System is Observable')
else
    disp('System is NOT Observable')
end

%% Controllability Gramian
Wc = gram(ss(A,B,C,D),'c');
eig_Wc = eig(Wc)

%% Observability Gramian
Wo = gram(ss(A,B,C,D),'o');
eig_Wo = eig(Wo)

disp('If ranks = n → fully controllable & observable')
disp('If Gramian eigenvalues > 0 → strong controllability & observability')