/* 1. make sure you set the path to Dynare via Home -> Set Path -> Add Folder -> chose the matlab-subfolder of Dynare
 * otherwise Matlab will say "Undefined function 'dynare' for input arguments of type 'char'."
 *
 * 2. make sure that your Matlab-path is set to the folder where your .mod-file is saved; otherwise Dynare will not find the mod-file
 * otherwise Dynare will say "Error using dynare (line 96); DYNARE: can't open myRBCmodel.mod"
 * You can set the path for example by right-clicking on the name of the file in the gray status-bar 
 * of the editor and choosing "Change current folder to..."

 * 3. Type "dynare myRBCmodel" (or how you named your mod-file) into the command window
*/
/*******************************************
 The mod-file
*****************************************/

// define variables

var y c k l z ghat r w  invest c_obs g_obs y_obs;
varexo eps_z eps_g;

//define parameters

parameters beta psi sigma delta alpha rhoz gammax
    gshare l_ss k_ss i_ss y_ss g_ss c_ss rhog;

// set parameter values
sigma=1;                // risk aversion
alpha= 0.33;            // capital share
i_y=0.25;               // investment-output ration
k_y=10.4;               // capital-output ratio
x=0.0055;               // technology growth (per capita output growth)
n=0.0027;               // population growth
gammax=(1+n)*(1+x);
delta=i_y/k_y-x-n-n*x;  //deprecation rate
beta=gammax/(alpha/k_y+(1-delta)); //discount factor
rhoz=0.97;              //technology autocorrelation base on linearly detrended Solow residual
rhog=0.98;
gshare=0.2038;          //government spending share

// calibrate the model to steady state labor of 0.33, i.e. compute the corresponding steady state values
// and the labor disutility parameter by hand; the steady state values are used later in the initval-block

l_ss=0.33;
k_ss=((1/beta*gammax-(1-delta))/alpha)^(1/(alpha-1))*l_ss;
i_ss=(x+n+delta+n*x)*k_ss;
y_ss=k_ss^alpha*l_ss^(1-alpha);
g_ss=gshare*y_ss;
c_ss=y_ss-i_ss-g_ss;
psi=(1-alpha)*(k_ss/l_ss)^alpha*(1-l_ss)/c_ss^sigma;

//enter the model equations (model-block)
model;
//1. Euler equation
exp(c)^(-sigma)=beta/gammax*exp(c(+1))^(-sigma)*
    (alpha*exp(z(+1))*(exp(k)/exp(l(+1)))^(alpha-1)+(1-delta));
//2. Labor FOC
psi*exp(c)^sigma*1/(1-exp(l))=exp(w);
//3. Law of motion capital 
gammax*exp(k)=(1-delta)*exp(k(-1))+exp(invest);
//4. resource constraint
exp(y)=exp(invest)+exp(c)+g_ss*exp(ghat);
//5. production function
exp(y)=exp(z)*exp(k(-1))^alpha*exp(l)^(1-alpha);
//6. real wage/firm FOC labor
exp(w)=(1-alpha)*exp(y)/exp(l);
//7. annualized real interst rate/firm FOC capital
r=4*alpha*exp(y)/exp(k(-1));
//8. exogenous TFP process
z=rhoz*z(-1)+eps_z;
//9. government spending process
ghat=rhog*ghat(-1)+eps_g;

c_obs = c - c(-1);
g_obs = ghat - ghat(-1);
y_obs = y - y(-1);
end;

//set steady state values computed above
steady_state_model;
    invest=log(i_ss);
    w=log((1-alpha)*y_ss/l_ss);
    r=4*alpha*y_ss/k_ss;
    y=log(y_ss);
    k=log(k_ss);
    c=log(c_ss);
    l=log(l_ss);
    z=0;
    ghat=0;
    c_obs=0;
    g_obs=0;
    y_obs=0;
end;

//set shock variances
shocks;
    var eps_z=1; //0.68^2 in data
    var eps_g=1; //1.05^2 in data
end;

//check the starting values for the steady state
resid(1);

// compute steady state given the starting values
steady;
// check Blanchard-Kahn-conditions
check;

estimated_params;
    rhog, beta_pdf,0.7,0.1;
    rhoz, beta_pdf,0.7,0.1;
    stderr eps_z, inv_gamma_pdf, 0.01, 0.01;
    stderr eps_g,inv_gamma_pdf,0.01, 0.01;
end;

varobs g_obs c_obs;

estimation(datafile=first_diff,mh_jscale=0.2,mode_check,mode_check_symmetric_plots=1,prior_trunc=0,mh_replic=30000,mh_nblocks=2);

trace_plot(options_,M_,estim_params_,'StructuralShock',1,'eps_z')
mh_autocorrelation_function(options_,M_,estim_params_,'StructuralShock',1,'eps_z')
