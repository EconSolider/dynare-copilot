@#include "rbc_model_eq.inc"

steady;

ik = varlist_indices('k',M_.endo_names);
kstar = oo_.steady_state(ik);

histval;
  k(0) = kstar/2;
end;

perfect_foresight_setup(periods=300);
perfect_foresight_solver;

rplot c;
rplot k;
