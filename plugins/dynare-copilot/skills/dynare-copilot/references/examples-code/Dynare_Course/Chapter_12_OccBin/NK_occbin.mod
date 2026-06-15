/*
 * This file implements a New Keynesian model subject to the ELB on interest rates
 * and solves it using OccBin.
 */

%-------------------------------------------------------
% Variable declarations
%----------------------------------------------------------------
var 
    pie     ${\pi}$                 (long_name = 'Quarterly inflation rate')
    y       ${y}$                   (long_name = 'Output gap')
    inom    ${i}$                   (long_name = 'Observed nom. interest rate')
    inomnot ${i^{not}}$             (long_name = 'Notional nom. interest rate')
    zeps_a  ${\varepsilon_a}$       (long_name = 'Cost-push shock process')
    zeps_i  ${\varepsilon_i}$       (long_name = 'Monetary policy shock process')
    zeps_c  ${\varepsilon_c}$       (long_name = 'Demand shock process')   
    ;     

varexo 
    u_a   ${u_a}$   (long_name='Cost-push shock')
    u_i   ${u_i}$   (long_name='Monetary policy shock')
    u_c   ${u_c}$   (long_name='Demand shock')
    ;

parameters 
    betta   ${\beta}$       (long_name='Discount factor')
    eta     ${\eta}$        (long_name='Labour supply elasticity')
    ilb     ${i^{lb}}$      (long_name='ELB')
    sig     ${\sigma}$      (long_name='IES')
    theta   ${\theta}$      (long_name='Calvo parameter')
    phi_pi  ${\phi_{\pi}}$  (long_name='Inflation feedback Taylor Rule')
    phi_y   ${\phi_{y}}$    (long_name='Output feedback Taylor Rule')
    rho_a   ${\rho_a}$      (long_name='Autocorrelation cost-push shock')
    rho_c   ${\rho_c}$      (long_name='Autocorrelation demand shock')
    rho_i   ${\rho_{i}}$    (long_name='Autocorrelation monetary policy shock')
    rhoinom ${\rho_{inom}}$ (long_name='Interest-rate smoothing')
    ;   
%----------------------------------------------------------------
% Parametrization, some from p. 52 in Gali ch 3
%----------------------------------------------------------------
betta   = 0.995;
eta     = 1;
ilb     = -0.0055;
phi_pi  = 1.5;
phi_y   = 0.5/4;
rho_a   = 0.8;
rho_c   = 0.9;
rho_i   = 0.5;
rhoinom = 0.8;
sig     = 1;
theta   = 0.78;

model_local_variable kappa ${\kappa}$;

%----------------------------------------------------------------
% Model declaration
%----------------------------------------------------------------
model(linear);
 
#kappa = (sig+eta)*(1-theta)*(1-betta*theta)/theta;

[name='Phillips Curve']   
pie=betta*pie(+1)+kappa*y+zeps_a;

[name='IS curve']
y=y(+1)-1/sig*(inom-pie(+1))+zeps_c;

[name='Notional rate Taylor rule']
inomnot=rhoinom*inomnot(-1)+(1-rhoinom)*(phi_pi*pie+phi_y*y)+zeps_i;   

[name = 'Observed interest rate',relax='zlb']
inom = inomnot;

[name = 'Observed interest rate',bind='zlb']
inom = ilb;

[name='Law of motion for cost-push shocks']
zeps_a=rho_a*zeps_a(-1)+u_a;

[name='Law of motion for demand shocks']
zeps_c=rho_c*zeps_c(-1)+u_c;

[name='Law of motion for interest-rate shocks']
zeps_i=rho_i*zeps_i(-1)+u_i;

end;
 
%----------------------------------------------------------------
%  steady states: all 0 due to linear model (except obs)
%---------------------------------------------------------------
options_.TeX=1;

steady;
check;

%----------------------------------------------------------------
% Run Simulations
%----------------------------------------------------------------

occbin_constraints;
name 'zlb'; bind inomnot<=ilb; 
end;   


shockssequence = -0.01;

shocks(surprise);
    var u_c;
    periods 1;
    values(shockssequence);
end;

occbin_setup;

occbin_solver(simul_periods=20,simul_check_ahead_periods=50);
occbin_graph y inom inomnot pie;
occbin_write_regimes;
occbin.plot_regimes(oo_.occbin.simul.regime_history,M_,options_)