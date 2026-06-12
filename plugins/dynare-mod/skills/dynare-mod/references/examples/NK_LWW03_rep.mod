% NK_LWW03
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
// Levin, A., V. Wieland, and J. Williams. 2003. "The Performance of Forecast-Based Monetary Policy Rules under Model Uncertainty."
// American Economic Review 93(3), pp. 622-645.
//
// Last edited: 10/09/07 by S. Schmidt
//**********************************************************************


%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------
//Define endogenous variables
var ygap pdot rff rstar drff pdotsh;

//Define exogenous variables
varexo rstar_ pdotsh_;

//Define parameters
parameters
discountt sigma phi wtrl rhorstar rhopish;


%----------------------------------------------------------------
% 2. Calibration and Estimation
%----------------------------------------------------------------
discountt = 0.990;
sigma	 = 1/(0.157);
phi	 = 0.024;
wtrl	 = 0.975;
rhorstar = 0.35;
rhopish  = 0;


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear);

// Original Model Code:

ygap  =  ygap(+1) - 0.25*sigma *( rff - pdot(+1) -rstar);
pdot  =  discountt*pdot(+1) + 4*phi*ygap + pdotsh;
drff  =  rff - rff(-1);
rstar =  rhorstar*rstar(-1)+ rstar_;
pdotsh = rhopish*pdotsh(-1) + pdotsh_;
rff = 1.5*pdot;

end;

//Shocks
shocks;
var pdotsh_=(1-rhopish^2)*2.25^2;
//var interest_=0;   //interest rate shock is added
var rstar_=(1-rhorstar^2)*3.72^2;
end;


//Simulation
//***************************
//The following was commented out for use in Rep-MMB
//Nov. 2024
//stoch_simul (AR=100,IRF=0, noprint,nograph);
//stoch_simul (irf = 0, ar=100, noprint);
//*****************************
stoch_simul (AR=0, IRF=0, order=1, noprint, nograph, nocorr, nodecomposition, nofunctions, nomoments, nomodelsummary);

