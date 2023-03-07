/*
    Associations - Defines an association (i.e., dictionary) in OpenSCAD.

    Copyright (C) 2023  Andrew Semprebon (semprebon@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

/*
    Get value from association
 */
function association_get(assoc, key, default=undef) =
    let (p = [ for (pair = assoc) if (pair[0] == key) pair[1] ])
    (p[0] == undef) ? default : p[0];

function association_keys(assoc) = [ for (pair = assoc) pair[0] ];

/*
    Create an associative array
 */
function associate(values) =
    let (
        count = len(values)/2,
        _data = [ for (i = [0:2:len(values)-1]) [values[i], values[i+1]] ]
    )
    function (key, default, list=false, keys=false)
        list ? values
            : keys ? association_keys(_data)
            : association_get(_data, key, default);

/*
    Merge two associations, giving the second preference
    ! TODO: remove duplicates
 */
function merge_associations(a, b) =
    associate(concat(b(list=true),a(list=true)));
