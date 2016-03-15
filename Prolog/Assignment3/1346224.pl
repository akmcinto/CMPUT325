/* --------------------
#1
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
xunion(L1, L2, L) :- append(L1, L2, X), xunique(X, L).

/* --------------------
#4
---------------------*/
removeLast([F|L], L, F) :- L = [].
removeLast([F|L], [F|L1], Last) :- removeLast(L, L1, Last).

/* --------------------
#5
---------------------*/
clique(L) :- findall(X,node(X),Nodes),
             subset(L,Nodes), allConnected(L).
subset([], _).
subset([X|Xs], Set) :- xappend(_, [X|Set1], Set), subset(Xs, Set1).

xappend([], L, L).
xappend([H|T], L, [H|R]) :- xappend(T, L, R).

%5.1
allConnected([]).
allConnected([H|T]) :- connect(H, T), allConnected(T).

connect(_, []).
connect(A, [X|L]) :- edge(A, X), connect(A, L).
connect(A, [X|L]) :- edge(X, A), connect(A, L).

%5.2
% maxclique(N, L) :- number(N), findall(C, cliqueLargerThan(N, C), G), findMaxCliques(G, G, L).
maxclique(N, L) :- number(N), findall(C, cliqueLargerThan(N, C), G),
                                findall(M, (listIn(M, G), isMaxClique(M, G)), X),
                                findall(K, (listIn(K, X), length(K, N)), L).

listIn(X, [X|_]).
listIn(X, [H|T]) :- X \== H, listIn(X, T).

isMaxClique(_, []).
isMaxClique(L, [H|T]) :- L \== H, notsubset(L, H), isMaxClique(L, T).
isMaxClique(L, [H|T]) :- L == H, isMaxClique(L, T).

isNotMaxClique(L, [H|_]) :- subset(L, H).
isNotMaxClique(L, [H|T]) :- notsubset(L, H), isNotMaxClique(L, T).

cliqueLargerThan(N, L) :- number(N), clique(L), length(L, G), G >= N.

notsubset([H|_], X) :- notMember(H, X).
notsubset([H|T], X) :- member(H, X), notsubset(T, X).

node(a).
node(b).
node(c).
node(d).
node(e).

edge(a,b).
edge(b,c).
edge(c,a).
edge(d,a).
edge(a,e).
