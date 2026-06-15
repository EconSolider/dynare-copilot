// Endogenous variables: consumption and capital
var c k A;

// Exogenous variable: technology level
varexo epsilon;

// Parameters declaration and calibration
parameters alpha beta gamma delta rho;

alpha = 0.5;
beta = 0.95;
gamma = 0.5;
delta = 0.02;
rho=0.9;

// Equilibrium conditions
model;
  c + k = exp(A)*k(-1)^alpha + (1-delta)*k(-1); // Resource constraint
  c^(-gamma) = beta*c(+1)^(-gamma)*(alpha*exp(A(+1))*k^(alpha-1) + 1 - delta); // Euler equation
  A= rho*A(-1)+epsilon;
end;

steady_state_model;
  A = 0;
  k = ((1-beta*(1-delta))/(beta*alpha*exp(A)))^(1/(alpha-1));
  c = exp(A)*k^alpha-delta*k;
end;

steady; %sets initial and terminal condition

perfect_foresight_controlled_paths;
  exogenize k;
  periods 2;
  values 50;
  endogenize epsilon;

  exogenize k;
  periods 10;
  values 55;
  endogenize epsilon;
end;

perfect_foresight_setup(periods=150);
perfect_foresight_solver;
rplot k;
rplot A;
