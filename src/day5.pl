:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(charsio)).
:- use_module(library(format)).
:- use_module(library(lists)).

% almanac(Seeds, Maps)
almanac(Ss, Mss) --> seeds(Ss), "\n\n", maps(Mss), "\n".

seeds(Ss) --> "seeds: ", space_separated_integers(Ss).

maps([Ms|Mss]) --> map(Ms), "\n\n", maps(Mss).
maps([Ms])     --> map(Ms).
map(Ms)        --> name, "-to-", name, " map:\n", mappings(Ms).

% mapping(TargetStart, SourceStart, Length)
mappings([mapping(T, S, L)|Ms]) --> space_separated_integers([T, S, L]), "\n", mappings(Ms).
mappings([mapping(T, S, L)])    --> space_separated_integers([T, S, L]).

space_separated_integers([I|Is]) --> integer(I), " ", space_separated_integers(Is).
space_separated_integers([I])    --> integer(I).

integer(I)     --> digits(Ds), { number_chars(I, Ds) }.
digits([D|Ds]) --> digit(D), digits(Ds).
digits([D])    --> digit(D).
digit(D)       --> [D], { char_type(D, decimal_digit) }.

name      --> name_char, name.
name      --> name_char.
name_char --> [N], { char_type(N, alpha) }.

% --

mapping_number_mapped(mapping(T, S, L), N0, N) :-
  S =< N0, N0 < S + L, N is N0 + T - S.

mappings_number_mapped([], N, N).
mappings_number_mapped([M|Ms], N0, N) :-
    mapping_number_mapped(M, N0, N), !
  ; mappings_number_mapped(Ms, N0, N).

maps_number_mapped(Mss, N0, N) :-
  foldl(mappings_number_mapped, Mss, N0, N).

run :-
  argv([I|_]),
  phrase_from_file(almanac(Ss, Mss), I),
  maplist(maps_number_mapped(Mss), Ss, Ls),
  list_min(Ls, M),
  portray_clause(M),
  halt.
