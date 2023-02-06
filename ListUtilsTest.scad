include <ListUtils.scad>;
include <TestSupport.scad>;

module test_drop() {
    assert(is_empty(drop([],1)), "drop from empty list is empty list");
    assert(is_empty(drop([1,2],4)), "drop too many from short list is empty list");
    assert([3] == drop([1,2,3],2), "drop from list drops first values");
    assert([2,3] == drop([1,2,3]), "drop 1 from list is no count specified");
    assert(is_undef(drop([1,2,3],-1)), "can't drop negative items");
}

module test_drop_last() {
    assert(is_empty(drop_last([],1)), "drop from empty list is empty list");
    assert(is_empty(drop_last([1,2],4)), "drop too many from short list is empty list");
    assert([1] == drop_last([1,2,3],2), "drop from list drops last values");
    assert([1,2] == drop_last([1,2,3]), "drop 1 from list is no count specified");
    assert(is_undef(drop_last([1,2,3],-1)), "can't drop negative items");
}

module test_last() {
    assert(is_undef(last([])), "empty list has undef last item");
    assert(2 == last([1,2]), "return last item");
}

module test_index_of() {
    assert(undef == index_of([2,4,7], 8), "not founds returns undef");
    assert(undef == index_of([], 8), "empty list returns undef");
    assert(1 == index_of([2,4,7], 4), "found returns index of first occurrence");
}

module test_find() {
    assert(undef == find([2,4,7], function (a) a>=10), "not founds returns undef");
    assert(undef == find([], function (a) a>=10), "empty list returns undef");
    assert(1 == find([2,4,7], function (a) a>=3), "found returns first occurrence");
}

module test_unique() {
    assert([] == unique([]), "returns empty list for empty list");
    assert([1,4,2] == unique([1,4,2,1,1,4]), "returns unique elements");
}

module test_concat_to_last() {
    assert([] == concat_to_last([], []), "adding empty to empty returns empty");
    assert([[1,2]] == concat_to_last([[]], [1,2]), "adding list to empty lists gives list of one");
    assert([[1,2,3]] == concat_to_last([[1,2,3]], []), "adding empty list doesn't change last list");
    assert([[1,2,3,4]] == concat_to_last([[1,2,3]], [4]), "adding list to single list adds to end of list");
    assert([[1,2],[3,4]] == concat_to_last([[1,2],[3]], [4]), "adding list to many list adds to end of last list");
}

module test_fold() {
    sum = function (a,b) a + b;
    assert(7 == fold([1,2,3], 1, sum), "accumulates 1 + (1+2+3) = 7");
    assert(1 == fold([], 1, sum), "returns initial value if list empty");
}

module test_fold_index() {
    sum_mult = function (a,b,i) a + b*i;
    assert(9 == fold_index([3,4,2], 1, sum_mult), "accumulates 1 + (0*3 + 1*4 + 2*2) = 9");
    assert(1 == fold_index([], 1, sum_mult), "returns initial value if list empty");
}

module test_repeat() {
    assert([] == repeat([1,2], 0), "repeat 0 times is empty list");
    assert([1,2,1,2,1,2] == repeat([1,2], 3), "repeat 3 times is list repeated");
}

module test_generate() {
    squares = function(i) i*i;
    assert([] == generate(squares, 0), "generate 0 times is empty list");
    assert([0,1,4,9] == generate(squares, 4), "generate 4 times");
}

module test_remove() {
    assert([1,7] == remove([0,1,2,4,6,7], function (a) a%2 == 0), "remove even values");
    assert([] == remove([0,1,2,4,6,7], function (a) a%2 >= 0), "remove all values");
    assert([] == remove([], function (a) a%2 >= 0), "works on empty list");
}

module test_flat_map() {
    double = function(a) [a,a];
    assert([1,1,2,2,3,3] == flat_map([1,2,3], double));
}

module test_reduce() {
    assert(24 == reduce([4,3,2,1], function (a,b) a*b), "multiplies list items");
    assert(4 == reduce([4], function (a,b) a*b), "return single item");
    assert(undef == reduce([], function (a,b) a*b), "return undef for empty list");
}

module test_quicksort() {
    identity = function (a) a;
    assert([1,1,2,3,6,8,9] ==
        quicksort([6,1,8,9,1,3,2], identity), "sorts numbers");

    t_index = function (s) search("t", s)[0];
    unsorted = ["sect","stack", "trick","arrest", "stop"];
    assert(["trick","stack","stop","sect","arrest"] ==
        quicksort(unsorted, t_index), "sorts numbers");
}

module test_fill() {
    items = ["cat", "duck", "ox", "rabbit", "hen"];
    assert([["cat", "duck", "ox"],["rabbit", "hen"]] ==
        fill(items, 11, get_size=function (s) len(s)), "splits items in groups so group length <= 11");
    assert([["cat", "duck"], ["ox"],["rabbit"], ["hen"]] ==
        fill(items, 7, get_size=function (s) len(s)), "splits items in groups so group length <= 7");
    assert([[]] ==
        fill([], 7, get_size=function (s) len(s)), "returns list of empty list if no items");
}

module test_flatten() {
    items = [1,2,[3,4],[[5],[],6]];
    assert([1,2,3,4,[5],[],6] == flatten(items), "flattens list");
    assert([] == flatten([]), "flattens empty list");
}

test_drop();
test_last();
test_index_of();
test_unique();
test_drop_last();
test_concat_to_last();
test_reduce();
test_fold();
test_fold_index();
test_repeat();
test_generate();
test_remove();
test_flat_map();
test_quicksort();
test_fill();
test_flatten();
