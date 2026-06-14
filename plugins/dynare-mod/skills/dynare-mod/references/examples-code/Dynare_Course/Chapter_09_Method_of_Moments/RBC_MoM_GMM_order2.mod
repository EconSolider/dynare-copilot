% Copyright (C) 2020-2025 Dynare Team
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

@#include "RBC_MoM_common.inc"

method_of_moments(
    % Necessery options
          mom_method = GMM                   % method of moments method; possible values: GMM|SMM
        , datafile   = 'RBC_Data_2.mat'      % name of filename with data
        , order = 2                           % order of Taylor approximation in perturbation
        , weighting_matrix = ['DIAGONAL','OPTIMAL'] % weighting matrix in moments distance objective function; possible values: OPTIMAL|IDENTITY_MATRIX|DIAGONAL|filename. Size of cell determines stages in iterated estimation, e.g. two state with ['DIAGONAL','OPTIMAL']
        , se_tolx=1e-6                        % step size for numerical computation of standard errors
        , TeX                                 % print TeX tables and graphics
        , mode_compute = 4                    % specifies the optimizer for minimization of moments distance
        , additional_optimizer_steps = [13]   % vector of additional mode-finders run after mode_compute
        , mode_check                               % plot the target function for values around the computed minimum for each estimated parameter in turn
    );