/* --------------------
#1
xreverse(L, R) :- xreverse(L, [], R).
xreverse([], R, R).
xreverse([H|T], R, A) :- xreverse(T, [H|R], A).
---------------------*/
xreverse([], []).
xreverse([F|L1], L2) :- xreverse(L1, N), append(N, [F], L2).

/* --------------------
#2
---------------------*/
xunique(L, Lu) :- xunique(L, [], Lu).
xunique([], _, []).
xunique([F|L], X, Lu) :- member(F, X), xunique(L, X, Lu).
xunique([F|L], X, [F|Lu]) :- notMember(F, X), xunique(L, [F|X], Lu).

notMember(_, []).
notMember(A, [F|R]) :- A \== F, notMember(A, R).

/* --------------------
#3
---------------------*/
xunion([],[],[]).
xunion(L1, L2, L) :- append(L1, L2, X), xunique(X, L).
