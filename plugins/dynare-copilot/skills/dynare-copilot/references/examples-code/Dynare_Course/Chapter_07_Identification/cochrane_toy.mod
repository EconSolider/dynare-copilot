var pi nom_int nu;
varexo epsil;

//define parameters

parameters rho phi sig_nu;

// set parameter values
rho=0.95;
phi=2.5;
sig_nu=0.01;

//enter the model equations (model-block)
model(linear);
#PHI=1+phi;
//1. Fisher
nom_int=2+pi(+1);
//2. Policy reaction function
nom_int=2+PHI*pi+nu;
nu=rho*nu(-1)+sig_nu*epsil;
end;

//set steady state values computed above
steady_state_model;
nu=0;
pi=0;
nom_int=2;
end;

//set shock variances
shocks;
    var epsil=1;
end;

//check the starting values for the steady state
resid;

// compute steady state given the starting values
steady;
// check Blanchard-Kahn-conditions
check;
stoch_simul(order=1);

estimated_params;
    rho,0.5;
    phi,0.5;
    sig_nu,0.01;
end;

/*
estimated_params;
    rho, uniform_pdf,0.5,sqrt(1/12);
    phi, uniform_pdf,0.5,sqrt(1/12);
end;
*/

varobs pi nom_int;
identification(no_identification_minimal,no_identification_spectrum,advanced=1);

