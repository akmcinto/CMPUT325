?- use_module(library(clpfd)).
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
http://stackoverflow.com/questions/15442499/example-how-to-use-predsortcompare-list-sorted-in-prolog
*/
disarm(D1, D2, S) :- find_disarm(D1, D2, D1, D2, X), !, predsort(compareStrengths, X, S).

find_disarm(_, _, [], [], []).
find_disarm(O1, O2, [A|D1], D2, [[[A], [X, Y]]|S]) :- sumTwo(A, D2, [X,Y]),
    removeElement(X, D2, N), removeElement(Y, N, F),
    removeElement(A, O1, U), removeElement(X, O2, W), removeElement(Y, W, V),
    find_disarm(U, V, D1, F, S).
find_disarm(O1, O2, D1, [A|D2], [[[X, Y], [A]]|S]) :- sumTwo(A, D1, [X,Y]),
    removeElement(X, D1, N), removeElement(Y, N, F),
    removeElement(A, O2, U), removeElement(X, O1, W), removeElement(Y, W, V),
    find_disarm(V, U, F, D2, S).
find_disarm(O1, O2, [A|D1], [B|D2], S) :- append(D1, [A], X), append(D2, [B], H), O1 \== X, O2 \== H, find_disarm(O1, O2, X, H, S).
% disarm([A|D1], [B|D2], S) :- append(D1, [A], G), disarm(G, [B|D2], S); append(D2, [B], H), disarm([A|D1], H, S).

compareStrengths(<, [H|_], [F|_]) :- sumlist(H, D), sumlist(F, E), D < E.
compareStrengths(>, [H|_], [F|_]) :- sumlist(H, D), sumlist(F, E), D > E.
compareStrengths(=, [H|_], [F|_]) :- sumlist(H, D), sumlist(F, E), D = E.
% sumTwo(N, L, [A, B]) :- member(A, L), removeElement(A, L, X),
%     member(B, X), N is A + B.
sumTwo(N, [A|L], [A,B]) :- member(B, L), N is A + B.
sumTwo(N, [_|L], S) :- sumTwo(N, L, S).

removeElement(A, [A|L], L).
removeElement(A, [B|L], [B|S]) :- removeElement(A, L, S).
