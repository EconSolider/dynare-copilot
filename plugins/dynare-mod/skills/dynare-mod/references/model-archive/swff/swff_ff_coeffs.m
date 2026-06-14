function ff = swff_ff_coeffs(p)
% swff_ff_coeffs  Compute BGG/CMR financial-friction steady-state coefficients
% for the Del Negro-Giannoni-Schorfheide (2015) SWFF model.
%
% Faithful MATLAB translation of FRBNY DSGE.jl m990:
%   src/models/financial_frictions.jl  (BGG functions)
%   src/models/representative/m990/m990.jl  steadystate!  (zeta coefficients)
%
% INPUT struct p with fields:
%   alppha, betta, sigc, gam (net growth, decimal), delta, Upsilon,
%   Pistar (gross steady-state inflation), spr (gross quarterly spread),
%   zeta_spb, Fstar (default prob), gammastar (entrepreneur survival rate)
% OUTPUT struct ff with the SS ratios and the FF elasticities used in the model.

    % ---- normal cdf/pdf ----
    nc = @(x) 0.5*erfc(-x/sqrt(2));        % normcdf without Stats toolbox
    np = @(x) exp(-0.5*x.^2)/sqrt(2*pi);   % normpdf

    % ---- BGG functions of (z, s) and (z, s, spr) ----
    omega      = @(z,s) exp(s.*z - s.^2/2);
    G          = @(z,s) nc(z - s);
    Gam        = @(z,s) omega(z,s).*(1-nc(z)) + nc(z-s);
    dG_dom     = @(z,s) np(z)./s;
    d2G_dom2   = @(z,s) -z.*np(z)./omega(z,s)./s.^2;
    dGam_dom   = @(z,s) 1 - nc(z);
    d2Gam_dom2 = @(z,s) -np(z)./omega(z,s)./s;
    dG_ds      = @(z,s) -z.*np(z-s)./s;
    d2G_domds  = @(z,s) -np(z).*(1 - z.*(z-s))./s.^2;
    dGam_ds    = @(z,s) -np(z-s);
    d2Gam_domds= @(z,s) (z./s - 1).*np(z);

    mu_fn = @(z,s,spr) (1 - 1./spr)./( dG_dom(z,s)./dGam_dom(z,s).*(1-Gam(z,s)) + G(z,s) );
    nk_fn = @(z,s,spr) 1 - (Gam(z,s) - mu_fn(z,s,spr).*G(z,s)).*spr;

    zeta_zw_fn = @(z,s,spr) omega(z,s).*(dGam_dom(z,s) - mu_fn(z,s,spr).*dG_dom(z,s)) ./ ...
                            (Gam(z,s) - mu_fn(z,s,spr).*G(z,s));
    function v = zeta_bw_fn(z,s,spr)
        nk  = nk_fn(z,s,spr);  mu = mu_fn(z,s,spr);  om = omega(z,s);
        Gm  = Gam(z,s);  Gs = G(z,s);
        dGm = dGam_dom(z,s);  dGs = dG_dom(z,s);
        d2Gm= d2Gam_dom2(z,s); d2Gs= d2G_dom2(z,s);
        v = om.*mu.*nk.*(d2Gm.*dGs - d2Gs.*dGm) ./ (dGm - mu.*dGs).^2 ./ spr ./ ...
            (1 - Gm + dGm.*(Gm - mu.*Gs)./(dGm - mu.*dGs));
    end
    function v = zeta_spb_fn(z,s,spr)
        zr = zeta_bw_fn(z,s,spr)./zeta_zw_fn(z,s,spr);
        nk = nk_fn(z,s,spr);
        v  = -zr./(1-zr).*nk./(1-nk);
    end

    % ---- solve for sigma_omega_star so that zeta_spb matches target ----
    z_om = norminv_local(p.Fstar, nc);                 % z_omega = Phi^{-1}(Fstar)
    g    = @(s) zeta_spb_fn(z_om, s, p.spr) - p.zeta_spb;
    sigw = fzero(g, 0.5);

    % ---- evaluate BGG objects at (z_om, sigw, spr) ----
    om      = omega(z_om, sigw);
    Gs      = G(z_om, sigw);          Gm      = Gam(z_om, sigw);
    dGs     = dG_dom(z_om, sigw);     dGm     = dGam_dom(z_om, sigw);
    dGds_   = dG_ds(z_om, sigw);      dGmds_  = dGam_ds(z_om, sigw);
    d2Gdomds= d2G_domds(z_om, sigw);  d2Gmdomds= d2Gam_domds(z_om, sigw);
    mu      = mu_fn(z_om, sigw, p.spr);
    nk      = nk_fn(z_om, sigw, p.spr);
    Rho     = 1/nk - 1;

    % ---- SW steady state needed for FF coefficients ----
    zg      = log(1+p.gam) + p.alppha/(1-p.alppha)*log(p.Upsilon);  % = z_star
    rstar   = exp(p.sigc*zg)/p.betta;
    betabar_inv = exp((p.sigc-1)*zg)/p.betta;                       % = 1/bb
    Rkstar  = p.spr*p.Pistar*rstar;

    GamG      = Gm - mu*Gs;
    GamGprime = dGm - mu*dGs;

    zeta_bw  = zeta_bw_fn(z_om, sigw, p.spr);
    zeta_zw  = zeta_zw_fn(z_om, sigw, p.spr);
    zeta_bw_zw = zeta_bw/zeta_zw;

    % elasticities wrt sigma_omega
    zeta_bsigw = sigw * ( ((1 - mu*dGds_/dGmds_)/(1 - mu*dGs/dGm) - 1)*dGmds_*p.spr ...
                 + mu*nk*(dGs*d2Gmdomds - dGm*d2Gdomds)/GamGprime^2 ) ...
                 / ( (1-Gm)*p.spr + dGm/GamGprime*(1-nk) );
    zeta_zsigw = sigw*(dGmds_ - mu*dGds_)/GamG;
    zeta_spsigw = (zeta_bw_zw*zeta_zsigw - zeta_bsigw)/(1 - zeta_bw_zw);

    % net-worth-evolution coefficients (else branch / default subspec)
    wek = (1 - p.gammastar*betabar_inv)*nk - p.gammastar*betabar_inv*(p.spr*(1-mu*Gs) - 1);
    vk  = (nk - wek)/p.gammastar;
    gstar_v_n = p.gammastar*vk/nk;                  % = gammastar*vstar/nstar

    zeta_gw   = dGs/Gs*om;
    zeta_Gsigw= dGds_/Gs*sigw;

    zeta_nRk = p.gammastar*Rkstar/p.Pistar/exp(zg)*(1+Rho)*(1 - mu*Gs*(1 - zeta_gw/zeta_zw));
    zeta_nR  = p.gammastar*betabar_inv*(1+Rho)*(1 - nk + mu*Gs*p.spr*zeta_gw/zeta_zw);
    zeta_nqk = p.gammastar*Rkstar/p.Pistar/exp(zg)*(1+Rho)*(1 - mu*Gs*(1+zeta_gw/zeta_zw/Rho)) ...
               - p.gammastar*betabar_inv*(1+Rho);
    zeta_nn  = p.gammastar*betabar_inv ...
               + p.gammastar*Rkstar/p.Pistar/exp(zg)*(1+Rho)*mu*Gs*zeta_gw/zeta_zw/Rho;
    zeta_nsigw = p.gammastar*Rkstar/p.Pistar/exp(zg)*(1+Rho)*mu*Gs*(zeta_Gsigw - zeta_gw/zeta_zw*zeta_zsigw);

    % ---- pack output ----
    ff = struct();
    ff.sigw_star   = sigw;
    ff.omegabar    = om;
    ff.nk_star     = nk;          % net worth / capital  (= 1/leverage)
    ff.leverage    = 1/nk;
    ff.Fstar       = Gs*0 + nc(z_om);   % realized default prob (should equal Fstar)
    ff.spr         = p.spr;
    ff.zeta_spb    = p.zeta_spb;
    ff.zeta_spsigw = zeta_spsigw;
    ff.zeta_nRk    = zeta_nRk;
    ff.zeta_nR     = zeta_nR;
    ff.zeta_nqk    = zeta_nqk;
    ff.zeta_nn     = zeta_nn;
    ff.zeta_nsigw  = zeta_nsigw;
    ff.gstar_v_n   = gstar_v_n;
end

function z = norminv_local(pp, nc)
% inverse standard normal via bisection (no Stats toolbox dependency)
    lo = -10; hi = 10;
    for k = 1:200
        mid = 0.5*(lo+hi);
        if nc(mid) < pp, lo = mid; else, hi = mid; end
    end
    z = 0.5*(lo+hi);
end
