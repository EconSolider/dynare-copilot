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
function [N, info]= RBC_MoM_steady_helper(THETA,ETA_L,ETA_C,BETTA,B,C_O_N,W)
info=0;
if ~isreal(C_O_N)
    info=1;
    N=NaN;
    return;
end
if ETA_C == 1 && ETA_L == 1
    N = (1-BETTA*B)*(C_O_N*(1-B))^-1*W/THETA/(1+(1-BETTA*B)*(C_O_N*(1-B))^-1*W/THETA);
else
    % No closed-form solution use a fixed-point algorithm
    N0 = 1/3;
    try
        [N, ~, exitflag] = fsolve(@(N) THETA*(1-N)^(-ETA_L)*N^ETA_C - (1-BETTA*B)*(C_O_N*(1-B))^(-ETA_C)*W, N0,optimset('Display','off','TolX',1e-12,'TolFun',1e-12));        
        if exitflag<1
            info=1;
        end
    catch
        N=NaN;
        info=1;
    end
end