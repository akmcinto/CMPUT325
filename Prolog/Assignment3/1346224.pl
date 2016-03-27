 % Andrea McIntosh
 % 1346224
 % CMPUT 325, Section B1
 % Assignment 3
 % Consulted with Jenna Hatchard and Dylan Ashley

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

notMember(A, L) is a helper predicate for xunique (and also the helper predicate notsubset
in question 5.2).  It takes an atom A and a list of atoms L, and returns true if
A is not an element of L and false if it is.
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
    allConnected([a]).     -> true
    allConnected([a,b,c]). -> true
    allConnected([b,e]).   -> false

connect(A, L) is a helper predicate for allConnected.  A is a node and L is a list of
nodes.  The predicate determines if A is connected to all nodes in L.
---------------------*/
allConnected([]).
allConnected([H|T]) :- connect(H, T), allConnected(T).

connect(_, []).
% Graph is non-directed, so check for both possible orderings of nodes (an edge should only be specified once)
connect(A, [X|L]) :- edge(A, X), connect(A, L).
connect(A, [X|L]) :- edge(X, A), connect(A, L).

/* --------------------
#5.2
maxclique(N, Cliques).  This predicate finds all maximal cliques of a certain size in
a non-directed graph.  N is a number, and Cliques is a list of cliques or a variable.
If Cliques is a varible then the predicate returns all maximal cliques of size N.
If Cliques is a list of cliques then the predicate returns whether or not Cliques
contains all possible maximal cliques of size N.  The maximal cliques are found by
finding all cliques of size N or larger, finding which of these cliques are maximal
cliques in the graph, and then returning only those maximal cliques of length extactly N.

Test Cases:
    maxclique(3, X).             -> X = [[a,b,c]]
    maxclique(2, [[a,d],[a,e]]). -> true
    maxclique(2, [[a,d]]).       -> false

cliqueLargerThan(N, L) is a helper predicate for maxclique used to filter out cliques
that are smaller than length N.  Given a number N and a variable L cliqueLargerThan
will return all cliques of length N or longer.  It is important for the functionality
of maxclique that cliques larger than N are returned as well, as they are used to
determine whether a clique is truly maximal or not in the graph.

inList(X, L) is a helper predicate for maxclique.  It takes a list X and a list of
lists X, and returns whether X is one of the lists in L or not.

isMaxClique(X, L) is a helper predicate for maxclique that is used to determine
whether a clique is maximal in the graph or not.  It takes a clique X and a list of
cliques L, and returns whether X is maximal based on the cliques in L or not.

notsubset(L1, L2) is a helper predicate for maxclique.  It takes two cliques L1
and L2, and returns true if L1 is not a subset of L2, and will return false if L1
is a subset of L2.  If L1 and L2 are the same then notsubset will return false as
a clique is a subset of itself.
---------------------*/
maxclique(N, L) :- number(N), findall(C, cliqueLargerThan(N, C), G),
                                findall(M, (inList(M, G), isMaxClique(M, G)), X),
                                findall(K, (inList(K, X), length(K, N)), L).

cliqueLargerThan(N, L) :- number(N), clique(L), length(L, G), G >= N.

inList(X, [X|_]).
inList(X, [H|T]) :- X \== H, inList(X, T).

isMaxClique(_, []).
% If L == H, L may still be a max clique but notsubset will return false, so just continue along T
isMaxClique(L, [H|T]) :- L \== H, notsubset(L, H), isMaxClique(L, T).
isMaxClique(L, [H|T]) :- L == H, isMaxClique(L, T).

notsubset([H|_], X) :- notMember(H, X).
notsubset([H|T], X) :- member(H, X), notsubset(T, X).
