% NK_BGEU10
% 
% Rep-MMB of the Macroeconomic Model Data Base (MMB)
% https://www.macromodelbase.com/rep-mmb
%
% This is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.

// Replication of Blanchard/Gali (2010), Optimal Monetary Policy (EU specification)

%----------------------------------------------------------------
% 1. Defining variables
%----------------------------------------------------------------

//Define endogenous variables
var pi uhat a eta inflation; 

//Define exogenous variables
varexo a_; 

//Define parameters
parameters gam alf the bet phi eps lam M gdel ra x u del g B chi bphi alfux gmu xi0 xi1 k0 kl kf rho; 

%----------------------------------------------------------------
% 2. Calibration and Estimation
%----------------------------------------------------------------

x  = 0.25;                                                          
u  = 0.1;                                                     
B = 5/42;

gam  = 0.5;         
alf  = 1;           
the  = 1;           
bet  = 0.99;        
phi  = 1;           
eps  = 6;           
lam = 1/12;        
M = eps/(eps-1);    
gdel = 0.01;       

ra = 0.9;

del = u*x/((1-u)*(1-x));
g = B*x^alf;

N      = 1-u;
chi    = ((1/M) -(1-bet*(1-del))*(1+the)*g-bet*(1-del)*the*g*x)/(N^(1+phi)*(1-del*g));
 
bphi = 1-(1-bet*(1-del))*g*M ;
alfux = (lam*(1+phi)*chi*(1-u)^(phi-1))/eps ;
gmu = g*M/(1-u);
xi0 = (1-(1+alf)*g)/(1-del*g) ;
xi1 = g*(1-del)*(1+alf*(1-x))/(1-del*g) ;
k0 = lam*( (alf*gmu/del)*(1+bet*(1-del)^2*(1-x))+  bet*(1-del)*gmu*(xi1-xi0));
kl = lam*((alf/del)*gmu*(1-del)*(1-x) + bet*(1-del)*gmu*xi1 );
kf = lam*bet*(1-del)*gmu*((alf/del)-xi0);
rho = -log(bet);

%----------------------------------------------------------------
% 3. Model
%----------------------------------------------------------------

model(linear); 
pi  =  bet * pi(+1) - k0*uhat + kl*uhat(-1) + kf*uhat(+1) - lam*bphi*gam * a; 
pi + eta - eta(-1);  
alfux*uhat + k0*eta - bet*kl*eta(+1)-1/bet*kf*eta(-1);    
a = ra* a(-1) - a_;  
inflation = pi*4;    
end; 

shocks; 
var a_; 
stderr 1; 
end; 

steady; 
check; 

//***************************
//The following was commented out for use in Rep-MMB
//Nov. 2024
//%stoch_simul (irf = 31, ar=100, nograph); 
//stoch_simul (AR=100,IRF=0, noprint,nograph);
//***************************

stoch_simul (AR=0, IRF=0, order=1, noprint, nograph, nocorr, nodecomposition, nofunctions, nomoments, nomodelsummary);
