/*

Copyright (C) 2009-2013   Lukas F. Reichlin

This file is part of LTI Syncope.

LTI Syncope is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LTI Syncope is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with LTI Syncope.  If not, see <http://www.gnu.org/licenses/>.

Return true if argument is a real vector.

Author: Lukas Reichlin <lukas.reichlin@gmail.com>
Created: September 2010
Version: 0.1

*/

#include <octave/oct.h>

DEFUN_DLD (is_real_vector, args, nargout,
   "-*- texinfo -*-\n\
@deftypefn {Loadable Function} {} is_real_vector (@var{a}, @dots{})\n\
Return true if argument is a real vector.\n\
@var{[]} is not a valid vector.\n\
Avoid nasty stuff like @code{true = isreal (\"a\")}\n\
@seealso{is_real_square_matrix, is_real_matrix, is_real_scalar}\n\
@end deftypefn")
{
    octave_value retval = true;
    int nargin = args.length ();

    if (nargin == 0)
    {
        print_usage ();
    }
    else
    {
        for (int i = 0; i < nargin; i++)
        {
            if (args(i).ndims () != 2 || ! (args(i).rows () == 1 || args(i).columns () == 1)
                || ! args(i).is_numeric_type () || ! args(i).is_real_type ())
            {
                retval = false;
                break;
            }
        }
    }

    return retval;
}
