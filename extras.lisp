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
