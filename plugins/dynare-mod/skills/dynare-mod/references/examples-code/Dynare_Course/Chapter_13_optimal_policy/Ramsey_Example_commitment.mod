/*
 * This file replicates the model studied in:
 * Lawrence J. Christiano, Roberto Motto and Massimo Rostagno (2007):
 * "Notes on Ramsey-Optimal Monetary Policy", Section 2
 * The paper is available at http://faculty.wcas.northwestern.edu/~lchrist/d16/d1606/ramsey.pdf
 * 
 * Notes:
 * - This mod-files allows to simulate a simple New Keynesian Model with Rotemberg price 
 *      adjustment costs under three different monetary policy arrangements:
 *      1. a Taylor rule with a fixed inflation feedback coefficient alpha
 *          -> set the Optimal_policy switch to 0
 *      2. a Taylor rule where the inflation feedback coefficient alpha is chosen 
 *          optimally to minimize a quadratic loss function (optimal simple rule (OSR))
 *          -> set the Optimal_policy switch to 1 and the Ramsey switch to 0
 *      3. fully optimal monetary under commitment (Ramsey)
 *          -> set the Optimal_policy switch to 1 and the Ramsey switch to 1
 *
 *  - The Efficent_steady_state switch can be used to switch from an distorted steady state 
 *      due to a monopolistic distortion to one where a labor subsidy counteracts this 
 *      distortion. Note that the purely quadratic loss function in the OSR case does not capture
 *      the full welfare losses with a distorted steady state as there would be a linear term 
 *      appearing.
 *
 *  - This files shows how to use a conditional steady state file in the Ramsey case. It takes
 *      the value of the defined instrument r as given and then computes the rest of the steady 
 *      state, including the steady state inflation rate, based on this value. The initial value 
 *      of the instrument for steady state search must then be defined in an initval-block.
 *
 *  - The optim_weights in the OSR case are based on a second order approximation to the welfare function
 *      as in Gali (2015). The relative weight between inflation and output gap volatility is essentially 
 *      given by the slope of the New Keynesian Phillips Curve. Note that the linear terms that would be 
 *      present in case of a distorted steady state need to be dropped for OSR. 
 *
 *  - Due to divine coincidence, the first best policy involves fully stabilizing inflation  
 *      and thereby the output gap. As a consequence, the optimal inflation feedback coefficient 
 *      in a Taylor rule would be infinity. The OSR command therefore estimates it to be at the 
 *      upper bound defined via osr_params_bounds.
 *
 *  - The mod-file also allows to conduct estimation under Ramsey policy by setting the 
 *      Estimation_under_Ramsey switch to 1.
 *
 * This implementation was written by Johannes Pfeifer.
 *
 * If you spot mistakes, email me at jpfeifer@gmx.de
 *
 * Please note that the following copyright notice only applies to this Dynare 
 * implementation of the model.
 */
/*
 * Copyright © 2019 Dynare Team
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
 * see <https://www.gnu.org/licenses/>.
 */
//**********Define which monetary policy setup to use *********** 
//**********Define whether to use distorted steady state*********** 
var(log) C       $C$                 (long_name='Consumption')
    pi      $\pi$               (long_name='Gross inflation')
    h       $h$                 (long_name='hours worked')
;

var Z       $Z$                 (long_name='TFP')
    r       $r$                 (long_name='Net nominal interest rate')
    y_nat   ${y^{nat}}$         (long_name='Natural (flex price) output')
    y_gap   ${r^{gap}}$         (long_name='Output gap')
;

varexo epsilon ${\varepsilon}$     (long_name='TFP shock')
    ;
parameters beta     ${\beta}$       (long_name='discount factor')
        theta       ${\theta}$      (long_name='substitution elasticity')
        tau         ${\tau}$        (long_name='labor subsidy')
        chi         ${\chi}$        (long_name='labor disutility')
        phi         ${\phi}$        (long_name='price adjustment costs')
        rho         ${\rho}$        (long_name='TFP autocorrelation')
        ;

beta=0.99;
theta=5;
phi=100;
rho=0.9;
tau=1/(theta-1);
chi=1;
        
model;
    [name='Euler equation']
    1/(1+r)=beta*C/(C(+1)*pi(+1));
    [name='Firm FOC']
    (tau-1/(theta-1))*(1-theta)+theta*(chi*h*C/(exp(Z))-1)=phi*(pi-1)*pi-beta*phi*(pi(+1)-1)*pi(+1);
    [name='Resource constraint']
    C*(1+phi/2*(pi-1)^2)=exp(Z)*h;
    [name='TFP process']
    Z=rho*Z(-1)+epsilon;
    [name='Definition natural output']
    y_nat=exp(Z)*sqrt((theta-1)/theta*(1+tau)/chi);
    [name='output gap']
    y_gap=log(C)-log(y_nat);
end;

steady_state_model;
    Z=0;
    pi=(r+1)*beta;
    C=sqrt((1+1/theta*((1-beta)*(pi-1)*pi-(tau-1/(theta-1))*(1-theta)))/(chi*(1+phi/2*(pi-1)^2)));
    h=C*(1+phi/2*(pi-1)^2);
    y_nat=sqrt((theta-1)/theta*(1+tau)/chi);
    y_gap=log(C)-log(y_nat);
end;
//define initial value of instrument for Ramsey
initval;
    r=1/beta-1;
end;
shocks;
    var epsilon = 0.01^2;
end;
//use Ramsey optimal policy

//define planner objective, which corresponds to utility function of agents
planner_objective log(C)-chi/2*h^2;

//set up Ramsey optimal policy problem with interest rate r as the instrument,...
// defining the discount factor in the planner objective to be the one of private agents        
ramsey_model(instruments=(r),planner_discount=beta,planner_discount_latex_name=$\beta$); 

//conduct stochastic simulations of the Ramsey problem
stoch_simul(order=2,irf=20,periods=0,irf_plot_threshold=0) LOG_pi LOG_h r LOG_C Z;
evaluate_planner_objective;
        
