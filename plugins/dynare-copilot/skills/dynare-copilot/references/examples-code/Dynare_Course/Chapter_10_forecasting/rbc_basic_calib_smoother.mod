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
steady;

// Declare a positive technological shock in period 1
shocks;
  var epsilon=0.01^2;
end;

stoch_simul(order=1,irf=0,periods=200) c;

datatomfile ('rbc_data', {'c'});
varobs c;

calib_smoother(datafile='rbc_data',filter_step_ahead=[1:8]);
for var_iter=1:8
    forecast_c(var_iter)=oo_.FilteredVariablesKStepAhead(var_iter,varlist_indices('c',M_.endo_names),200+var_iter);
end
figure
plot(1:8,forecast_c);
title('C, based on filter_step_ahead','Interpreter','none')
print([M_.dname '/graphs/c_forecast'],'-depsc2')
smoother2histval;
forecast(periods=8);