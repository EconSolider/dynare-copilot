@#include "rbc_model_eq.inc"

initval;
  epsilon = 0;
end;

steady;

endval;
  epsilon = (1-rho)*log(1.05);
end;

steady;

shocks;
  var epsilon;
  periods 1:5;
  values 0;
end;

perfect_foresight_setup(periods=300);
perfect_foresight_solver;

rplot c;
rplot k;
