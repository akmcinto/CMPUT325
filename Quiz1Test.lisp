(defun c2 (x)
    (cond
        ((null x) 0)
        ((null (cdr x)) 0)
        (t (+ 1 (c2 (cddr x))))

    )
)
