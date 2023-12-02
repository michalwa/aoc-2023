:- use_module(library(charsio)).
:- use_module(library(dcgs)).
:- use_module(library(format)).
:- use_module(library(pio)).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(pairs)).

games([G|Gs])   --> game(G), "\n", games(Gs).
games([])       --> [].
game(Id-Rs)     --> "Game ", integer(Id), ": ", reveals(Rs).

reveals([R|Rs]) --> counts(R), "; ", reveals(Rs).
reveals([R])    --> counts(R).

counts([C|Cs])  --> count(C), ", ", counts(Cs).
counts([C])     --> count(C).
count(C-N)      --> integer(N), " ", color(C).

color(red)      --> "red".
color(green)    --> "green".
color(blue)     --> "blue".

integer(N)      --> digits(Ds), { number_chars(N, Ds) }.
digits([D|Ds])  --> digit(D), digits(Ds).
digits([D])     --> digit(D).
digit(D)        --> [D], { char_type(D, decimal_digit) }.

% Part 1

possible_count(red,   N) :- N =< 12.
possible_count(green, N) :- N =< 13.
possible_count(blue,  N) :- N =< 14.

possible_reveals(Rs) :-
  forall(member(Cs, Rs),
    forall(member(C-N, Cs), possible_count(C, N))).

games_possible([], []).
games_possible([Id-Rs|Gs], PGs) :-
     possible_reveals(Rs)
  -> ( PGs = [Id-Rs|PGs0], games_possible(Gs, PGs0) )
  ;  games_possible(Gs, PGs).

part1(Gs) :-
  games_possible(Gs, PGs),
  maplist(portray_clause, PGs),
  pairs_keys(PGs, Ids),
  sum_list(Ids, S),
  portray_clause(S).

% Part 2

product(X, Y, Z) :- Z is X * Y.

power(_-Rs, P) :-
  append(Rs, Cs), % flatten the reveals
  keysort(Cs, SCs),
  group_pairs_by_key(SCs, GCs), % group by color
  portray_clause(GCs),
  pairs_values(GCs, Css),
  maplist(list_max, Css, Ms),
  foldl(product, Ms, 1, P).

part2(Gs) :-
  maplist(power, Gs, Ps),
  sum_list(Ps, S),
  portray_clause(S).

run :-
  argv([I|_]),
  phrase_from_file(games(Gs), I),
  part1(Gs),
  part2(Gs),
  halt.
