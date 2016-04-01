% ?- use_module(library(clpfd)).
% disarm([1,3,3,4,6,10,12], [3,4,7,9,16], X).

/*
QUESTION 1
*/
fourSquares(N, [S1, S2, S3, S4]) :-
    S1 in 0..N, S2 in 0..N, S3 in 0..N, S4 in 0..N,
    S1 #=< S2, S2 #=< S3, S3 #=< S4,
    S1^2 + S2^2 + S3^2 + S4^2 #= N,
    label([S1, S2, S3, S4]).

/*
QUESTION 2
*/
% disarm([], [], _).
% disarm(D1, D2, S) :- member(A, D1), sumTwo(A, D2, [X,Y]),
%     removeElement(X, D2, N), removeElement(Y, N, F), removeElement(A, D1, L),
%     disarm(L, F, [[[A], [X, Y]]|S]).
% disarm(D1, D2, S) :- member(A, D2), sumTwo(A, D1, [X,Y]),
%     removeElement(X, D1, N), removeElement(Y, N, F), removeElement(A, D2, L),
%     disarm(F, L, [[[X, Y], [A]]|S]).
disarm(D1, D2, S) :- disarm(D1, D2, [], S).
disarm([], [], S, S) :- checkStrengths(S).
disarm(D1, D2, G, S) :- member(A, D1), sumTwo(A, D2, [X,Y]),
    removeElement(X, D2, N), removeElement(Y, N, F), removeElement(A, D1, L),
    disarm(L, F, [[[A], [X, Y]]|G], S).
disarm(D1, D2, G, S) :- member(A, D2), sumTwo(A, D1, [X,Y]),
    removeElement(X, D1, N), removeElement(Y, N, F), removeElement(A, D2, L),
    disarm(F, L, [[[X, Y], [A]]|G], S).

checkStrengths([_|[]]).
checkStrengths([H,T|S]) :- compareStrengths(H, T), checkStrengths([T|S]).

compareStrengths([H|_], [F|_]) :- sumlist(H, D), sumlist(F, E), D =< E.

sumTwo(N, L, [A, B]) :- member(A, L), removeElement(A, L, X),
    member(B, X), A #=< B, A + B #= N.

removeElement(_, [], _).
removeElement(A, [A|L], L) :- removeElement(A, L, L), !.
removeElement(A, [B|L], [B|S]) :- removeElement(A, L, S).

notMember(_, []).
notMember(A, [F|R]) :- A \== F, notMember(A, R).
