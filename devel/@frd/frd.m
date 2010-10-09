## Copyright (C) 2010   Lukas F. Reichlin
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
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program. If not, see <http://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {Function File} {@var{sys} =} frd (@var{sys}, @var{w})
## @deftypefnx {Function File} {@var{sys} =} frd (@var{H}, @var{w})
## @deftypefnx {Function File} {@var{sys} =} frd (@var{H}, @var{w}, @var{tsam})
## Create or convert to frequency response data.
## @end deftypefn

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: February 2010
## Version: 0.1

function sys = frd (H = [], w = [], varargin)

  ## model precedence: frd > ss > zpk > tf > double
  superiorto ("ss", "zpk", "tf", "double");

  argc = 0;

  switch (nargin)
    case 0
      tsam = -1;

    case 1
      if (isa (H, "frd"))             # already in frd form
        sys = H;
        return;
      elseif (isa (H, "lti"))         # another lti object  sys = frd (sys)
        [sys, alti] = __sys2frd__ (H);
        sys.lti = alti;               # preserve lti properties
        return;
      else
        print_usage ();
      endif

    case 2
      if (isa (H, "lti"))             # another lti object  sys = frd (sys, w)
        [sys, alti] = __sys2frd__ (H, w);
        sys.lti = alti;               # preserve lti properties
        return;
      else                            # sys = frd (H, w)
        tsam = 0;
      endif

    otherwise                         # default case
      argc = numel (varargin);

      if (issample (varargin{1}, 1))  # sys = frd (H, w, tsam, "prop1, "val1", ...)
        tsam = varargin{1};
        argc--;
        if (argc > 0)
          varargin = varargin(2:end);
        endif
      else                            # sys = frd (H, w, "prop1, "val1", ...)
        tsam = 0;
      endif

  endswitch

  ## TODO: create separate function
  if (ndims (H) != 3 && ! isempty (H))
    if (is_real_scalar (H))           # static gain (H is a scalar)
      H = reshape (H, 1, 1, []);
      tsam = -1;
    elseif (isvector (H))             # SISO system (H is a vector)
      H = reshape (H, 1, 1, []);
    else                              # static gain (H is a matrix)
      if (! is_real_matrix (H))
        error ("frd: static gain matrix must be real");
      endif
      H = reshape (H, rows (H), []);
      lw = length (w);
      if (lw > 1)
        H = repmat (H, [1, 1, lw]);   # needed for "frd1 + matrix2" or "matrix1 * frd2) 
      endif
      tsam = -1;
    endif
  elseif (isempty (H))
    H = zeros (0, 0, 0);
    tsam = -1;
  endif

  w = reshape (w, [], 1);

  [p, m] = __frd_dim__ (H, w);

  frdata = struct ("H", H, "w", w);

  ltisys = lti (p, m, tsam);

  sys = class (frdata, "frd", ltisys);
sys.lti.tsam
  if (argc > 0)
    sys = set (sys, varargin{:});
  endif

endfunction