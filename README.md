# Cooling-system-with-lqr
A attempt to replace pid with lqr controlle



LQG-Based Optimal Thermal Control System for Space Applications

 Overview

This project presents an advanced thermal control system using Linear Quadratic Regulator (LQR) and Kalman Filter, designed for high-reliability aerospace applications.



 Problem Statement

Thermal control is a critical challenge in space systems due to:

- Extreme temperature variations
- External disturbances (solar radiation, eclipse cycles)
- Limited power availability

Traditional controllers like PID:

- Do not handle multi-variable systems efficiently
- Are not optimal in energy usage
- Perform poorly under disturbances

---

Proposed Solution

This project implements an LQG (Linear Quadratic Gaussian) Controller, which combines:

- LQR (Optimal Control) → Minimizes temperature error and energy usage
- 🧠 Kalman Filter → Estimates system states under noisy conditions

---

 System Model

State-space representation:

ẋ = Ax + Bu
y = Cx

Where:

A = [0  1;
-0.5  -1]

B = [0;
1]

C = [1  0]

Control Design

LQR Controller

Minimizes cost function:

J = ∫ (xᵀQx + uᵀRu) dt

Control law:
u = -Kx

---

Kalman Filter

Used for optimal state estimation:

x̂̇ = Ax̂ + Bu + L(y - Cx̂)

---

LQG Controller

Final control input:

u = -Kx̂

---

Simulation Results

✔ LQG Controller

- Fast settling time
- Minimal overshoot
- High disturbance rejection

 PID Controller

- Higher overshoot
- Slower response
- Poor disturbance handling

---

 Applications

- Satellite thermal management
- Avionics cooling systems
- Cryogenic engine temperature control

---

🛠️ Tools Used

- MATLAB
- Simulink
- Control System Toolbox

---


🔬 Future Scope

- Adaptive LQR (gain scheduling)
- AI-based disturbance prediction
- Nonlinear control (MPC integration)

---

🎯 Conclusion

This project demonstrates a model-based optimal thermal control approach that significantly outperforms traditional PID controllers in terms of stability, efficiency, and robustness, making it suitable for modern applications