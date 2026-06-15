% NK_CGG02
% 
% Rep-MMB of the Macroeconomic Model Data Base (MMB)
% https://www.macromodelbase.com/rep-mmb
%
% This is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

//**************************************************************************
// A New Comparative Approach to Macroeconomic Modeling and Policy Analysis
//
// Volker Wieland, Tobias Cwik, Gernot J. Mueller, Sebastian Schmidt and
// Maik Wolters
//
// Working Paper, 2009
//**************************************************************************

// Model: NK_CGG02

// Further references:
// Clarida, R., J. Gal�, and M. Gertler. 2002. "A simple framework for international monetary policy analysis."
// Journal of Monetary Economics 49, pp. 879-904.
// Gal�, J., and T. Monacelli. 2005. "Monetary Policy and Exchange Rate Volatility in a Small Open Economy."
// Review of Economic Studies 72, pp. 707-734.

// Last edited: 10/09/07 by S. Schmidt

// This file simulates the dynamic response of the model of Clarida et. al (2002)
// to specific shocks. Parameter values are taken from Gali and Monacelli (2005).

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

//Define endogenous variables
var ytilde ybar y infl r rr u a ytildestar ybarstar ystar infstar rstar rrstar ustar astar;



//Define exogenous variables
varexo inf_ a_ infstar_ ystar_ astar_ rstar_  interest_;%



//Define parameters
parameters

sigma0 beta lambda rhoa rhou sigma kappa0 delta1 kappa phi theta gamma1;

%----------------------------------------------------------------
% 2. Calibration and Estimation
%----------------------------------------------------------------

beta=0.99;
rhoa=0.9;
rhou=0;
sigma=7;//log utility case
phi=1;
theta=0.75;
gamma1=0.5;
kappa0=sigma*gamma1-gamma1;
kappa=sigma+phi-kappa0;
sigma0=sigma-kappa0;
delta1=((1-theta)*(1-beta*theta))/theta;
lambda=delta1*kappa;

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model(linear);


// Original Model Code:

// Original monetary policy rule (Gal� and Monacelli, 2005)
r = 1.5*infl + interest_; //domestic inflation-based Taylor rule (section 5)
rstar= 1.5*infstar + rstar_;
//home country
ytilde=ytilde(+1)-(1/sigma0)*(r-infl(+1)-rr);
infl=beta*infl(+1)+lambda*ytilde+u;
rr=sigma0*(ybar(+1)-ybar)+kappa0*(ystar(+1)-ystar);
ybar=(1/kappa)*((1+phi)*a-kappa0*ystar);
ytilde=y-ybar;
a=rhoa*a(-1)+a_;
u=rhou*u(-1)+inf_;

//foreign country
ytildestar=ytildestar(+1)-(1/sigma0)*(rstar-infstar(+1)-rrstar)+ystar_;
infstar=beta*infstar(+1)+lambda*ytildestar+ustar;
rrstar=sigma0*(ybarstar(+1)-ybarstar)+kappa0*(y(+1)-y);
ybarstar=(1/kappa)*((1+phi)*astar-kappa0*y);
ytildestar=ystar-ybarstar;
astar=rhoa*astar(-1)+astar_;
ustar=rhou*ustar(-1)+infstar_;

end;

shocks;
var inf_ = 0.1;
var interest_ = 0.1;
var a_ = 0.1;
var ystar_ = 0.1;
var infstar_ = 0.1;
var rstar_ = 0.1;
var astar_ = 0.1;
end;

//***************************
//The following was commented out for use in Rep-MMB
//Nov. 2024
//stoch_simul (irf = 0, ar=100, noprint);
//stoch_simul (AR=100,IRF=0, noprint,nograph);
//***************************

stoch_simul (AR=0, IRF=0, order=1, noprint, nograph, nocorr, nodecomposition, nofunctions, nomoments, nomodelsummary);
