/*
 * This file implements the estimation of a simple RBC-DSGE model. During estimation
 * the model is calibrated to has a steady state ratio of investment to output of 0.25, 
 * of capital to output of 10.4, and hours worked of 0.33. This achieved by adjusting
 * beta, delta, and psi conditional on the other parameters in the steady state file.
 *
 * This implementation was written by Johannes Pfeifer. 
 * 
*/
/*
 * Copyright (C) 2012-2025 Johannes Pfeifer
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * It is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * For a copy of the GNU General Public License, see <http://www.gnu.org/licenses/>.
 */
var y ${y}$ (long_name='output')
    c ${c}$ (long_name='consumption')
    k ${k}$ (long_name='capital')
    l ${l}$ (long_name='hours worked')
    z ${z}$ (long_name='TFP')
    ghat ${\hat g}$ (long_name='spending trend deviation ')
    r ${r}$ (long_name='interest rate')
    w  ${w}$ (long_name='real wage')
    invest ${i}$ (long_name='investment')
    c_obs ${\Delta y}$ (long_name='consumption growth')
    g_obs ${\Delta g}$ (long_name='G spending growth')
    y_obs ${\Delta y}$ (long_name='output growth') 
    log_y ${\log(y)}$ (long_name='log output') 
    ;

varexo eps_z ${\varepsilon_z}$ (long_name='TFP shock')
       eps_g ${\varepsilon_g}$ (long_name='government spending shock');

//define parameters

parameters beta ${\beta}$ (long_name='discount factor')
        psi ${\psi}$ (long_name='labor disutility parameter')
        sigma ${\sigma}$ (long_name='risk aversion')
        delta ${\delta}$ (long_name='deprecation rate')
        alpha ${\alpha}$ (long_name='capital share')
        rhoz ${\rho_z}$ (long_name='autocorrelation TFP')
        gammax ${\gamma_z}$ (long_name='growth rate')
        gshare ${\frac{\bar G}{\bar Y}}$ (long_name='government spending share')
        rhog ${\rho_g}$ (long_name='autocorrelation G shock')
        i_y ${\frac{\bar I}{\bar Y}}$ (long_name='investment-output ratio')
        k_y ${\frac{\bar K}{\bar Y}}$ (long_name='capital-output ratio')
        x ${x}$ (long_name='technology growth')
        n ${n}$ (long_name='population growth')
        g_ss ${\bar g}$ (long_name='steady state G')
        ;

// set parameter values
sigma=1;
alpha= 0.33; 
i_y=0.25;               
k_y=10.4;               
x=0.0055;               
n=0.0027;               
rhoz=0.97;              
rhog=0.98;
gshare=0.2038;          

//enter the model equations (model-block)
model;
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
[name='annualized real interest rate/firm FOC capital']
r=4*alpha*y/k(-1);
[name='exogenous TFP process']
z=rhoz*z(-1)+eps_z;
[name='government spending process']
ghat=rhog*ghat(-1)+eps_g;
//10-12. Observation equations
c_obs = log(c) - log(c(-1));
g_obs = ghat - ghat(-1);
y_obs = log(y) - log(y(-1));
log_y=log(y);
end;

//set steady state values 
steady_state_model;
    gammax=(1+n)*(1+x);
    delta=i_y/k_y-x-n-n*x;
// calibrate the model to steady state labor of 0.33, i.e. compute the corresponding steady state values
// and the labor disutility parameter by hand
    beta=gammax/(alpha/k_y+(1-delta));
    l=0.33;
    k=((1/beta*gammax-(1-delta))/alpha)^(1/(alpha-1))*l;
    invest=(x+n+delta+n*x)*k;
    y=k^alpha*l^(1-alpha);
    g=gshare*y;
    g_ss=g;
    c=y-invest-g;
    psi=(1-alpha)*(k/l)^alpha*(1-l)/c^sigma;
    w=(1-alpha)*y/l;
    r=4*alpha*y/k;
    z=0;
    ghat=0;
    c_obs=0;
    g_obs=0;
    y_obs=0;
    log_y=log(y);
end;

//set shock variances
shocks;
    var eps_z=0.0068^2;
    var eps_g=0.0105^2;
end;

// compute steady state given the starting values
steady;
// check Blanchard-Kahn-conditions
check;

varobs g_obs c_obs;
calib_smoother(datafile=first_diff,filter_step_ahead=[1,4]) g_obs y_obs;
shock_decomposition y;
