LQG-Based Optimal Thermal Control System for Space Applications

---

Introduction:

Thermal control is a critical subsystem in aerospace applications, especially in spacecraft and satellites operating under the Indian Space Research Organisation (ISRO). Components in space are exposed to extreme and rapidly changing temperatures due to solar radiation, eclipse cycles, and vacuum conditions.

Maintaining an optimal temperature range is essential for:

- Electronic component reliability
- Battery performance
- Structural integrity

Traditional control strategies such as PID controllers are widely used but exhibit limitations in handling complex, multi-variable, and disturbance-prone environments.

This project proposes a modern optimal control approach using LQR and Kalman Filter (LQG Controller) to overcome these limitations.

---

 Problem Statement

Spacecraft thermal systems face:

- Extreme temperature variations
- External disturbances (solar flux, shadow regions)
- Sensor noise and uncertainties
- Limited power availability

Conventional PID controllers:

- Do not use system dynamics
- Cannot optimally balance performance and energy
- Struggle with multi-variable systems

---

 Classical PID Controller:

 Control Law:

u(t) = Kp·e(t) + Ki∫e(t)dt + Kd·de(t)/dt

Where:

- e(t) = error = desired − actual temperature

---

Limitations of PID:

- Works only on error (no system knowledge)
- Difficult tuning for changing environments
- High overshoot and oscillations
- Not suitable for MIMO systems
- Inefficient energy usage

---

Linear Quadratic Regulator (LQR):

 State-Space Model:

ẋ = Ax + Bu
y = Cx

---

 Objective Function:

J = ∫ (xᵀQx + uᵀRu) dt

Where:

- Q → penalizes state error (temperature deviation)
- R → penalizes control effort (energy usage)

---

 Control Law:

u = -Kx

K is obtained by solving the Algebraic Riccati Equation (ARE):

AᵀP + PA - PBR⁻¹BᵀP + Q = 0




 System Modeling (Thermal System):

The thermal system is modeled using energy balance equations and represented in state-space form:

A = [0  1;
-0.5  -1]

B = [0;
1]

C = [1  0]

---
Controllability:

A system is controllable if all states can be driven using input.

Controllability matrix:

𝒞 = [B  AB]

Condition:
Rank(𝒞) = n

✔ In this system → Fully controllable

---

Observability:

A system is observable if internal states can be estimated from outputs.

Observability matrix:

𝒪 = [C; CA]

Condition:
Rank(𝒪) = n

Fully observable system

---

 Stability Analysis:

Open Loop:

Depends on eigenvalues of A

Closed Loop:

A_cl = A - BK

LQR ensures:

- All eigenvalues in left half-plane
- Asymptotic stability

---

 Kalman Filter (State Estimation)

In real systems:

- Sensors are noisy
- Measurements are incomplete

Kalman Filter estimates true state:

x̂̇ = Ax̂ + Bu + L(y − Cx̂)

Where:

- L = Kalman Gain

---

 LQG Controller:

Combination of:

- LQR (control)
- Kalman Filter (estimation)

Final control law:

u = -Kx̂

---

Performance Metrics

LQR/LQG Performance

- Low overshoot
- Fast settling time
- High disturbance rejection
- Smooth control action

 PID Performance:

- High overshoot
- Oscillatory response
- Poor disturbance rejection
- Higher energy consumption

 Overshoot Comparison:

- PID → Large overshoot due to aggressive correction
- LQR → Minimal overshoot due to optimal control law

Settling Time:

- PID → Longer settling time
- LQR → Faster stabilization

 Energy Efficiency:

LQR minimizes:

xᵀQx → error
uᵀRu → energy

Ensures optimal energy usage (critical for space systems)

---

🛰️ Applications

- Satellite thermal control
- Avionics cooling systems
- Cryogenic engine temperature regulation
- Spacecraft electronics protection

---

Tools Used

- MATLAB
- Control System Toolbox

Future Scope:

- Adaptive LQR (gain scheduling)
- AI-based disturbance prediction
- Nonlinear control (Model Predictive Control)
- Fault-tolerant thermal systems

Conclusion:

This project demonstrates the design and implementation of an optimal thermal control system using LQG methodology, which significantly outperforms classical PID control.

The proposed approach ensures:

- Stability
- Optimal performance
- Energy efficiency
- Robustness to disturbances

These features make it highly suitable for advanced aerospace systems under ISRO, where precision  us needed