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
## Prescaling

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: June 2011
## Version: 0.1

function [retsys, lscale, rscale] = __prescale__ (sys, optarg = 0.0)

  if (isempty (sys.e))
    [a, b, c, ~, scale] = sltb01id (sys.a, sys.b, sys.c, optarg);
    retsys = ss (a, b, c, sys.d);
    lscale = rscale = scale;
  else
    [a, e, b, c, lscale, rscale] = sltg01ad (sys.a, sys.e, sys.b, sys.c, optarg);
    retsys = dss (a, b, c, sys.d, e);
  endif
  
  retsys.scaled = true;
  retsys.lti = sys.lti;  # retain i/o names and tsam

endfunction
