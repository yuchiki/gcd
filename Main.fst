module Main

open FStar.All
open FStar.IO
open FStar.Math.Lemmas
open FStar.Math
open FStar.Order

val is_common_factor : pos -> pos -> pos -> bool
let is_common_factor a b c = (a % c = 0) && (b % c = 0)

type common_factor (a:pos) (b:pos) = c:pos{is_common_factor a b c}

val division_distributivity : a:pos -> b:pos -> c:pos{is_common_factor a b c} -> Lemma ((a+b) % c = 0)
let division_distributivity a b c = Math.Lemmas.modulo_distributivity a b c
// modulo_distributivity a b c = Lemma ((a + b) % c = (a + (b % c)) % c))

val gcd' : a:pos -> b:pos -> Tot (c:pos{is_common_factor a b c}) (decreases %[a+b; b])
let rec gcd' a b =
    match compare_int a b with
    | Gt ->
        let g = gcd' (a-b) b in
        division_distributivity (a-b) b g;
        g
    | Lt -> gcd' b a
    | Eq -> a

val gcd : a:pos -> b:pos -> Tot (common_factor a b)
let gcd = gcd'

val print_gcd : a:pos -> b:pos -> ML unit
let print_gcd a b = print_string (string_of_int (gcd a b)); print_newline ()

let main = print_gcd 374 816
