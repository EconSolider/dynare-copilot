@#include "rbc_model_eq.inc"

steady;

shocks;
  var epsilon;
  periods 2025Q3:2025Q4;
  values 0.2;
end;

perfect_foresight_setup(first_simulation_period = 2025Q2,
                        last_simulation_period = 2099Q4);
perfect_foresight_solver;

figure
plot(Simulated_time_series{'c'})
