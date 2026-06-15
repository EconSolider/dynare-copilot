% run_swff.m  -- driver for the Del Negro-Giannoni-Schorfheide (2015) SWFF replication
% Computes deep + derived parameters (incl. BGG financial-friction zeta coefficients),
% places them in base-workspace struct `pp`, then calls Dynare on swff.mod.
%
% Parameter values: SWFF posterior mode, Table A-2 of FRBNY Staff Report 618 (= AEJ:Macro 2015).
clear; clc;
thisdir = fileparts(mfilename('fullpath'));
cd(thisdir);

%% ---------- deep parameters (Table A-2, column SWFF) ----------
alppha   = 0.178678;          % capital share
zeta_p   = 0.868025;          % Calvo prices
iota_p   = 0.225859;          % price indexation
Phi      = 1.526156;          % gross fixed-cost markup (1+fixed cost share)
S2       = 3.043719;          % S'' investment adjustment cost
h        = 0.243997;          % habit
ppsi     = 0.188363;          % capacity utilization cost curvature (psi)
nu_l     = 2.673158;          % inverse Frisch (labor disutility curvature)
zeta_w   = 0.887520;          % Calvo wages
iota_w   = 0.418745;          % wage indexation
r_star   = 0.133131;          % 100*(1/beta-1)  -> beta below
psi1     = 1.373653;          % Taylor: inflation
psi2     = 0.018043;          % Taylor: output gap (level)
psi3     = 0.239788;          % Taylor: output gap (growth)
pi_star_pct = 0.766193;       % steady-state quarterly net inflation (percent)
sigc     = 1.315895;          % relative risk aversion / IES inverse
rho      = 0.674959;          % Taylor smoothing (rho_R)
gam_pct  = 0.401155;          % steady-state quarterly net growth (percent)
SPstar   = 1.908145;          % steady-state spread (annualized percent)
zeta_spb = 0.044292;          % elasticity of spread wrt leverage

% AR coefficients
rho_g    = 0.979327;  rho_b = 0.944049;  rho_mu = 0.643521;  rho_z = 0.956351;
rho_lamf = 0.793946;  rho_lamw = 0.660922;  rho_rm = 0.067278;
rho_sigw = 0.989876;  rho_pistar = 0.990000;
% MA / spillover
eta_gz   = 0.873709;  eta_lamf = 0.714342;  eta_lamw = 0.571991;

% innovation standard deviations (posterior mode)
sig_g=2.907965; sig_b=0.038367; sig_mu=0.503285; sig_z=0.496084;
sig_lamf=0.153534; sig_lamw=0.256772; sig_rm=0.291914; sig_sigw=0.057474; sig_pistar=0.029999;

% fixed parameters
delta=0.025; gstar=0.18; lam_w=1.50; eps_p=10; eps_w=10; Upsilon=1.0;
Fstar=0.03; gammastar=0.99;

%% ---------- derived: implied scalars ----------
betta   = 1/(1+r_star/100);
gam     = gam_pct/100;                       % net growth (decimal)
Pistar  = 1 + pi_star_pct/100;               % gross steady-state inflation
spr     = (1 + SPstar/100)^(1/4);            % gross quarterly spread (DSGE.jl convention)

zstar   = log(1+gam) + alppha/(1-alppha)*log(Upsilon);   % z_star
he      = h*exp(-zstar);
bb      = betta*exp((1-sigc)*zstar);          % beta-bar
rstar   = exp(sigc*zstar)/betta;              % gross steady-state real rate
r_k_star= spr*rstar*Upsilon - (1-delta);      % rental rate of capital
wstar   = (alppha^alppha*(1-alppha)^(1-alppha)*r_k_star^(-alppha)/Phi)^(1/(1-alppha));
Lstar   = 1;
kstar   = (alppha/(1-alppha))*wstar*Lstar/r_k_star;
kbarstar= kstar*(1+gam)*Upsilon^(1/(1-alppha));
istar   = kbarstar*(1-(1-delta)/((1+gam)*Upsilon^(1/(1-alppha))));
ystar   = kstar^alppha*Lstar^(1-alppha)/Phi;
cstar   = (1-gstar)*ystar - istar;
wl_c    = wstar*Lstar/(cstar*lam_w);
bcoef   = sigc*(1+he)/(1-he);

%% ---------- derived: financial-friction zeta coefficients ----------
pf.alppha=alppha; pf.betta=betta; pf.sigc=sigc; pf.gam=gam; pf.delta=delta;
pf.Upsilon=Upsilon; pf.Pistar=Pistar; pf.spr=spr; pf.zeta_spb=zeta_spb;
pf.Fstar=Fstar; pf.gammastar=gammastar;
ff = swff_ff_coeffs(pf);
fprintf('FF steady-state self-check: defprob=%.4f (target %.2f) | nk*=%.4f leverage=%.3f | r_k*=%.4f\n',...
        ff.Fstar, Fstar, ff.nk_star, ff.leverage, r_k_star);

%% ---------- composite coefficients used in the model block ----------
e_r      = (1-he)/(sigc*(1+he));
e_c1     = he/(1+he);
e_cf     = 1/(1+he);
e_l      = (sigc-1)*wl_c/(sigc*(1+he));
inv_lag  = 1/(1+bb);
inv_f    = bb/(1+bb);
inv_q    = 1/(S2*exp(2*zstar)*(1+bb));
cv_rk    = r_k_star/(1+r_k_star-delta);
cv_qk    = (1-delta)/(1+r_k_star-delta);
ce_i     = istar/kbarstar;
ce_mu    = istar*S2*exp(2*zstar)*(1+bb)/kbarstar;
kappa    = (1-zeta_p*bb)*(1-zeta_p)/(zeta_p*((Phi-1)*eps_p+1))/(1+iota_p*bb);
ph_lag   = iota_p/(1+iota_p*bb);
ph_f     = bb/(1+iota_p*bb);
wg_mu    = (1-zeta_w*bb)*(1-zeta_w)/(zeta_w*((lam_w-1)*eps_w+1))/(1+bb);
wg_pi    = (1+iota_w*bb)/(1+bb);
wg_wlag  = 1/(1+bb);
wg_pilag = iota_w/(1+bb);
wg_f     = bb/(1+bb);
ms_c     = 1/(1-he);
ms_clag  = he/(1-he);
cs       = (1-ppsi)/ppsi;
res_c    = cstar/ystar;
res_i    = istar/ystar;
res_u    = r_k_star*kstar/ystar;

%% ---------- pull FF zeta coefficients into scalars ----------
zeta_spsigw = ff.zeta_spsigw;
zeta_nRk    = ff.zeta_nRk;
zeta_nR     = ff.zeta_nR;
zeta_nqk    = ff.zeta_nqk;
zeta_nn     = ff.zeta_nn;
zeta_nsigw  = ff.zeta_nsigw;
gstar_v_n   = ff.gstar_v_n;

%% ---------- write numeric parameter include file for the .mod ----------
names = {'alppha','Phi','nu_l','rho','psi1','psi2','psi3', ...
  'rho_g','rho_b','rho_mu','rho_z','rho_lamf','rho_lamw','rho_rm','rho_sigw','rho_pistar', ...
  'eta_gz','eta_lamf','eta_lamw','zeta_spb', ...
  'e_r','e_c1','e_cf','e_l','inv_lag','inv_f','inv_q','cv_rk','cv_qk', ...
  'ce_i','ce_mu','kappa','ph_lag','ph_f','wg_mu','wg_pi','wg_wlag','wg_pilag','wg_f', ...
  'ms_c','ms_clag','cs','res_c','res_i','res_u','gstar','bcoef', ...
  'zeta_spsigw','zeta_nRk','zeta_nR','zeta_nqk','zeta_nn','zeta_nsigw','gstar_v_n', ...
  'sig_g','sig_b','sig_mu','sig_z','sig_lamf','sig_lamw','sig_rm','sig_sigw','sig_pistar'};
fid = fopen('swff_params.inc','w');
fprintf(fid,'// auto-generated by run_swff.m -- do not edit\n');
for kk=1:numel(names)
    fprintf(fid,'%s = %.15g;\n', names{kk}, eval(names{kk}));
end
fclose(fid);

%% ---------- run Dynare ----------
dynare swff.mod noclearall nointeractive

%% ---------- publication-grade IRFs (financial + monetary focus) ----------
% NOTE: model variables and shock s.d.'s are in PERCENTAGE POINTS (DGS 100x
% measurement convention), so IRFs are read directly in percent -> Scale = 1.
vars   = {'y','c','invest','pinf','R','spread','n','qk'};
titles = {'Output','Consumption','Investment','Inflation','Policy rate R', ...
          'Spread (EFP)','Net worth','Price of capital q'};
plot_irfs_pub(vars, 'eps_sigw', 'Titles', titles, 'Horizon', 20, 'Scale', 1, ...
    'YLabel','Percent dev. from SS', 'Save','fig_irf_financial', 'Formats', {'pdf','png'});
plot_irfs_pub(vars, 'eps_rm', 'Titles', titles, 'Horizon', 20, 'Scale', 1, ...
    'YLabel','Percent dev. from SS', 'Save','fig_irf_monetary', 'Formats', {'pdf','png'});
