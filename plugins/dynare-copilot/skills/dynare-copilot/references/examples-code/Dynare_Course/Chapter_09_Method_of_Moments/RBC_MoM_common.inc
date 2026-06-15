% RBC model used in replication files of 
% Andreasen, Fernández-Villaverde, Rubio-Ramírez (2018): "The Pruned State-Space System for Non-Linear DSGE Models: Theory and Empirical Applications", Review of Economic Studies, 85(1):1-49.
% Adapted by Willi Mutschler (@wmutschl, willi@mutschler.eu)
% =========================================================================
% Copyright (C) 2020-2021 Dynare Team
%
% This file is part of Dynare.
%
% Dynare is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% Dynare is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with Dynare.  If not, see <https://www.gnu.org/licenses/>.
% =========================================================================

var 
    ln_k      ${\log K}$         (long_name='capital')
    ln_c      ${\log C}$         (long_name='consumption')
    ln_a      ${\log A}$         (long_name='technology')
    ln_iv     ${\log I}$         (long_name='investment')
    ln_y      ${\log Y}$         (long_name='output')
    ln_lam    ${\log \lambda}$   (long_name='marginal utility')
    ln_n      ${\log N}$         (long_name='labor')
    ln_rk     ${\log r^k}$       (long_name='capital interest rate')
    ln_w      ${\log W}$         (long_name='wage')
;
    
varexo
    u_a    ${\varepsilon^{a}}$  (long_name='TFP shock')
;
    
parameters
    DELTA  $\delta$      (long_name='depreciation rate')
    BETTA  $\beta$       (long_name='discount factor')
    B      $B$           (long_name='internal consumption habit parameter')
    ETA_L  $\eta_l$      (long_name='CES utility elasticity wrt labor')
    ETA_C  $\eta_c$      (long_name='CES utility elasticity wrt consumption')
    THETA  $\theta$      (long_name='labor utility weight')
    ALFA   $\alpha$      (long_name='capital elasticity production function')
    RHOA   $\rho_a$      (long_name='persistence technology process')
;       

DELTA           = 0.025;
BETTA           = 0.984;
B               = 0.5;
ETA_L           = 1; 
ETA_C           = 2; 
THETA           = 3.48;
ALFA            = 0.667;
RHOA            = 0.979;

model;
exp(ln_lam) = (exp(ln_c)-B*exp(ln_c(-1)))^(-ETA_C) - BETTA*B*(exp(ln_c(+1))-B*exp(ln_c))^(-ETA_C);
THETA*(1-exp(ln_n))^(-ETA_L) = exp(ln_lam)*exp(ln_w);
exp(ln_lam) = BETTA*exp(ln_lam(+1))*(exp(ln_rk(+1)) + (1-DELTA));
exp(ln_rk) = exp(ln_a)*(1-ALFA)*exp(ln_k(-1))^(-ALFA)*exp(ln_n)^(ALFA);
exp(ln_w) = exp(ln_a)*ALFA*exp(ln_k(-1))^(1-ALFA)*exp(ln_n)^(ALFA-1);
exp(ln_y) = exp(ln_c) + exp(ln_iv);
exp(ln_y) = exp(ln_a)*exp(ln_k(-1))^(1-ALFA)*exp(ln_n)^(ALFA);
exp(ln_k) = (1-DELTA)*exp(ln_k(-1)) + exp(ln_iv);
log(exp(ln_a)) = RHOA*log(exp(ln_a(-1))) + u_a;
end;

steady_state_model;
A = 1;
RK = 1/BETTA - (1-DELTA);
K_O_N = (RK/(A*(1-ALFA)))^(-1/ALFA);
W = A*ALFA*(K_O_N)^(1-ALFA);
IV_O_N = DELTA*K_O_N;
Y_O_N = A*K_O_N^(1-ALFA);
C_O_N = Y_O_N - IV_O_N;

[N, info]=RBC_MoM_steady_helper(THETA,ETA_L,ETA_C,BETTA,B,C_O_N,W);
C=C_O_N*N;
Y=Y_O_N*N;
IV=IV_O_N*N;
K=K_O_N*N;
LAM = (C-B*C)^(-ETA_C)-BETTA*B*(C-B*C)^(-ETA_C);

ln_k=log(K);
ln_c=log(C);
ln_a=log(A);
ln_iv=log(IV);
ln_y=log(Y);
ln_lam=log(LAM);
ln_n=log(N);
ln_rk=log(RK);
ln_w=log(W);

end;

estimated_params;
    DELTA,         0.025;
    BETTA,         0.984;
    B,             0.5;
    ETA_C,         2;
    ALFA,          0.667;
    RHOA,          0.979;
    stderr u_a,    0.0072;
end;

estimated_params_init(use_calibration);
end;

varobs ln_c ln_iv ln_n;

matched_moments;
ln_c;
ln_n;
ln_iv;
ln_c*ln_c;
ln_c*ln_iv;
ln_iv*ln_n;
ln_iv*ln_iv;
ln_n*ln_c;
ln_n*ln_n;
ln_c*ln_c(-1);
ln_n*ln_n(-1);
ln_iv*ln_iv(-1);

ln_c*ln_c(-3);
ln_n*ln_n(-3);
ln_iv*ln_iv(-3);

ln_c*ln_c(-5);
ln_n*ln_n(-5);
ln_iv*ln_iv(-5);
end;

steady;