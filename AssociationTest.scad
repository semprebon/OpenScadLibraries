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
