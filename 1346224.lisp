; Andrea McIntosh, 1346224, CMPUT 325, Section B1, Assignment 1

;QUESTION 1
#|
 This function takes an element x and a list y, and returns whether x is a
 member of y.  x can be an atom or another list.  The function returns T if x is
 a member of y, and nil if it is not.
|#
(defun xmember (x y)
    (cond
        ((null y) nil)
        ((equal x (car y)) T)
        (t (xmember x (cdr y)))
    )
)

;QUESTION 2
#|
 This function takes a list x with sublists nested to any depth, and returns a list
 of just the atoms contained in x.  If nil or an empty list, (), is an element of x
 or any of its nested sublists then nil will also be present in the flattened list
 (it is treayed like an atom, not a list with no elements).  The ordering of the atoms
 in x are maintained in the output.

 Test Cases:
 (flatten '(1 (2) 3)) => (1 2 3)
 (flatten '(1 (2 (3) 4) 5)) => (1 2 3 4 5)
 (flatten '((1 2) (3 4 nil) nil (5 (6 7)))) => (1 2 3 4 nil nil 5 6 7)
|#
(defun flatten (x)
    (cond
        ((null x) x)
        ((atom (car x)) (cons (car x) (flatten (cdr x))))
        (t (append (flatten (car x)) (flatten (cdr x))))
    )
)

;QUESTION 3
#|
 This function takes two lists, L1 and L2, and returns a single list created by
 alternating the elements of L1 and L2.  If one list is longer than the other than
 the remaining elements of the longer list are appended to the output list.

 Test Cases:
 (mix '(1 2 3) '(4 5 6)) => (1 4 2 5 3 6)
 (mix '(1 3) '(2 4 5 6)) => (1 2 3 4 5 6)
 (mix '(1 2 3) nil) => (1 2 3)
 (mix '(1 (3 4)) '(2)) => (1 2 (3 4))
|#
(defun mix (L1 L2)
    (cond
        ((null L1) L2)
        ((null L2) L1)
        (t (cons (car L1) (mix L2 (cdr L1))))
    )
)

;QUESTION 4
#|
 This function takes a list L, and returns a list of containing two sublists, (a b),
 created by adding elements of L to a and b alternatingly. This is done using a
 helper function, accumulate_splits.

 Test Cases:
 (split '(1 4 2 5 3 6)) => ((1 2 3) (4 5 6))
 (split '()) => (nil nil)
 (split '(1 (3 4) 2)) => ((1 2) ((3 4)))
|#
(defun split (L)
    (accumlate_splits nil nil L)
)

#|
 This is a helper function for the split function.  It takes the two sublists being
 created, a and b, and the list L the elements are being taken from. Elements of L
 are then added to a and b alternatingly.
|#
(defun accumlate_splits (a b L)
    (cond
        ((null L) (list a b))
        ((null (cdr L)) (accumlate_splits
            (append a (list (car L))) b (cddr L) )
        )
        (t (accumlate_splits
            (append a (list (car L))) (append b (list (cadr L))) (cddr L) )
        )
    )
)

;QUESTION 5
#| Part 1
 No, this is not always true.  The result will be different from (L1 L2) in the case
 that L1 is 2 or more elements longer than L2, or L2 is 1 or more elements longer than
 L1.  This is because split will evenly break apart the elements of the list created by
 mix, so if L1 or L2 are unbalanced in length they will not be returned by the split function.
 For example (split (mix (1 2 3) '(4)))) will return ((1 2) (4 3)), and
 (split (mix '(1) '(2 3))) will return ((1 3) (2)).

 Part 2
 This will always be true.  Depending on the length of L, the split will either return
 two lists of equal length, or the first list will be one element longer than the other.
 As an extension of Part 1, mixing these lists together will only result in a result
 different from L if the first part of the split, (car (split L)), is two or more elements
 longer than than the second part of the split, (cadr (split L)), or the second part of the
 split is one or more elements longer than the first part.  Since neither of these cases
 can occur as a result of the split opperation (at most the first part of the split can
 have one more element than the second part), so the mix will return L in all cases.
|#

;QUESTION 6
#|
 This function takes a list L and a value S, and returns a list containing a subset
 of the elements of L that sum up to the value S.  S should be a numeric value,
 and L should be a list containing only numeric atoms (no sublists).  If no combination
 of the values in L sum to S, then nil is returned.  If multiple subsets of L sum
 to S only one is returned.  This is done using a helper function, create_subset.
 create_subset returns a subset with the elements reversed to the order they are
 in L, so the returned value must be reversed to obtain the original ordering.

 Test Cases:
 (subsetsum '(1 2 3 4) 5) => (1 4) ; Note that only (1 4) is returned, but (2 3) is also correct
 (subsetsum '(1 2 3) 6) => (1 2 3)
 (subsetsum '(1 3 5) 7) => nil
|#
(defun subsetsum (L S)
    (xreverse (create_subset L S ()))
)

#|
 A helper function for the subsetsum function.  This function takes a list L from
 which elements are being taken to create subsets, a value S, and a list subset which
 is a subset of the values in L we are using to try and sum up to L.

 Each time an element is added to the subset being tested, it's value is subtracted
 from S.  If S becomes exactly 0 then that subset sums to S and is returned as the answer.
 If L becomes empty before S is zero (the values in the subset sum to less than S),
 or if S becomes negative (the values in the subset sum to more than S) then that
 subset does not work and nil is returned.  Otherwise, for each iteration two subsets
 are created to be tested, one which contains the first element of L and one which
 doesn't: in this way all possible subsets are tested.  The subset is created with
 its elements reversed relative to their original ordering in L.

 Test Cases:
 (create_subset '(1 2 3 4) 5 ()) => (4 1)
 (create_subset '(1 2 3) 6 ()) => (3 2 1)
 (create_subset '(1 3 5) 7 ()) => nil
|#
(defun create_subset (L S subset)
    (cond
        ((= S 0) subset)
        ((< S 0) nil)
        ((null L) nil)
        ((> (car L) S) (create_subset (cdr L) S subset))
        (t (or (create_subset (cdr L) (- S (car L)) (cons (car L) subset))
                (create_subset (cdr L) S subset)
            )
        )
    )
)

#|
 A function to reverse the ordering of items in a list x.  The ordering of elements
 in any nested sublist of x will not be reversed (the sublist will be treated as a
 single element during the reversing).  This is used as a helper function for the
 subsetsum function, as it reverses the subset returned by create_subset so that
 the elements in the subset have the same ordering as in L.

 Test Cases:
 (xreverse '(1 2 3)) => (3 2 1)
 (xreverse '(1 (2 3) 4)) => (4 (2 3) 1)
|#
(defun xreverse (x)
    (cond
        ((null x) nil)
        (t (append (xreverse (cdr x)) (list (car x))))
    )
)

; Consulted with Jenna Hatchard, Dylan Ashley, and Raghav Vamaraju
