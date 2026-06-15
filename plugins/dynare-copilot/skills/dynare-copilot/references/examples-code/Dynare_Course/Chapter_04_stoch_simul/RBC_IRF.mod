/*
 * This file presents a baseline RBC model with TFP, calibrated to US data from
 *  1947Q4:2016Q1. The model setup resembles the one in King/Rebelo (1999): 
 *  Resuscitating Real Business Cycles, Handbook of Macroeconomics, Volume 1 and
 *  Romer (2012), Advanced macroeconomics, 4th edition
 *  The driving processes are estimated as AR(1)-processes on linearly detrended data.
 *
 * This implementation was written by Johannes Pfeifer. In case you spot mistakes,
 * email me at jpfeifer@gmx.de
 *
 * Please note that the following copyright notice only applies to this Dynare 
 * implementation of the model.
 */

/*
 * Copyright (C) 2016-25 Johannes Pfeifer
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
 * For a copy of the GNU General Public License,
 * see <http://www.gnu.org/licenses/>.
 */

//****************************************************************************
//Define variables
//****************************************************************************

var(log)
    y           ${y}$       (long_name='output')
    c           ${c}$       (long_name='consumption')
    k           ${k}$       (long_name='capital')
    l           ${l}$       (long_name='hours')
    w           ${w}$       (long_name='real wage')
    invest      ${i}$       (long_name='investment');
var
    z           ${z}$       (long_name='TFP')
    r           ${r}$       (long_name='annualized interest rate')
    ;

predetermined_variables k;

varexo eps_z ${\varepsilon_z}$ (long_name='TFP shock')
    ;
    
parameters 
    beta    ${\beta}$   (long_name='discount factor')
    psi     ${\psi}$    (long_name='labor disutility parameter')
    sigma   ${\sigma}$  (long_name='risk aversion')
    delta   ${\delta}$  (long_name='depreciation rate')
    alpha   ${\alpha}$  (long_name='capital share')
    rhoz    ${\rho_z}$  (long_name='persistence TFP shock')
    i_y     ${\frac{I}{Y}}$ (long_name='investment-output ratio')
    k_y     ${\frac{K}{Y}}$ (long_name='capital-output ratio')
    ;

//****************************************************************************
//Set parameter values
//****************************************************************************

sigma=1;                % risk aversion
alpha= 0.33;            % capital share
i_y=0.25;               % investment-output ration
k_y=10.4;               % capital-output ratio
rhoz=0.97;              % technology autocorrelation based on linearly detrended Solow residual

//****************************************************************************
//enter the model equations (model-block)
//****************************************************************************

model;
[name='Euler equation']
c^(-sigma)=beta*c(+1)^(-sigma)*
    (alpha*exp(z(+1))*(k(+1)/l(+1))^(alpha-1)+(1-delta));
[name='Labor FOC']
psi*c^sigma*1/(1-l)=w;
[name='Law of motion capital'] 
k(+1)=(1-delta)*k+invest;
[name='resource constraint']
y=invest+c;
[name='production function']
y=exp(z)*k^alpha*l^(1-alpha);
[name='real wage/firm FOC labor']
w=(1-alpha)*y/l;
[name='annualized real interest rate/firm FOC capital']
r=4*alpha*y/k;
[name='exogenous TFP process']
z=rhoz*z(-1)+eps_z;
end;

//****************************************************************************
// Provide steady state values and calibrate the model to steady state labor of 0.33, 
// i.e. compute the corresponding steady state values
// and the labor disutility parameter by hand;
//****************************************************************************

steady_state_model;
    %Do Calibration
    delta=i_y/k_y;
    beta=1/(alpha/k_y+(1-delta));
    l=0.33;
    k = ((1/beta-(1-delta))/alpha)^(1/(alpha-1))*l; 
    invest = delta*k;
    y=k^alpha*l^(1-alpha);
    c = k^(alpha)*l^(1-alpha)-invest;
    psi=(1-alpha)*(k/l)^alpha*(1-l)/c^sigma;
    w = (1-alpha)*y/l;
    r = 4*alpha*y/k;
    log_y = log(y);
    log_k = log(k);
    log_c = log(c);
    log_l = log(l);
    log_w = log(w);
    log_invest = log(invest);
    z = 0; 
end;

//****************************************************************************
//set shock variances
//****************************************************************************

shocks;
var eps_z = 0.0066^2;
end;

//****************************************************************************
//check the starting values for the steady state
//****************************************************************************

resid;

//****************************************************************************
// compute steady state given the starting values
//****************************************************************************

steady;
//****************************************************************************
// check Blanchard-Kahn-conditions
//****************************************************************************
model_info;

check;

//****************************************************************************
// compute policy function at first order, do IRFs and compute moments with HP-filter
//****************************************************************************
write_latex_dynamic_model;
write_latex_parameter_table;
write_latex_definitions ;
collect_latex_files ;

stoch_simul(TeX,order=1,irf=40,hp_filter=1600) LOG_y LOG_invest LOG_c LOG_l LOG_w r z;