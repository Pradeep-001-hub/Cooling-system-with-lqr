clc; clear; close all;

t = linspace(0,100,500);

% Reference temperatures
T_ref = [320 315 310 325];

% Simulated responses
Te = 290 + (T_ref(1)-290)*(1 - exp(-t/20)) + 0.5*randn(size(t)); % Electronics
Tb = 290 + (T_ref(2)-290)*(1 - exp(-t/25)) + 0.4*randn(size(t)); % Battery
Tr = 290 + (T_ref(3)-290)*(1 - exp(-t/30)) + 0.3*randn(size(t)); % Radiator
Teng = 290 + (T_ref(4)-290)*(1 - exp(-t/18)) + 0.6*randn(size(t)); % Engine

figure;
plot(t, Te, 'r', t, Tb, 'b', t, Tr, 'g', t, Teng, 'y', 'LineWidth', 1.5);
hold on;

yline(320,'--k'); yline(315,'--k'); yline(310,'--k'); yline(325,'--k');

grid on;
title('Node Temperatures vs Reference');
xlabel('Time (s)');
ylabel('Temperature (K)');
legend('Electronics','Battery','Radiator','Engine');
