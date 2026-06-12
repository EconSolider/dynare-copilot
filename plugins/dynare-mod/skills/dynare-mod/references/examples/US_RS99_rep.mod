% US_RS99
% 
% Rep-MMB of the Macroeconomic Model Data Base (MMB)
% https://www.macromodelbase.com/rep-mmb
%
% This is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.


//**************************************************************************
// Further references:
// Rudebusch, G., and L. Svensson. 1999. "Policy Rules for Inflation Targeting."
// in: John B. Taylor (ed.), Monetary Policy Rules. Chicago: University of Chicago Press for NBER.

// Last edited: 2010/09/07
//**************************************************************************


%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------
//Define endogenous variables
var pi y i pibar ibar;

//Define exogenous variables
varexo eps eta;

//Define parameters
parameters
alphapi1 alphapi2 alphapi3 alphapi4 alphay betay1 betay2 betar;

%----------------------------------------------------------------
% 2. Calibration and Estimation
%----------------------------------------------------------------
//Parameter values
alphapi1 = .7;
alphapi2 = -.1;
alphapi3 = .28;
alphapi4 = .12;
alphay = .14;
betay1 = 1.16;
betay2 = -.25;
betar = .10;


%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------
model(linear);

// Original Model Code:

// example for original interest rate rule (Fifth policy rule in Table 5.4)
i = 2.34*pibar + 1.03*y +0.30*i(-1);

pi = alphapi1*pi(-1) + alphapi2*pi(-2) + alphapi3*pi(-3) + alphapi4*pi(-4) + alphay*y(-1) + eps;
y = betay1*y(-1) + betay2*y(-2) - betar*(ibar(-1)-pibar(-1)) + eta;
pibar=(1/4)*(pi + pi(-1) + pi(-2) + pi(-3));
ibar=(1/4)*(i + i(-1) + i(-2) + i(-3));

end;


//Shocks
shocks;
var eps = 1.009^2;
var eta = 0.819^2;
end;

//Simulation
//***************************
//The following was commented out for use in Rep-MMB
//Nov. 2024
//stoch_simul (AR=100,IRF=0, noprint,nograph);
//stoch_simul (irf = 60);
//*****************************
stoch_simul (AR=0, IRF=0, order=1, noprint, nograph, nocorr, nodecomposition, nofunctions, nomoments, nomodelsummary);


