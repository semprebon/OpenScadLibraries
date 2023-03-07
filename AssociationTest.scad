/*
    Associations - Tests for Associations library

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

include <Association.scad>

module test_returns_value_for_key() {
    a = associate(["name", "George", "age", 23, "gender", "male"]);
    assert(23 == a("age"));
    assert("George" == a("name"));
    assert(72 == a("height", 72));
}

module test_returns_undef_for_missing_key() {
    a = associate(["name", "George", "age", 23, "gender", "male"]);
    assert(is_undef(a("height")));
}

module test_returns_default_for_missing_key() {
    a = associate(["name", "George", "age", 23, "gender", "male"]);
    assert(72 == a("height", 72));
}

module test_returns_list_of_keys() {
    a = associate(["name", "George", "age", 23, "gender", "male"]);
    assert(["name", "age", "gender"] == a(keys=true));
    assert([] == associate([])(keys=true));
}

module test_merge_uses_second_value_if_duplicate() {
    a = merge_associations(
        associate(["name", "George", "age", 23, "gender", "male"]),
        associate(["name", "George", "age", 30, "height", 72]));

    assert("George" == a("name"));
    assert(30 == a("age"));
    assert(72 == a("height"));
    assert("male" == a("gender"));
}

test_returns_value_for_key();
test_returns_undef_for_missing_key();
test_returns_default_for_missing_key();
test_merge_uses_second_value_if_duplicate();
test_returns_list_of_keys();