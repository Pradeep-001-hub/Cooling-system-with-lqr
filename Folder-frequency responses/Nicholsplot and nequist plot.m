clear; clc; close all;

%% Define Transfer Function (Thermal System Approx)
s = tf('s');

G = 10 / ((s+1)*(s+2));   % Example plant (stable thermal system)

% Optional Controller (LQG-like gain)
K = 2;
L = K * G;   % Open-loop system

figure;

subplot(1,2,1);
nyquist(L);
grid on;
title('Nyquist Plot');

hold on;

% Mark critical point (-1,0)
plot(-1,0,'ro','MarkerSize',8,'LineWidth',2);
text(-1.5,0.5,'-1 + j0','Color','r');

% Annotation (Encirclement note)
text(-2,1,'Encirclement of -1 + j0');

%% -----------------------------
% NICHOLS PLOT
% -----------------------------
subplot(1,2,2);
nichols(L);
grid on;
title('Nichols Plot');

hold on;

% Gain & Phase Margins
[Gm,Pm,Wcg,Wcp] = margin(L);

% Convert Gain Margin to dB
Gm_dB = 20*log10(Gm);

% Mark Gain Margin point
if ~isinf(Gm_dB)
    plot(-180, 0, 'ko','MarkerSize',8,'LineWidth',2);
    text(-150,10,['Gain Margin: ' num2str(Gm_dB,'%.2f') ' dB']);
end

xlabel('Phase (deg)');
ylabel('Magnitude (dB)');
