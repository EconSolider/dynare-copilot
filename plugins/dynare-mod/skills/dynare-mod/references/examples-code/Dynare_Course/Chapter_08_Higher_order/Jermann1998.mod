var c $C$
    k $K$
    invest $I$ 
    z $z$
    lambda $\lambda$ 
    q $q$
    w $W$
    d $d$
    V_k ${V^k}$
    V_b ${V^b}$
    y $Y$
    r_k ${r^K}$     
    r_f ${r^f}$
    c_growth ${\Delta C}$
    y_growth ${\Delta Y}$
    i_growth ${\Delta I}$
    log_d ${\log(d)}$
    log_V_k ${\log(V^k)}$
    log_V_b ${\log(V^b)}$
    log_r_f ${\log(r^f)}$
    log_r_k ${\log(r^k)}$
    log_lambda ${\log(\lambda)}$
    SDF
    rf_ann 
    rk_ann 
    rp_ann 
    erp1;

varexo e;
predetermined_variables k;
parameters 
    betastar ${\beta^*}$
    delta ${\delta}$
    alpha ${\alpha}$
    sigma ${\sigma}$
    rho ${\rho}$
    gamma ${\gamma}$
    tau ${\tau}$
    h ${h}$
    xi ${\xi}$
    const ${c}$
    a ${a}$
    b ${b}$
    i_k ${\frac{I}{K}}$
    k_ss ${\bar K}$;

%----------------------------------------------------------------
% 2. Calibration
%----------------------------------------------------------------
gamma   = 1.005; //long-run growth rate
alpha   = 0.36; //capital share
delta   = 0.025; //depreciation rate
tau     = 5; //risk aversion
sigma   = (0.0064/(1-alpha));
h       = 0.82;//0.82 ; //habit parameter (originally called alpha in the paper) 
betastar= gamma/1.011138; //discount factor
rho     = 0.99; //autocorrelation productivity 
xi      = .23; //elasticity of investment-capital ratio wrt to q

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model;
//1. Marginal utility  
lambda=(c-h/gamma*c(-1))^(-tau)-betastar*h/gamma*(c(+1)-h/gamma*c)^(-tau);
//2. Euler equation stocks
lambda*V_k = betastar*lambda(+1)*(V_k(+1)+d(+1));
//3. Budget constraint HH with a=1
//w+d=c;
//4. Definition dividends
d=exp(z)*k^alpha-w-invest;
//5. Real wage
w=(1-alpha)*exp(z)*k^alpha;
c+invest = exp(z)*k^alpha;
//6. LOM capital
gamma*k(+1) = (1-delta)*k+(b/(1-a)*(invest/k)^(1-a)+const)*k;
//7. FOC capital
lambda*q*gamma=betastar*lambda(+1)*(alpha*exp(z(+1))*k(+1)^(alpha-1)
                                    +q(+1)*(1-delta+const+b*a/(1-a)*(invest(+1)/k(+1))^(1-a)));
//8. FOC investment  
1=q*b*(invest/k)^-a;
//9. LOM technology
z = rho*z(-1)+e;
//10. LOM technology
y=exp(z)*k^alpha;
r_k=1/q*(alpha*exp(z(+1))*k(+1)^(alpha-1)+q(+1)*(1-delta+const+b*a/(1-a)*(invest(+1)/k(+1))^(1-a)));
SDF=betastar/gamma*lambda(+1)/lambda;
r_f= 1/SDF;
log_r_f=log(r_f); 
log_r_k=log(r_k); 

erp1 = r_k - r_f;
rf_ann=4*(r_f-1); 
rk_ann=4*(r_k-1); 
rp_ann=4*erp1;

//11. Consol
lambda*V_b = betastar*lambda(+1)*(V_b(+1)+1/betastar-1);
y_growth=log(y)-log(y(-1));
i_growth=log(invest)-log(invest(-1));
c_growth=log(c)-log(c(-1));
log_V_k=log(V_k);
log_V_b=log(V_b);
log_d=log(d);
log_lambda=log(lambda);
end;

%----------------------------------------------------------------
% 4. Computation
%----------------------------------------------------------------

steady_state_model;
  a= 1/xi;//1/xi;  //used in functional form
  //beta=betastar*gamma^(1-tau);
  i_k=1-1/gamma*(1-delta);
  b=i_k^a;
  const=gamma*i_k-b/(1-a)*i_k^(1-a);
  k_ss=((gamma/betastar-(1-delta+const + b*a/(1-a)*i_k^(1-a)))/alpha)^(1/(alpha-1));
  q=1;
  z = 0;
  k=k_ss;
  invest=i_k*k;
  w=(1-alpha)*k^alpha;
  y=k^alpha;
  y_growth=0;
  d=k^alpha-w-invest;
  c=w+d;
  lambda=(c*(1-h/gamma))^(-tau)*(1-betastar*h/gamma);
  r_k=(alpha*k^(alpha-1)+q*(1-delta+const+b*a/(1-a)*(invest/k)^(1-a)));
  r_f= 1/(betastar/gamma);
  erp1 = r_k - r_f;
  rf_ann=4*(r_f-1); 
  rk_ann=4*(r_k-1); 
  rp_ann=4*erp1;
  V_k=d/(1/betastar-1);
  V_b=1;
  log_V_k=log(V_k);
  log_V_b=log(V_b);
  log_d=log(d);
  log_r_f=log(r_f); 
  log_r_k=log(r_k); 
  log_lambda=log(lambda);
  m1   = (betastar/gamma);
  rf1  = 1/m1;
  SDF=betastar/gamma;
end;

write_latex_dynamic_model;

shocks;
var e = sigma^2; //picked to set output volatility to 1
end;

//resid(1);
steady;
stoch_simul(order = 1,irf=0) y_growth c_growth i_growth ; 


%----------------------------------------------------------------
% generate IRFs and compute model moments
%----------------------------------------------------------------
stoch_simul(order = 1,irf=0);

verbatim;
k_ss=oo_.dr.ys(strmatch('k',M_.endo_names))
state_range=0.7*k_ss:0.05:1.3*k_ss;
state_name='k';
plot_var_name='c'
end;

stoch_simul(order = 1,irf=0);
[x,y1,policyfun]=plot_policy_fun(state_name,state_range,plot_var_name);

stoch_simul(order = 2,irf=0);
[x,y2,policyfun]=plot_policy_fun(state_name,state_range,plot_var_name);
stoch_simul(order = 3,irf=0);
[x,y3,policyfun]=plot_policy_fun(state_name,state_range,plot_var_name);

figure
plot(x,y1,'b-',x,y2,'r--',x,y3,'k-.');
legend('First Order','Second Order','Third Order')
xlabel('k(-1)')
ylabel('c')
axis tight

stoch_simul(order = 1,irf=0);
print -depsc2 Jermann_policyfun_benchmark

verbatim;
k_ss=oo_.dr.ys(strmatch('k',M_.endo_names))
state_range=0.7*k_ss:0.05:1.3*k_ss;
state_name='k';
plot_var_name='c'
end;


set_param_value('h',0)
set_param_value('tau',1)
set_param_value('xi',10000)

stoch_simul(order = 1,irf=0);
[x,y1,policyfun]=plot_policy_fun(state_name,state_range,plot_var_name);

stoch_simul(order = 2,irf=0);
[x,y2,policyfun]=plot_policy_fun(state_name,state_range,plot_var_name);
stoch_simul(order = 3,irf=0);
[x,y3,policyfun]=plot_policy_fun(state_name,state_range,plot_var_name);

figure
plot(x,y1,'b-',x,y2,'r--',x,y3,'k-.');
legend('First Order','Second Order','Third Order')
xlabel('k(-1)')
ylabel('c')
axis tight

print -depsc2 Jermann_policyfun_RBC_baseline


%----------------------------------------------------------------
% 5. Some Results
%----------------------------------------------------------------

stoch_simul(order = 2,irf=0,periods=50000) V_k d r_f r_k;

E_r_f=mean(exp(log_r_f)-1)*400

R=gamma*(exp(log_V_k(2:end))+exp(log_d(2:end)))./exp(log_V_k(1:end-1));
E_r_k=(mean(R)-1)*400

R_b=gamma*(exp(log_V_b(2:end))+1/betastar-1)./exp(log_V_b(1:end-1));
E_r_b=(mean(R_b)-1)*400

E_r_k-E_r_b
