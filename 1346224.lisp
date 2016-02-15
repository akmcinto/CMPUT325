(defun fl-interp (E P)
    (cond
        ((atom E) E)
        (t
            (let ( (f (car E))  (arg (cdr E)) )
                (cond
                    ; handle built-in functions
                    ((eq f 'null)  (null (fl-interp (car arg) P)))
                    ((eq f 'atom)  (atom (fl-interp (car arg) P)))
                    ((eq f 'eq)  (eq (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f 'first)  (car (fl-interp (car arg) P)))
                    ((eq f 'rest)  (cdr (fl-interp (car arg) P)))
                    ((eq f 'cons) (cons (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f 'equal)  (equal (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f 'number)  (numberp (fl-interp (car arg) P)))
                    ((eq f '+)  (+ (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f '-)  (- (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f '*)  (* (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f '>)  (> (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f '<)  (< (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f '=)  (= (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))
                    ((eq f 'and)  (not (null (and (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))))
                    ((eq f 'or)  (not (null (or (fl-interp (car arg) P) (fl-interp (car (cdr arg)) P)))))
                    ((eq f 'not)  (not (fl-interp (car arg) P)))

                    ; if f is a user-defined function,
                    ;    then evaluate the arguments
                    ;         and apply f to the evaluated arguments
                    ;             (applicative order reduction)

                    ; otherwise f is undefined; in this case,
                    ; E is returned as if it is quoted in lisp
                    (t E)
                )
            )
        )
    )
)
