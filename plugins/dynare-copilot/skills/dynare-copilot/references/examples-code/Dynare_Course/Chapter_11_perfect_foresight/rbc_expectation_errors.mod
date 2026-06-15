@#include "rbc_model_eq.inc"

steady;

// Declare pre-announced shocks
shocks(learnt_in=1);
  var epsilon;
  periods 5, 15;
  values -0.1, -0.1;
end;

// Declare shocks learnt in period 10
shocks(learnt_in=10);
  var epsilon;
  periods 10;
  values 0.1;
end;

perfect_foresight_with_expectation_errors_setup(periods=300);
perfect_foresight_with_expectation_errors_solver;

rplot epsilon;
rplot c;
