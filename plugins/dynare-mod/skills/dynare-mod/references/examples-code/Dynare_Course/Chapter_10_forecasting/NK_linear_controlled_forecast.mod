%----------------------------------------------------------------
% Variable declarations
%----------------------------------------------------------------
var 
    pie     ${\pi}$             (long_name = 'Quarterly inflation rate')
    y       ${y}$               (long_name = 'Output gap')
    inom    ${i}$               (long_name = 'Nom. interest rate')
    eps_a  ${\varepsilon_a}$    (long_name = 'Cost-push shock process')
    eps_i  ${\varepsilon_i}$    (long_name = 'Monetary policy shock process')
    eps_c  ${\varepsilon_c}$    (long_name = 'Demand shock process')   
    ;     

varexo 
    u_a   ${u_a}$   (long_name='Cost-push shock')
    u_i   ${u_i}$   (long_name='Monetary policy shock')
    u_c   ${u_c}$   (long_name='Demand shock')
    ;

parameters 
    betta   ${\beta}$       (long_name='Discount factor')
    theta   ${\theta}$      (long_name='Calvo parameter')
    eta     ${\eta}$        (long_name='Labour supply elasticity')
    sig     ${\sigma}$      (long_name='IES')
    phi_pi  ${\phi_{\pi}}$  (long_name='Inflation feedback Taylor Rule')
    phi_y   ${\phi_{y}}$    (long_name='Output feedback Taylor Rule')
    rho_a   ${\rho_a}$      (long_name='Autocorrelation cost-push shock')
    rho_c   ${\rho_c}$      (long_name='Autocorrelation demand shock')
    rho_i   ${\rho_{i}}$    (long_name='Autocorrelation monetary policy shock')
    ;   
%----------------------------------------------------------------
% Parametrization, some from p. 52 in Gali ch 3
%----------------------------------------------------------------
betta   = 0.995;
eta     = 1;
theta   = 0.78;
phi_pi  = 1.5;
phi_y   = .5/4;
rho_a   = 0.8;
rho_c   = 0.9;
rho_i   = 0.5;
sig     = 1;

model_local_variable kappa $\kappa$;

%----------------------------------------------------------------
% Model declaration
%----------------------------------------------------------------
model(linear);

#kappa = (sig+eta)*(1-theta)*(1-betta*theta)/theta;

[name='Phillips Curve']   
pie=betta*pie(+1)+kappa*y+eps_a;

[name='DIS curve']
y=y(+1)-1/sig*(inom-pie(+1))+eps_c;

[name='Nominal interest rate Taylor rule']
inom=phi_pi*pie+phi_y*y+eps_i;   

[name='Law of motion for cost-push shocks']
eps_a=rho_a*eps_a(-1)+u_a;

[name='Law of motion for demand shocks']
eps_c=rho_c*eps_c(-1)+u_c;

[name='Law of motion for interest-rate shocks']
eps_i=rho_i*eps_i(-1)+u_i;

end;
%----------------------------------------------------------------
%  define shock variances
%--------------------------------------------------------------- 
shocks;
    var u_c  = 0.005^2;   
    var u_a  = 0.005^2; 
    var u_i  = 0.005^2; 
end;
 
%----------------------------------------------------------------
%  steady states: all 0 due to linear model
%---------------------------------------------------------------
steady_state_model; %redundant
    pie=0;
    y=0;
    inom=0;
    eps_a=0;
    eps_i=0;
    eps_c=0;
end;

%----------------------------------------------------------------
% Run Simulations
%----------------------------------------------------------------
stoch_simul(order = 1,irf=0,irf_plot_threshold=0,tex) y pie inom ;

conditional_forecast_paths;
var inom;
periods  1  2  3:5;
values   0.01 0.02 0.1;
end;

conditional_forecast(parameter_set=calibration, controlled_varexo=(u_i));
plot_conditional_forecast(periods=10) inom y;
