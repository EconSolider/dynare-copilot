// Endogenous variables: consumption and capital
var c k A;

// Exogenous variable: technology level
varexo epsilon;
varexo_det eps_det;

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
  A= rho*A(-1)+epsilon + eps_det;
end;

steady_state_model;
  A = 0;
  k = ((1-beta*(1-delta))/(beta*alpha*exp(A)))^(1/(alpha-1));
  c = exp(A)*k^alpha-delta*k;
end;
steady;

// Declare a positive technological shock in period 1
shocks;
  var epsilon=0.01^2;
  var eps_det;
  periods 8;
  values 1;
end;

stoch_simul(order=1,irf=0);

forecast(periods=20,conf_sig=0.95);