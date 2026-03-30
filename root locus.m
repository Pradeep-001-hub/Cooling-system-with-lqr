clc; clear; close all;

%% Define Transfer Function (Example Thermal System Model)
% You can modify poles to match your exact system
num = 1;
den = conv([1 2],[1 4]);   % (s+2)(s+4)
den = conv(den,[1 6]);     % (s+2)(s+4)(s+6)

G = tf(num, den);

%% Plot Root Locus
figure;
rlocus(G);
hold on;
grid on;

%% Get Open Loop Poles
p = pole(G);

% Plot poles (blue cross)
plot(real(p), imag(p), 'bx', 'MarkerSize', 10, 'LineWidth', 2);

%% Add Asymptotes
n = length(p);   % poles
m = length(zero(G)); % zeros

% Number of asymptotes
q = n - m;

% Centroid
centroid = sum(real(p)) / q;

% Asymptote angles
angles = (2*(0:q-1)+1)*180/q;

% Plot asymptotes
x = linspace(-10,10,100);

for k = 1:length(angles)
    theta = angles(k)*pi/180;
    y = tan(theta)*(x - centroid);
    plot(x, y, 'r--', 'LineWidth', 1.5);
end

%% Mark a sample gain point
[K, poles] = rlocus(G);
k_index = round(length(K)/2);
selected_poles = poles(:,k_index);

plot(real(selected_poles), imag(selected_poles), 'kx', ...
    'MarkerSize', 12, 'LineWidth', 2);

%% Labels & Title
title('Root Locus Plot of Thermal Control System (LQG Plant)');
xlabel('Real Axis (s)');
ylabel('Imaginary Axis (s)');

legend('Root Locus','Open-loop Poles','Asymptotes','Selected Poles');


% state space to tranfer function
A = [...];
B = [...];
C = [...];
D = 0;

sys = ss(A,B,C,D);
G = tf(sys);



% damping ratio
zeta = 0.5; % damping ratio
wn = 0:0.1:20;

for i = 1:length(wn)
    sigma = -zeta*wn(i);
    wd = wn(i)*sqrt(1-zeta^2);
    plot([sigma sigma], [-wd wd], 'k:');
end


