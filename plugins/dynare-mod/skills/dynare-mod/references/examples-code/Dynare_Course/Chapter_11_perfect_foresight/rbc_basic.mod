// Endogenous variables: consumption and capital
var c k;

// Exogenous variable: technology level
varexo A;

// Parameters declaration and calibration
parameters alpha beta gamma delta;

alpha = 0.5;
beta = 0.95;
gamma = 0.5;
delta = 0.02;

// Equilibrium conditions
model;
  c + k = A*k(-1)^alpha + (1-delta)*k(-1); // Resource constraint
  c^(-gamma) = beta*c(+1)^(-gamma)*(alpha*A(+1)*k^(alpha-1) + 1 - delta); // Euler equation
end;

steady_state_model;
  k = ((1-beta*(1-delta))/(beta*alpha*A))^(1/(alpha-1));
  c = A*k^alpha-delta*k;
end;

// set initial and terminal condition to steady state
initval;
  A = 1;
end;
steady;

// Declare a positive technological shock in period 1
shocks;
  var A;
  periods 1;
  values 1.2;
end;

// Prepare the deterministic simulation of the model over 100 periods
perfect_foresight_setup(periods=100);

// Perform the simulation
perfect_foresight_solver;

// Display the path of consumption
rplot c;
