@#include "rbc_model_eq.inc"

steady;

// Declare shocks as in a stochastic setup
shocks;
  var epsilon;
  stderr 0.02;
end;

extended_path(periods=300);

// Plot 20 first periods of consumption
ic = varlist_indices('c', M_.endo_names);
plot(oo_.endo_simul(ic, 1:21));
