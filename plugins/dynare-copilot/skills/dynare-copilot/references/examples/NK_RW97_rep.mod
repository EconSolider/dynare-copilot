% NK_RW97
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
// Rotemberg, J., and M. Woodford. 1997. "An Optimization-Based Econometric Framework for the Evaluation of Monetary Policy."
// NBER Macroeconomics Annual 12, pp. 297-346.
//
// Last edited: 10/08/26 by S. Schmidt
//
// See Woodford(2003) p.246 for the model equations.
//**********************************************************************


%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------
//Define endogenous variables
var pi y ynat rnat i x u g;

//Define exogenous variables
varexo u_ g_;

//Define parameters
parameters
 beta sigma alpha theta omega kappa rhou rhog stdinflation_ stdfiscal_ phipi phix;


%----------------------------------------------------------------
% 2. Calibration and Estimation
%----------------------------------------------------------------
beta = 1/(1+0.035/4);  // 0.9913
sigma= 6.25;
alpha= 0.66;
theta= 7.66;
omega= 0.47;
kappa= (((1-alpha)*(1-alpha*beta))/alpha)*(((1/sigma)+omega)/(1+omega*theta));
rhou=0;
stdinflation_=0.154;
rhog= 0.8;
stdfiscal_=1.524;
phipi = 1.1;
phix = 1;


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear);

// Original Model Code:

pi   =  beta * pi(+1)+ kappa*x+ u;
u=rhou*u(-1)+u_;
x  =  x(+1) - sigma *( i - pi(+1) - rnat) ;
rnat = sigma^(-1)*((g-ynat)- (g(+1)-ynat(+1)));
ynat = sigma^(-1)*g /(sigma^(-1)+omega);
x = y-ynat;
g = rhog*g(-1) + g_;
i=phipi*pi + phix*x;
end;

//Shocks
shocks;
var g_= 1.524^2;
var u_=0.154^2;
end;


//Simulation
//***************************
//The following was commented out for use in Rep-MMB
//Nov. 2024
//stoch_simul (AR=100,IRF=0, noprint,nograph);
//stoch_simul (irf = 0, ar=100, noprint);
//*****************************
stoch_simul (AR=0, IRF=0, order=1, noprint, nograph, nocorr, nodecomposition, nofunctions, nomoments, nomodelsummary);

