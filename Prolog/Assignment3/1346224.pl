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
xunique([],_).
xunique([F|L], Lu) :- notMember(F, L), xunique(L, [F|Lu]).
xunique([F|L], Lu) :- member(F, L), xunique(L, Lu).

notMember(_, []).
notMember(A, [F|R]) :- A \== F, notMember(A, R).
