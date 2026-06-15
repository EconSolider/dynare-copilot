@#include "rbc_model_eq.inc"

steady;

shocks;
  var epsilon;
  periods 1;
  values -0.1;
end;

perfect_foresight_setup(periods=300);
perfect_foresight_solver;

rplot c;
rplot k;
