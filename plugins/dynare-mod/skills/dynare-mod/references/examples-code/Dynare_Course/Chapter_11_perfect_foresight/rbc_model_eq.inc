var k   $k$  (long_name='capital stock')
    y   $y$  (long_name='output')
    L   $L$  (long_name='hours worked')
    c   $c$  (long_name='consumption')
    A   $A$  (long_name='TFP')
    a   $a$  (long_name='log TFP')
    ;

varexo epsilon $\varepsilon$  (long_name='TFP shock');

parameters beta     $\beta$     (long_name='discount factor')
           theta    $\theta$    (long_name='consumption share utility')
           tau      $\tau$      (long_name='risk aversion parameter')
           alpha    $\alpha$    (long_name='capital share parameter')
           psi      $\psi$      (long_name='CES elasticity')
           delta    $\delta$    (long_name='depreciation rate')
           rho      $\rho$      (long_name='TFP autocorrelation')
           Astar    ${A^+}$     (long_name='mean TFP')
           ;

beta = 0.99;
theta = 0.357;
tau = 2;
alpha = 0.45;
psi = -0.1;
delta = 0.02;
rho = 0.8;
Astar = 1;

model;
  a = rho*a(-1) + epsilon;
  A = Astar*exp(a);
  y = A*(alpha*k(-1)^psi+(1-alpha)*L^psi)^(1/psi);
  k = y-c + (1-delta)*k(-1);
  (1-theta)/theta*c/(1-L) - (1-alpha)*(y/L)^(1-psi);
  (c^theta*(1-L)^(1-theta))^(1-tau)/c = beta*(c(+1)^theta*(1-L(+1))^(1-theta))^(1-tau)/c(+1)*(alpha*(y(+1)/k)^(1-psi)+1-delta);
end;

steady_state_model;
  a = epsilon/(1-rho);
  A = Astar*exp(a);
  y_over_k=((1/beta-1+delta)/alpha)^(1/(1-psi));
  c_over_k=y_over_k-delta;
  l_over_k=(((y_over_k/A)^psi-alpha)/(1-alpha))^(1/psi);
  y_over_l=y_over_k/l_over_k;
  c_over_l=c_over_k/l_over_k;

  % Compute steady state of the endogenous variables.
  L=1/(1+c_over_l/((1-alpha)*theta/(1-theta)*y_over_l^(1-psi)));
  c=c_over_l*L;
  k=L/l_over_k;
  y=y_over_k*k;
end;
