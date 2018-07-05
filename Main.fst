module Main

open FStar.All
open FStar.List.Tot
open FStar.IO
open FStar.String


val hamming_distance: #a:eqtype -> l1:list a -> l2:list a{ List.length l1 = List.length l2 } -> int
let rec hamming_distance #a l1 l2 =
    match l1, l2 with
    | [], [] -> 0
    | hd1::tl1, hd2::tl2 -> (if hd1 = hd2 then 1 else 0) + hamming_distance tl1 tl2

let main =
    print_string "is sorted"
