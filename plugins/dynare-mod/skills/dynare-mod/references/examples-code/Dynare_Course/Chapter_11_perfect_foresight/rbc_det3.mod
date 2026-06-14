@#include "rbc_model_eq.inc"

steady;

shocks;
  var epsilon;
  periods 4, 5:8;
  values 0.04, 0.01;
end;

perfect_foresight_setup(periods=300);
perfect_foresight_solver;

rplot c;
rplot k;
