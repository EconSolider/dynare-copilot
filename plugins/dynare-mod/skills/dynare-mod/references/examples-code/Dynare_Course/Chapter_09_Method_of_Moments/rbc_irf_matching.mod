/*
 * This file presents a baseline RBC model with government spending shocks where the persistence of the 
 *  government spending shock is estimated via impulse response function (IRF) matching. 
 *
 * Notes:
 *  - The empirical IRFs were estimated using the Blanchard/Perotti (2002) approach, see
 *    https://github.com/JohannesPfeifer/DSGE_mod/blob/master/RBC_IRF_matching/get_empirical_IRFs.m
 *  - They are given in the csv file rbc_irf_matching_data.csv, the first two columns contain
 *    the empirical IRFs of G and Y, while the third and fourth column contain the corresponding
 *    variances of the IRFs from a bootstrap approach.
 *    Importantly: this mod file does not show how to get the empirical IRFs from a SVAR model,
 *    but takes these as "data".
 *  - Of course the RBC model is not capable of generating the consumption increase
 *    after a government spending shock. For that reason, this mod-file only targets the IRFs for G and Y.
 *  - The weighting matrix uses a diagonal matrix with the inverse of the pointwise IRF variances on the main diagonal.
 *  - The empirical IRFs and model IRFs use an impulse size of 1 percent. Thus, there is no uncertainty about the 
 *    initial impact. The IRF matching therefore only targets the G-response starting in the second period.
 *  - Note that for the current model, the number of IRFs exceeds the number of VAR parameters. Therefore,
 *    the distribution of the estimator will be non-standard, see Guerron-Quintana/Inoue/Kilian (2016), 
 *    http://dx.doi.org/10.1016/j.jeconom.2016.09.009
 *  - The mod-file also shows how to estimate an AR(2)-process by working with the roots of the autoregressive
 *    process instead of the coefficients. This allows for easily restricting the process to the stability region and 
 *    would allow specifying e.g. a beta prior for both roots as was done in Born/Peter/Pfeifer (2013), Fiscal news 
 *    and macroeconomic volatility, https://doi.org/10.1016/j.jedc.2013.06.011
 *
 * Please note that the following copyright notice only applies to this Dynare 
 * implementation of the model.
 */

/*
 * Copyright (C) 2016-17 Johannes Pfeifer,
 * Copyright (C) 2024 Dynare Team
 *
 * This file is part of Dynare.
 *
 * Dynare is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Dynare is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Dynare.  If not, see <https://www.gnu.org/licenses/>.
 */

%----------------------------------------------------------------
% define variables 
%----------------------------------------------------------------
@#define IRF_periods=80

var y           ${y}$ (long_name='output')
    c           ${c}$ (long_name='consumption')
    k           ${k}$ (long_name='capital')
    l           ${l}$ (long_name='hours')
    z           ${z}$ (long_name='TFP')
    ghat        ${\hat g}$ (long_name='government spending')
    r           ${r}$ (long_name='annualized interest rate')
    w           ${w}$ (long_name='real wage')
    invest      ${i}$ (long_name='investment') 
    log_y       ${\log(y)}$ (long_name='log output')
    log_k       ${\log(k)}$ (long_name='log capital stock')
    log_c       ${\log(c)}$ (long_name='log consumption')
    log_l       ${\log(l)}$ (long_name='log labor')
    log_w       ${\log(w)}$ (long_name='log real wage')
    log_invest  ${\log(i)}$ (long_name='log investment')
;

varexo eps_z ${\varepsilon_z}$ (long_name='TFP shock')
       eps_g ${\varepsilon_g}$ (long_name='government spending shock')
;

%----------------------------------------------------------------
% define parameters
%----------------------------------------------------------------

parameters 
    beta     ${\beta}$       (long_name='discount factor')
    psi      ${\psi}$        (long_name='labor disutility parameter')
    sigma    ${\sigma}$      (long_name='risk aversion')
    delta    ${\delta}$      (long_name='depreciation rate')
    alpha    ${\alpha}$      (long_name='capital share')
    rhoz     ${\rho_z}$      (long_name='persistence TFP shock')
    root_g_1 ${\rho_g}$      (long_name='first root of AR(2) G process')
    root_g_2 ${\rho_g}$      (long_name='second root of AR(2) G process')
    gammax   ${\gamma_x}$    (long_name='composite growth rate')
    gshare   ${\frac{G}{Y}}$ (long_name='government spending share')
    n        ${n}$           (long_name='population growth')
    x        ${x}$           (long_name='technology growth (per capita output growth)')
    i_y      ${\frac{I}{Y}}$ (long_name='investment-output ratio')
    k_y      ${\frac{K}{Y}}$ (long_name='capital-output ratio')
    g_ss     ${\bar G}$      (long_name='government spending in steady state')
    l_ss     ${\bar L}$      (long_name='labor in steady state')
;

%----------------------------------------------------------------
% model equations
%----------------------------------------------------------------
model;
# rho_g_1= (root_g_1+root_g_2);
# rho_g_2= - root_g_1*root_g_2;
[name='Euler equation']
c^(-sigma)=beta/gammax*c(+1)^(-sigma)*
    (alpha*exp(z(+1))*(k/l(+1))^(alpha-1)+(1-delta));
[name='Labor FOC']
psi*c^sigma*1/(1-l)=w;
[name='Law of motion capital'] 
gammax*k=(1-delta)*k(-1)+invest;
[name='resource constraint']
y=invest+c+g_ss*exp(ghat);
[name='production function']
y=exp(z)*k(-1)^alpha*l^(1-alpha);
[name='real wage/firm FOC labor']
w=(1-alpha)*y/l;
[name='annualized real interst rate/firm FOC capital']
r=4*alpha*y/k(-1);
[name='exogenous TFP process']
z=rhoz*z(-1)+eps_z;
[name='government spending process']
ghat=rho_g_1*ghat(-1)+rho_g_2*ghat(-2)+eps_g;
[name='Definition log output']
log_y = log(y);
[name='Definition log capital']
log_k = log(k);
[name='Definition log consumption']
log_c = log(c);
[name='Definition log hours']
log_l = log(l);
[name='Definition log wage']
log_w = log(w);
[name='Definition log investment']
log_invest = log(invest);
end;

%----------------------------------------------------------------
%  set steady state values
%---------------------------------------------------------------

steady_state_model;
    gammax = (1+n)*(1+x);
    delta = i_y/k_y-x-n-n*x;
    beta = (1+x)*(1+n)/(alpha/k_y+(1-delta));
    l = l_ss;
    k = ((1/beta*(1+n)*(1+x)-(1-delta))/alpha)^(1/(alpha-1))*l; 
    invest = (x+n+delta+n*x)*k;
    y = k^alpha*l^(1-alpha);
    g = gshare*y;
    g_ss = g;
    c = (1-gshare)*k^(alpha)*l^(1-alpha)-invest;
    psi = (1-alpha)*(k/l)^alpha*(1-l)/c^sigma;
    w = (1-alpha)*y/l;
    r = 4*alpha*y/k;
    log_y = log(y);
    log_k = log(k);
    log_c = log(c);
    log_l = log(l);
    log_w = log(w);
    log_invest = log(invest);
    z = 0; 
    ghat =0;
end;

%----------------------------------------------------------------
% calibration
%----------------------------------------------------------------
sigma    = 1;
alpha    = 0.33;
i_y      = 0.25;
k_y      = 10.4;
x        = 0.0055;
n        = 0.0027;
rhoz     = 0.97;
root_g_1 = 0.9602;
root_g_2 = 0;
gshare   = 0.2038;
l_ss     = 1/3;

shocks;
var eps_g = 1; 
end;
steady;
check;

varobs ghat log_y y; // you need to specify observables

%----------------------------------------------------------------
% IRF matching example 1:
% - different ways to MANUALLY enter values and weights
% - Maximum likelihood estimation
%----------------------------------------------------------------
estimated_params;
root_g_1 , 0.90 , 0, 1;
root_g_2 , 0.10 , 0, 1;
end;

xx = [1.007,1.117,1.092];
ww = [51,52];

matched_irfs; 
var log_y ;  varexo eps_g ;  periods 1, 2   ;  values 0.20, 0.17   ;  weights 360, 140 ;
var ghat  ;  varexo eps_g ;  periods 2 3:5  ;  values 1.01, (xx)   ;  weights 50, 20   ;
var y     ;  varexo eps_g ;  periods 10:11  ;  values (log(1.05))  ;  weights (ww)     ;
end;

method_of_moments(mom_method = irf_matching, mode_compute = 5, additional_optimizer_steps=[4]);


%----------------------------------------------------------------
% IRF matching example 2
% - use all IRFs given in MATLAB objects
% - use Bayesian Slice sampler
%----------------------------------------------------------------
estimated_params(overwrite);
root_g_1 , 0.50 , 0, 1, beta_pdf      , 0.50 , 0.20;
root_g_2 , 0.10 , 0, 1, beta_pdf      , 0.50 , 0.20;
end;

% get data
irfs_data = importdata('rbc_irf_matching_data.csv');
irfs_ghat_eps_g     = irfs_data.data(2:80,1); % start in t=2 due to identification restrictions in SVAR
irfs_log_y_eps_g    = irfs_data.data(1:80,2);
weights_ghat_eps_g  = 1./irfs_data.data(2:80,3);
weights_log_y_eps_g = 1./irfs_data.data(1:80,4);

matched_irfs(overwrite);
var ghat ; varexo eps_g; periods 2:80; values (irfs_ghat_eps_g);  weights (weights_ghat_eps_g);
var log_y; varexo eps_g; periods 1:80; values (irfs_log_y_eps_g);   weights (weights_log_y_eps_g);
end;

method_of_moments(mom_method = irf_matching
                 ,order = 1
                 ,mh_nblocks = 2, mh_replic = 50
                 ,posterior_sampling_method = 'slice'
                 ,plot_priors = 1
                 );

%----------------------------------------------------------------
% IRF matching example 3:
% - use anonymous function to access IRFs more flexibly
% - showcase how to use irf_matching_file
% - find posterior mode
%----------------------------------------------------------------

% get data
irfs_data = importdata('rbc_irf_matching_data.csv');

% use anonymous function (or MATLAB function) to have more flexibility, but inputs can only be numerical
% we also take 100 just for illustration that you can do any required transformation in an irf_matching_file
irfs_vals    = @(j) 100.*(irfs_data.data(2:80,j));
irfs_weights = @(j) 1./(irfs_data.data(2:80,j));

matched_irfs(overwrite);
var ghat ; varexo eps_g; periods 2:80; values (irfs_vals(1));  weights (irfs_weights(3));
var log_y; varexo eps_g; periods 2:80; values (irfs_vals(2));  weights (irfs_weights(4));
end;

% we use the irf_matching_file to transform variable y to log(y) so the model
% variable aligns with the variable from the given empirical SVAR
method_of_moments(mom_method = irf_matching
                 ,irf_matching_file = rbc_irf_matching_transformations
                 ,mh_replic = 0,plot_priors = 0
                 );