;QUESTION 1
; Check if x is a member of the list y.  Returns T if x is a member of y, nil otherwise.
(defun xmember (x y)
    (cond
        ((null y) nil)
        ((equal x (car y)) T)
        (t (xmember x (cdr y)))
    )
)

;QUESTION 2
;
(defun flatten (x)
    (cond
        ((null x) x)
        ((atom (car x)) (cons (car x) (flatten (cdr x))))
        (t (append (flatten (car x)) (flatten (cdr x))))
    )
)

;QUESTION 3
;
(defun mix (L1 L2)
    (cond
        ((null L1) L2)
        ((null L2) L1)
        (t (cons (car L1) (mix L2 (cdr L1))))
    )
)

;QUESTION 4
;
(defun split (L)
    (helper_function_for_question_4 nil nil L)
)

;
(defun helper_function_for_question_4 (a b L)
    (cond
        ((null L) (list a b))
        ((null (cdr L)) (helper_function_for_question_4
            (append a (list (car L))) b (cddr L) )
        )
        (t (helper_function_for_question_4
            (append a (list (car L))) (append b (list (cadr L))) (cddr L) )
        )
    )
)

;(defun helper_function_for_question_4 (a L)
;    (cond
;        ((null L) a)
;        ((null (cdr L)) (append (car a) (car L)))
;        (t (helper_function_for_question_4
;            (list (append (car a) (list (car L))) (append (cadr a) (list (cadr L)))) (cddr L) )
;        )
;    )
;)

;QUESTION 5
;

;QUESTION 6
(defun subsetsum (L S)
    (cond
        ((= S 0) L)
        ((< (xsum L) S) nil)
        ((= (xsum L) S) L)

        ((null L) nil)
        (t (cond
                ((subsetsum (cdr L) (- S (car L))) (append () (subsetsum (cdr L) (- S (car L)))))
                (t (append () (subsetsum (cdr L) S)))
            )
        )
    )
    ;(subsetsum (cdr L) (- S (car L)))
    ;(subsetsum (cdr L) S)
)

; Helper function for Question 6
; Returns the sum of all elements in a matrix.  Assumes that all elements of the
; matrix are numeric, but they can have any level of nesting.
(defun xsum (x)
    (cond
        ((null x) 0)
        ((atom x) x)
        (t (+ (xsum (car x)) (xsum (cdr x))))
    )
)
