## Copyright (C) 2009 Luca Favatella
## Copyright (C) 2009-2016   Lukas F. Reichlin
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
## @deftypefn {Function File} test ltimodels
## @deftypefnx {Function File} ltimodels
## @deftypefnx {Function File} ltimodels (@var{systype})
## Test suite and help for @acronym{LTI} models.
## @end deftypefn

## Author: Lukas Reichlin <lukas.reichlin@gmail.com>
## Created: November 2009
## Version: 0.2

function ltimodels (systype = "general")

  %if (nargin > 1)
    print_usage ();
  %endif

  ## TODO: write documentation

  if (! ischar (systype))
    error ("ltimodels: argument must be a string");
  endif

  systype = lower (systype);

  switch (systype)
    case "ss"
      str = {"State Space (SS) Models"...
             "-----------------------"...
             ""};

    case "tf"
      str = {"Transfer Function (TF) Models"...
             "-----------------------------"...
             ""};

    otherwise  # general
      str = {"Linear Time Invariant (LTI) Models"...
             "----------------------------------"...
             ""};

  endswitch

  disp ("");
  disp (char (str));

endfunction



## ==============================================================================
## LTI Tests
## ==============================================================================

## isct, isdt
%!shared ltisys
%! ltisys = tf (12);
%!assert (ltisys.ts, -2);
%!assert (isct (ltisys));
%!assert (isdt (ltisys));

%!shared ltisys
%! ltisys = ss (17);
%!assert (ltisys.ts, -2);
%!assert (isct (ltisys));
%!assert (isdt (ltisys));

%!shared ltisys
%! ltisys = tf (1, [1 1]);
%!assert (ltisys.ts, 0);
%!assert (isct (ltisys));
%!assert (! isdt (ltisys));

%!shared ltisys, ts
%! ts = 0.1;
%! ltisys = ss (-1, 1, 1, 0, ts);
%!assert (ltisys.ts, ts);
%!assert (! isct (ltisys));
%!assert (isdt (ltisys));



## ==============================================================================
## TF Tests
## ==============================================================================



## ==============================================================================
## SS Tests
## ==============================================================================

##
## The following tests are based on the SLICOT (http://www.slicot.org) library.
## SLICOT needs BLAS and LAPACK libraries which are also prerequisites for
## Octave itself. In case of failing tests, it is highly recommended to use
## Netlib's reference BLAS (http://www.netlib.org/blas/) and LAPACK
## (http://www.netlib.org/lapack/) for building Octave and the control
## package. Using other libs may lead to sign changes in some entries of the
## state-space matrices.
## In general, these sign changes are not 'wrong' and can be regarded as the
## result of state transformations. Such state transformations (but not
## input/output transformations) have  influence on the input-output
## behaviour of the system.
##
## For more details, please refer to the discusison for bug #45008 at
## https://savannah.gnu.org/bugs/?45008
##

## staircase (SLICOT AB01OD)
%!shared Ac, Bc, Ace, Bce
%! A = [ 17.0   24.0    1.0    8.0   15.0
%!       23.0    5.0    7.0   14.0   16.0
%!        4.0    6.0   13.0   20.0   22.0
%!       10.0   12.0   19.0   21.0    3.0
%!       11.0   18.0   25.0    2.0    9.0 ];
%!
%! B = [ -1.0   -4.0
%!        4.0    9.0
%!       -9.0  -16.0
%!       16.0   25.0
%!      -25.0  -36.0 ];
%!
%! tol = 0;
%!
%! A = A.';  # There's a little mistake in the example
%!           # program of routine AB01OD in SLICOT 5.0
%!
%! [Ac, Bc, U, ncont] = __sl_ab01od__ (A, B, tol);
%!
%! Ace = [ 12.8848   3.2345  11.8211   3.3758  -0.8982
%!          4.4741 -12.5544   5.3509   5.9403   1.4360
%!         14.4576   7.6855  23.1452  26.3872 -29.9557
%!          0.0000   1.4805  27.4668  22.6564  -0.0072
%!          0.0000   0.0000 -30.4822   0.6745  18.8680 ];
%!
%! Bce = [ 31.1199  47.6865
%!          3.2480   0.0000
%!          0.0000   0.0000
%!          0.0000   0.0000
%!          0.0000   0.0000 ];
%!
%!assert <45008> (Ac, Ace, 1e-4);
%!assert (Bc, Bce, 1e-4);


## controllability staircase form of descriptor state-space models (SLICOT TG01HD)
%!shared ac, ec, bc, cc, q, z, ncont, ac_e, ec_e, bc_e, cc_e, q_e, z_e, ncont_e
%!
%! a = [ 2     0     2     0    -1     3     1
%!       0     1     0     0     1     0     0
%!       0     0     0     1     0     0     1
%!       0     0     2     0    -1     3     1
%!       0     0     0     1     0     0     1
%!       0     1     0     0     1     0     0
%!       0     0     0     1     0     0     1 ];
%!
%! e = [ 0     0     1     0     0     0     0
%!       0     0     0     0     0     1     0
%!       0     0     0     0     0     0     1
%!       0     0     0     0     0     0     1
%!       0     0     0     1     0     0     0
%!       0     0     1     0    -1     0     0
%!       1     3     0     2     0     0     0 ];
%!
%! b = [ 2     1     0
%!       0     0     0
%!       0     0     0
%!       0     0     0
%!       0     0     0
%!       0     0     0
%!       1     2     3 ];
%!
%! c = [ 1     0     0     1     0     0     1
%!       0    -1     1     0    -1     1     0 ];
%!
%! tol = 0;
%!
%! [ac, ec, bc, cc, q, z, ncont] = __sl_tg01hd__ (a, e, b, c, tol);
%!
%! ncont_e = 3;
%!
%! ac_e = [  0.0000   0.0000   0.0000   0.0000  -1.2627   0.4334   0.4666
%!           0.0000   2.0000   0.0000  -3.7417  -0.8520   0.2924  -0.4342
%!           0.0000   0.0000   1.7862   0.3780  -0.2651  -0.7723   0.0000
%!           0.0000   0.0000   0.0000   3.7417   0.8520  -0.2924   0.4342
%!           0.0000   0.0000   0.0000   0.0000  -1.5540   0.5334   0.5742
%!           0.0000   0.0000   0.0000   0.0000  -0.6533   0.2242   0.2414
%!           0.0000   0.0000   0.0000   0.0000  -0.5892   0.2022   0.2177 ];
%!
%! ec_e = [ -1.8325   1.0000   2.3752   0.0000  -0.8214   0.2819   1.8016
%!           0.4887   0.0000   0.3770  -0.5345   0.1874   0.5461   0.0000
%!          -0.1728   0.0000  -0.1333  -1.1339   0.1325   0.3861   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.8520  -0.2924   0.4342
%!           0.0000   0.0000   0.0000   0.0000  -1.0260  -0.1496   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.0000   1.1937   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.0000   0.0000   1.0000 ];
%!
%! bc_e = [  1.0000   2.0000   3.0000
%!           2.0000   1.0000   0.0000
%!           0.0000   0.0000   0.0000
%!           0.0000   0.0000   0.0000
%!           0.0000   0.0000   0.0000
%!           0.0000   0.0000   0.0000
%!           0.0000   0.0000   0.0000 ];
%!
%! cc_e = [  0.0000   1.0000   0.0000   0.0000  -1.2627   0.4334   0.4666
%!           0.3665   0.0000  -0.9803  -1.6036   0.1874   0.5461   0.0000 ];
%!
%! q_e = [   0.0000   1.0000   0.0000   0.0000   0.0000   0.0000   0.0000
%!           0.0000   0.0000   0.7071   0.0000   0.2740  -0.6519   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.8304   0.3491  -0.4342
%!           0.0000   0.0000   0.0000  -1.0000   0.0000   0.0000   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.4003   0.1683   0.9008
%!           0.0000   0.0000   0.7071   0.0000  -0.2740   0.6519   0.0000
%!           1.0000   0.0000   0.0000   0.0000   0.0000   0.0000   0.0000 ];
%!
%! z_e = [   0.0000   1.0000   0.0000   0.0000   0.0000   0.0000   0.0000
%!          -0.6108   0.0000   0.7917   0.0000   0.0000   0.0000   0.0000
%!           0.4887   0.0000   0.3770  -0.5345   0.1874   0.5461   0.0000
%!           0.0000   0.0000   0.0000   0.0000  -0.4107   0.1410   0.9008
%!           0.6108   0.0000   0.4713   0.2673  -0.1874  -0.5461   0.0000
%!          -0.1222   0.0000  -0.0943  -0.8018  -0.1874  -0.5461   0.0000
%!           0.0000   0.0000   0.0000   0.0000  -0.8520   0.2924  -0.4342 ];
%!
%!assert <45008> (ac, ac_e, 1e-4);
%!assert <45008> (ec, ec_e, 1e-4);
%!assert <45008> (bc, bc_e, 1e-4);
%!assert <45008> (cc, cc_e, 1e-4);
%!assert <45008> (q, q_e, 1e-4);
%!assert <45008> (z, z_e, 1e-4);
%!assert (ncont, ncont_e);


## observability staircase form of descriptor state-space models (SLICOT TG01ID)
%!shared ao, eo, bo, co, q, z, nobsv, ao_e, eo_e, bo_e, co_e, q_e, z_e, nobsv_e
%!
%! a = [ 2     0     0     0     0     0     0
%!       0     1     0     0     0     1     0
%!       2     0     0     2     0     0     0
%!       0     0     1     0     1     0     1
%!      -1     1     0    -1     0     1     0
%!       3     0     0     3     0     0     0
%!       1     0     1     1     1     0     1 ];
%!
%! e = [ 0     0     0     0     0     0     1
%!       0     0     0     0     0     0     3
%!       1     0     0     0     0     1     0
%!       0     0     0     0     1     0     2
%!       0     0     0     0     0    -1     0
%!       0     1     0     0     0     0     0
%!       0     0     1     1     0     0     0 ];
%!
%! b = [ 1     0
%!       0    -1
%!       0     1
%!       1     0
%!       0    -1
%!       0     1
%!       1     0 ];
%!
%! c = [ 2     0     0     0     0     0     1
%!       1     0     0     0     0     0     2
%!       0     0     0     0     0     0     3 ];
%!
%! tol = 0;
%!
%! [ao, eo, bo, co, q, z, nobsv] = __sl_tg01id__ (a, e, b, c, tol);
%!
%! nobsv_e = 3;
%!
%! ao_e = [  0.2177   0.2414   0.5742   0.4342   0.0000  -0.4342   0.4666
%!           0.2022   0.2242   0.5334  -0.2924  -0.7723   0.2924   0.4334
%!          -0.5892  -0.6533  -1.5540   0.8520  -0.2651  -0.8520  -1.2627
%!           0.0000   0.0000   0.0000   3.7417   0.3780  -3.7417   0.0000
%!           0.0000   0.0000   0.0000   0.0000   1.7862   0.0000   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.0000   2.0000   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.0000   0.0000   0.0000 ];
%!
%! eo_e = [  1.0000   0.0000   0.0000   0.4342   0.0000   0.0000   1.8016
%!           0.0000   1.1937  -0.1496  -0.2924   0.3861   0.5461   0.2819
%!           0.0000   0.0000  -1.0260   0.8520   0.1325   0.1874  -0.8214
%!           0.0000   0.0000   0.0000   0.0000  -1.1339  -0.5345   0.0000
%!           0.0000   0.0000   0.0000   0.0000  -0.1333   0.3770   2.3752
%!           0.0000   0.0000   0.0000   0.0000   0.0000   0.0000   1.0000
%!           0.0000   0.0000   0.0000   0.0000  -0.1728   0.4887  -1.8325 ];
%!
%! bo_e = [  0.4666   0.0000
%!           0.4334   0.5461
%!          -1.2627   0.1874
%!           0.0000  -1.6036
%!           0.0000  -0.9803
%!           1.0000   0.0000
%!           0.0000   0.3665 ];
%!
%! co_e = [  0.0000   0.0000   0.0000   0.0000   0.0000   2.0000   1.0000
%!           0.0000   0.0000   0.0000   0.0000   0.0000   1.0000   2.0000
%!           0.0000   0.0000   0.0000   0.0000   0.0000   0.0000   3.0000 ];
%!
%! q_e = [   0.0000   0.0000   0.0000   0.0000   0.0000   1.0000   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.7917   0.0000  -0.6108
%!           0.0000   0.5461   0.1874  -0.5345   0.3770   0.0000   0.4887
%!           0.9008   0.1410  -0.4107   0.0000   0.0000   0.0000   0.0000
%!           0.0000  -0.5461  -0.1874   0.2673   0.4713   0.0000   0.6108
%!           0.0000  -0.5461  -0.1874  -0.8018  -0.0943   0.0000  -0.1222
%!          -0.4342   0.2924  -0.8520   0.0000   0.0000   0.0000   0.0000 ];
%!
%! z_e = [   0.0000   0.0000   0.0000   0.0000   0.0000   1.0000   0.0000
%!           0.0000  -0.6519   0.2740   0.0000   0.7071   0.0000   0.0000
%!          -0.4342   0.3491   0.8304   0.0000   0.0000   0.0000   0.0000
%!           0.0000   0.0000   0.0000  -1.0000   0.0000   0.0000   0.0000
%!           0.9008   0.1683   0.4003   0.0000   0.0000   0.0000   0.0000
%!           0.0000   0.6519  -0.2740   0.0000   0.7071   0.0000   0.0000
%!           0.0000   0.0000   0.0000   0.0000   0.0000   0.0000   1.0000 ];
%!
%!assert <45008> (ao, ao_e, 1e-4);
%!assert <45008> (eo, eo_e, 1e-4);
%!assert <45008> (bo, bo_e, 1e-4);
%!assert <45008> (co, co_e, 1e-4);
%!assert <45008> (q, q_e, 1e-4);
%!assert <45008> (z, z_e, 1e-4);
%!assert (nobsv, nobsv_e);


## ss2tf conversion by Slicot TB04BD
## Test provided by Slicot
%!shared NUM, DEN, NUMe, DENe
%! A = [ -1.0   0.0   0.0
%!        0.0  -2.0   0.0
%!        0.0   0.0  -3.0 ];
%!
%! B = [  0.0   1.0  -1.0
%!        1.0   1.0   0.0 ].';
%!
%! C = [  0.0   1.0   1.0
%!        1.0   1.0   1.0 ];
%!
%! D = [  1.0   0.0
%!        0.0   1.0 ];
%!
%! [NUM, DEN] = tfdata (ss (A, B, C, D));
%!
%! NUMe = {[1, 5, 7], [1]; [1], [1, 5, 5]};
%!
%! DENe = {[1, 5, 6], [1, 2]; [1, 5, 6], [1, 3, 2]};
%!
%!assert (NUM, NUMe, 1e-4);
%!assert (DEN, DENe, 1e-4);


## ss2tf conversion by Slicot TB04BD
## Trivial test
%!shared NUM, DEN, NUMe, DENe
%! A = [  0 ];
%!
%! B = [  1 ];
%!
%! C = [  1 ];
%!
%! D = [  0 ];
%!
%! [NUM, DEN] = tfdata (ss (A, B, C, D));
%!
%! NUMe = {[1]};
%!
%! DENe = {[1, 0]};
%!
%!assert (NUM, NUMe, 1e-4);
%!assert (DEN, DENe, 1e-4);


## transfer function to state-space conversion
## test from SLICOT TD04AD
%!shared Mo, Me
%! INDEX =  [  3     3 ];
%!
%! DCOEFF = [  1.0   6.0  11.0   6.0
%!             1.0   6.0  11.0   6.0 ];
%!
%! UCOEFF = zeros (2, 2, 4);
%!
%! u11 = [ 1.0   6.0  12.0   7.0 ];
%! u12 = [ 0.0   1.0   4.0   3.0 ];
%! u21 = [ 0.0   0.0   1.0   1.0 ];
%! u22 = [ 1.0   8.0  20.0  15.0 ];
%!
%! UCOEFF(1,1,:) = u11;
%! UCOEFF(1,2,:) = u12;
%! UCOEFF(2,1,:) = u21;
%! UCOEFF(2,2,:) = u22;
%!
%! [Ao, Bo, Co, Do] = __sl_td04ad__ (UCOEFF, DCOEFF, INDEX, 0);
%!
%! Ae = [  0.5000  -0.8028   0.9387
%!         4.4047  -2.3380   2.5076
%!        -5.5541   1.6872  -4.1620 ];
%!
%! Be = [ -0.2000  -1.2500
%!         0.0000  -0.6097
%!         0.0000   2.2217 ];
%!
%! Ce = [  0.0000  -0.8679   0.2119
%!         0.0000   0.0000   0.9002 ];
%!
%! De = [  1.0000   0.0000
%!         0.0000   1.0000 ];
%!
%! Mo = [Ao, Bo; Co, Do];
%! Me = [Ae, Be; Ce, De];
%!
%!assert (Mo, Me, 1e-4);
