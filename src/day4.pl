:- use_module(library(format)).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(pio)).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(pairs)).

cards([card(W, R)|Cs]) --> card(W, R), "\n", cards(Cs).
cards([])              --> [].

% card(WinningNumbers, RevealedNumbers)
card(W, R) --> "Card", spaces, integer(_), ":", spaces, space_separated_integers(W), spaces, "|", spaces, space_separated_integers(R).

space_separated_integers([I|Is]) --> integer(I), spaces, space_separated_integers(Is).
space_separated_integers([I])    --> integer(I).

integer(I)     --> digits(Ds), { number_chars(I, Ds) }.
digits([D|Ds]) --> digit(D), digits(Ds).
digits([D])    --> digit(D).
digit(D)       --> [D], { char_type(D, decimal_digit) }.

spaces --> " ", spaces.
spaces --> " ".

% --

card_base_score(card(W, R), Z) :-
  countall(( member(N, R), member(N, W) ), Z).

power_of_two(E, P) :- E =< 0 -> P is 0 ; P is 1 << (E - 1).

% init_pairs([BaseScore|..], [BaseScore-1|..])
init_pairs([], []).
init_pairs([B|Bs0], [B-1|Bs]) :- init_pairs(Bs0, Bs).

% total_number_of_cards([BaseScore-Count|..], TotalNumberOfCards)
total_number_of_cards([], 0).
total_number_of_cards([B-C|Ps0], T) :-
  % Ps = Ps0 with C added to first B values
  pairs_keys_values(Ps0, Bs, Cs0),
  append(Cs1, Cs2, Cs0),
  length(Cs1, B),
  maplist(add(C), Cs1, Cs3),
  append(Cs3, Cs2, Cs),
  pairs_keys_values(Ps, Bs, Cs),

  total_number_of_cards(Ps, T0),
  T is T0 + C.

add(X, Y, Z) :- Z is X + Y.

run :-
  argv([I|_]),
  phrase_from_file(cards(Cs), I),
  maplist(card_base_score, Cs, Bs),

  % Part 1
  maplist(power_of_two, Bs, Ss),
  sum_list(Ss, S),
  portray_clause(S),

  % Part 2
  init_pairs(Bs, Ps),
  total_number_of_cards(Ps, T),
  portray_clause(T),

  halt.
