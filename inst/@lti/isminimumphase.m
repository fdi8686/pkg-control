## Copyright (C) 2011   Lukas F. Reichlin
##
## This file is part of LTI Syncope.
##
## LTI Syncope is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## LTI Syncope is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{bool} =} isminimumphase (@var{sys})
## @deftypefnx {Function File} {@var{bool} =} isminimumphase (@var{sys}, @var{tol})
## Determine whether LTI system is minimum phase.
## If a square system @var{P} is minimum-phase, its inverse @var{P^-1} is stable.
## @end deftypefn

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: January 2011
## Version: 0.1

function bool = isminimumphase (sys, tol = 0)

  if (nargin > 2)
    print_usage ();
  endif

  z = zero (sys);
  ct = isct (sys);

  bool = __is_stable__ (z, ct, tol);

endfunction