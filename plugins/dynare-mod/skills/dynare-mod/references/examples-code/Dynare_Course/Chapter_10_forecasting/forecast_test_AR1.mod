%test whether forecast for AR(1) is correct
// Endogenous variables: consumption and capital
var junk A;

// Exogenous variable: technology level
varexo epsilon;

// Parameters declaration and calibration
parameters rho;

rho=0.9;

// Equilibrium conditions
model;
  A= rho*A(-1)+epsilon;
  junk=0.9*junk(+1);
end;

steady_state_model;
  A = 0;
end;
steady;

// Declare a positive technological shock in period 1
shocks;
  var epsilon=0.01^2;
end;

stoch_simul(order=1,irf=0);

forecast(periods=500,conf_sig=0.95) A;
%% get theoretical forecast error variance for AR(1) process:
var_analytical=NaN(1+500,1);
var_analytical(1)=0; %zero variance in initial period
for ii=1:500
    var_analytical(ii+1)=var_analytical(ii)+(rho^(ii-1))^2*0.01^2;
end
std_analytical=sqrt(var_analytical);

if abs(oo_.forecast.Mean.A-0)>1e-9
    error('Mean forecast does not match theoretical moments')
end
if max(abs(oo_.forecast.HPDsup.A-norminv(0.975)*std_analytical(2:end)))>1e-9
    error('Forecast variance does not match theoretical moments')
end

varobs A;

shocks;
  var epsilon=0.01^2;
  var A=0.01^2;
end;

forecast(periods=500,conf_sig=0.95) A;
std_analytical_ME=sqrt(var_analytical+0.01^2);
if abs(oo_.forecast.Mean.A-0)>1e-9
    error('Mean forecast with ME does not match theoretical moments')
end
if max(abs(oo_.forecast.HPDsup.A-norminv(0.975)*std_analytical(2:end)))>1e-9
    error('Forecast variance with ME does not match theoretical moments')
end
if max(abs(oo_.forecast.HPDsup_ME.A-norminv(0.975)*std_analytical_ME(2:end)))>1e-9
    error('Forecast variance with ME does not match theoretical moments')
end
