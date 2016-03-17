/* --------------------
#1
xreverse(L, R).  Predicate to find the reverse of a list, where L is a list and
R is either another list or a variable.  If R is a variable the reversed list of
L will be returned, if both are lists then the predicate will return whether R is the
reversed list of L or not.

Test Cases:
    xreverse([1,2,3], X).        -> X = [3,2,1]
    xreverse([a,b,c], [c,b,a]).  -> true
    xreverse([a,b,c], [c,a,b]).  -> false
---------------------*/
xreverse([], []).
xreverse([F|L1], L2) :- xreverse(L1, N), append(N, [F], L2).

/* --------------------
#2
xunique(L, Lu).  Predicate to find the unqiue elements of a list, where L is an
arbitrary list of atoms and Lu is either a list or a variable.  If Lu is a variable
the list of unique elements in L (in the order they appear in L) will be returned.
If both L and Lu are lists then this predicate will return whether Lu contains the
unique atoms in L (in the correct ordering) or not.

Test Cases:
    xunique([1,2,4,3,3,2], X).          -> X = [1,2,4,3]
    xunique([1,2,4,3,3,2], [1,2,4,3]).  -> true
    xunique([1,2,4,3,3,2], [1,2,3,4]).  -> false (because ordering is wrong)
    xunique([1,2,3,2], [1,2,3,2]).      -> false
---------------------*/
xunique(L, Lu) :- xunique(L, [], Lu).
xunique([], _, []).
xunique([F|L], X, Lu) :- member(F, X), xunique(L, X, Lu).
xunique([F|L], X, [F|Lu]) :- notMember(F, X), xunique(L, [F|X], Lu).

notMember(_, []).
notMember(A, [F|R]) :- A \== F, notMember(A, R).

/* --------------------
#3
xunion(L1,L2,L).  Predicate that finds the union of two lists.  L1 and L2 are lists
of atoms, and L is a variable or a list.  If L is a varible the predicate returns
a list containing all the unique elements of L1 forllowed by all the unique elements
of L2 that are not in L1 (with ordering preserved).  The unique elements of each list are
determined using the xunique predicate defined in Question 2.  If L is a list the predicate
returns whether it is the unique elements of L1 and L2 in the correct order or not.

Test Cases:
    xunion([a,b,c], [c,d,d,e], X).                  -> X = [a,b,c,d,e]
    xunion([a,b,b,c], [c,d,d,e], [a,b,c,d,e]).      -> true
    xunion([a,b,b,c], [c,d,d,e], [a,b,c,c,d,e]).    -> false
---------------------*/
xunion(L1, L2, L) :- append(L1, L2, X), xunique(X, L).

/* --------------------
#4
removeLast(L,L1,Last).  Predicate that returns the result of removing the last element
of a list and the last element of the list.  L is a non-empty list, and L1 and Last
are either variables or values.  L1 is L with its last element removed and Last is
the last element of L.

Test Cases:
    removeLast([a,b,c,d], L1, Last).        -> L1 = [a,b,c], Last =  d
    removeLast([1,2,3,4,5], L1, 5).         -> L1 = [1,2,3,4]
    removeLast([a,b,c,d], [a,b,c], d).      -> true
    removeLast([a,b,c,d], [a, b], Last).    -> false
    removeLast([a,b,c,d], L1, [d]).         -> false
---------------------*/
removeLast([F|L], L, F) :- L = [].
removeLast([F|L], [F|L1], Last) :- removeLast(L, L1, Last).

/* --------------------
#5
Predicates related to the clique problem in graph theory.  clique(L), subset(L, Set),
and xappend(L1, L2, L) are were given in the assignment.

Given a set of nodes and edges in a undriected graph, clique(L) returns the list of
all cliques in the graph.

The following graph is used for the test cases in 5.1 and 5.2:
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
---------------------*/
clique(L) :- findall(X,node(X),Nodes),
             subset(L,Nodes), allConnected(L).

subset([], _).
subset([X|Xs], Set) :- xappend(_, [X|Set1], Set), subset(Xs, Set1).

xappend([], L, L).
xappend([H|T], L, [H|R]) :- xappend(T, L, R).

/* --------------------
#5.1
allConnected(L).  This predicate tests if every node in a list is connected to every
other node.  L is a list of nodes.  The nodes are all connected if there is an edge
between every pair of nodes.

Test Cases:
    allConnected(L) ->
---------------------*/
allConnected([]).
allConnected([H|T]) :- connect(H, T), allConnected(T).

connect(_, []).
connect(A, [X|L]) :- edge(A, X), connect(A, L).
connect(A, [X|L]) :- edge(X, A), connect(A, L).

/* --------------------
#5.2
---------------------*/
maxclique(N, L) :- number(N), findall(C, cliqueLargerThan(N, C), G),
                                findall(M, (inList(M, G), isMaxClique(M, G)), X),
                                findall(K, (inList(K, X), length(K, N)), L).

cliqueLargerThan(N, L) :- number(N), clique(L), length(L, G), G >= N.

inList(X, [X|_]).
inList(X, [H|T]) :- X \== H, inList(X, T).

isMaxClique(_, []).
isMaxClique(L, [H|T]) :- L \== H, notsubset(L, H), isMaxClique(L, T).
isMaxClique(L, [H|T]) :- L == H, isMaxClique(L, T).

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
