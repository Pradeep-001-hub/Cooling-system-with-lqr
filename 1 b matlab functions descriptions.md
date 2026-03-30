MATLAB Functions – Brief Description

Modeling

- ss(A,B,C,D) – Creates a state-space model of the system.
- tf(num,den) – Creates a transfer function model.
- zpk(z,p,k) – Represents system using zeros, poles, gain.
- ss2tf() – Converts state-space → transfer function.
- tf2ss() – Converts transfer function → state-space.

---
simulation

- step(sys) – Plots step response of system.
- impulse(sys) – Plots impulse response.
- lsim(sys,u,t) – Simulates system with custom input.
- initial(sys,x0) – Response for given initial state.

---

Controllers

- pid(Kp,Ki,Kd) – Creates PID controller.
- lqr(A,B,Q,R) – Computes optimal LQR gain.
- lqe(A,G,C,Q,R) – Computes Kalman estimator gain.
- kalman(sys,Q,R) – Builds Kalman filter.
- lqg(sys,Q,R) – Combines LQR + Kalman filter.
- feedback(sys1,sys2) – Forms closed-loop system.

---
Stability & Analysis

- eig(A) – Finds eigenvalues (stability check).
- pole(sys) – Returns system poles.
- zero(sys) – Returns system zeros.
- damp(sys) – Natural frequency & damping ratio.
- isstable(sys) – Checks if system is stable.

---

 System Properties

- ctrb(A,B) – Controllability matrix.
- obsv(A,C) – Observability matrix.
- rank(M) – Rank of matrix (used for checks).

---

Frequency Response

- bode(sys) – Bode plot (frequency response).
- nyquist(sys) – Nyquist stability plot.
- margin(sys) – Gain & phase margins.

---

performance Metrics

- stepinfo(sys) – Gives rise time, settling time, overshoot.

---

Plotting

- plot(x,y) – Basic plotting.
- subplot() – Multiple plots in one figure.
- figure – Opens new plot window.
- title() – Adds title to plot.
- xlabel(), ylabel() – Axis labels.
- legend() – Adds legend.
- grid on – Enables grid.
- hold on – Overlays multiple plots.

---

 Utilities

- linspace(a,b,n) – Generates evenly spaced points.
- zeros(), ones() – Creates arrays.
- clear – Clears workspace.
- clc – Clears command window.
- close all – Closes all figures.