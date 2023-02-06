/*
    Some functions for processing lists
*/

function is_empty(list) = len(list) == 0;

/*
    Return an integer range for an integer or list
*/
function range(count) = is_num(count) ? [0:(count-1)] : [0:(len(count)-1)];

/*
    find the index of the first item in the list for which the given predicate is true
*/
function find_index(list, pred, start=0) =
    (start >= len(list)) ? undef
        : pred(list[start]) ? start : find_index(list, pred, start+1);

/*
    find the first item in the list for which the given predicate is true
*/
function find(list, pred, start=0) =
    let (i = find_index(list, pred, start))
    is_undef(i) ? undef : list[i];

/*
    drop the first n items (default 1) from a list
*/
function drop(list, n=1) =
    (n < 0) ? undef
        : (len(list) <= n) ? []
        : [ for (i = [n:(len(list)-1)]) list[i] ];

/*
    return a list containing the first n items (default 1) from a list
*/
function take(list, n=1) =
    (n < 0) ? undef
        : (len(list) >= n) ? list : [ for (a = range(n)) a ];

/*
    return the last item in a list
*/
function last(list) = list[len(list)-1];

function drop_last(list, n=1) =
    (n < 0) ? undef
        : (len(list) <= n) ? [] : [ for (i = [0:1:(len(list)-n-1)]) list[i] ];

function append(list, a) = concat(list, [a]);

/*
    Return the index of the first element equal to the given item, or undef if not found
*/
function index_of(list, a, start=0) = find_index(list, function(v) v==a, start);

function in_list(list, a) = !is_undef(index_of(list, a));

/*
    Return just unique elements of list.
*/
function unique(list) =
    fold(list, [], function (list, a) in_list(list, a) ? list : concat(list, [a]));

function concat_to_last(lists, list) =
    is_empty(list) ? lists
        : is_empty(lists) ? [list]
        : concat(drop_last(lists), [concat(last(lists), list)]);

function append_to_last(lists, a) = concat_to_last(lists, [a]);

/*
    Apply a function to every item in a list
*/
function map(list, f) = [ for (v = list) f(v) ];

/*
    Apply a function to every item in a list, along with the index of the item.

    example: multiply corresponding items in 2 lists: map_index(list1, function (v,i) = v * list2[i])
*/
function map_index(list, f) = [ for (v = l4ist) f(v) ];
/*
    Combine all elements of a list with a function
*/
function fold(list, init, f) =
    is_empty(list) ? init
        : fold(drop(list, 1), f(init, list[0]), f);

/*
    Combine all elements of a list with a function, but also supply the index to the function
*/
function fold_index(list, init, f, index=0) =
    is_empty(list) ? init
        : fold_index(drop(list, 1), f(init, list[0], index), f, index+1);

function flat_map(list, f) = fold(list, [], function (list, a) concat(list, [f(a)]));

function reduce(list, f) =
    is_empty(list) ? undef
        : (len(list) == 1) ? list[0]
        : f(list[0], reduce(drop(list, 1), f));

function repeat(list, count) =
    (count == 0) ? [] : concat(list, repeat(list, count-1));

function generate(f, count) =
    (count <= 0) ? [] : [ for (i = range(count)) f(i) ];

function keep(list, is_kept) = fold(list, [], function (list,item) is_kept(item) ? concat(list, [item]) : list);

function remove(list, is_removed) = keep(list, function (a) !is_removed(a));

function flat_map(list, f) = fold(list, [], function(a,b) concat(a, f(b)));

function map2(a, b, f) = [ for (i = range(a)) f(a[i],b[i]) ];

function is_any(list, pred) = fold(list, false, function (bool,a) bool || pred(a));

function is_all(list, pred) = fold(list, true, function (bool,a) bool && pred(a));

function quicksort(arr, f) =
    !(len(arr)>0) ? []
        : let(pivot   = f(arr[floor(len(arr)/2)]),
              lesser  = [ for (y = arr) if (f(y)  < pivot) y ],
              equal   = [ for (y = arr) if (f(y) == pivot) y ],
              greater = [ for (y = arr) if (f(y)  > pivot) y ]
              )
            concat(quicksort(lesser, f), equal, quicksort(greater, f));

function pop_to_size(new_items, limit, popped_items=[], get_size) =
    (len(new_items) == 0) ? [current_items, new_items]
        : let(
            item = new_items[0],
            size = get_size(item))
        (size > limit) ? [popped_items, new_items]
            : pop_to_size(drop(new_items, 1), limit-size, concat(popped_items, [item]), get_size);

function replace_last(list,item) =
     concat([ for (i = [0:1:(len(list)-2)]) list[i] ], [item]);

function fill(items, limit, get_size, groups=[[]]) =
    (len(items) == 0) ? groups
        : let(
            item = items[0],
            new_items = drop(items, 1),
            last_group = groups[len(groups)-1],
            new_size = get_size(item) + fold(last_group, 0, function(a,b) a+get_size(b)))
          (new_size <= limit)
            ? fill(drop(items,1), limit, get_size, replace_last(groups, concat(last_group, item)))
            : fill(drop(items,1), limit, get_size, concat(groups, [[item]]));

function flatten(arr) = fold(arr, [], function(a,b) concat(a, b));

