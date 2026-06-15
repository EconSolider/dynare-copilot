% NK_RW06
% 
% Rep-MMB of the Macroeconomic Model Data Base (MMB)
% https://www.macromodelbase.com/rep-mmb
%
% This is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

//**********************************************************************
// Further references:
// Ravenna, Federico and Walsh, Carl, E. (2006). Optimal monetary policy with the cost channel
// Journal of Monetary Economics 53, 199-216.
//
//The parameter values are calibrated as described in section 4; p.212-213.
//
// Last edited: 30/07/11 by M. Jancokova
//**********************************************************************


%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------
//Define endogenous variables
var x pi R;

//Define exogenous variables
varexo u;

//Define parameters
parameters
sigma eta beta omega kappa phipi phix;


%----------------------------------------------------------------
% 2. Calibration and Estimation
%----------------------------------------------------------------
sigma=1.5;
eta=1;
beta=0.99;
omega=0.75;
kappa=(1-omega)*(1-omega*beta)/omega;
phipi = 1.1;
phix = 1;


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear);

// Policy Rule
R = phipi*pi+phix*x;

//IS curve
x=x(+1)-(1/sigma)*(R-pi(+1))+u;

//Phillips curve
pi=beta*pi(+1)+kappa*(sigma+eta)*x+kappa*R;

end;


//Shocks
shocks;
var u =1;
//var interest_ =1;
end;


//Simulation
//***************************
//The following was commented out for use in Rep-MMB
//Nov. 2024
//stoch_simul (AR=100,IRF=0, noprint,nograph);
//*****************************
stoch_simul (AR=0, IRF=0, order=1, noprint, nograph, nocorr, nodecomposition, nofunctions, nomoments, nomodelsummary);
