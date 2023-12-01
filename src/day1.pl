:- use_module(library(format)).
:- use_module(library(dcgs)).
:- use_module(library(charsio)).
:- use_module(library(pio)).
:- use_module(library(lists)).

lines([N|Ns]) --> line(N), "\n", lines(Ns).
lines([])     --> [].

line(N) --> alnums_lazy, digit(X), alnums_greedy, digit(Y), alnums_lazy, { number_chars(N, [X, Y]) }.
line(N) --> alnums_lazy, digit(X), alnums_lazy, { number_chars(N, [X, X]) }.

% If the empty variant is declared first, the grammar will be lazy/non-greedy, i.e.
% the search will continue trying to match `line` before trying other matches of `maybe_alpha`
alnums_lazy --> [].
alnums_lazy --> [X], { char_type(X, alnum) }, alnums_lazy.

% This one on the other hand is greedy
alnums_greedy --> [X], { char_type(X, alnum) }, alnums_greedy.
alnums_greedy --> [].

digit(X) --> [X], { char_type(X, decimal_digit) }.

% Part 2
digit('0') --> "zero".
digit('1') --> "one".
digit('2') --> "two".
digit('3') --> "three".
digit('4') --> "four".
digit('5') --> "five".
digit('6') --> "six".
digit('7') --> "seven".
digit('8') --> "eight".
digit('9') --> "nine".

run :-
  argv([I|_]),
  phrase_from_file(lines(Ns), I),
  portray_clause(Ns),
  sum_list(Ns, S),
  portray_clause(S),
  halt.
