(defun fl-interp-atom-context (E C)
    (cond
        (
            (null C)
            E
        )
        (
            (null (caar C))
            (fl-interp-atom-context E (cdr C))
        )
        (
            (equal E (caar C))
            (cadar C)
        )
        (
            T
            (fl-interp-atom-context E (cons (cons (cdaar C) (cddar C)) (cdr C)))
        )
    )
)

(defun fl-interp-atom (E P C)
    (cond
        (
            (null P)
            (fl-interp-atom-context E C)
        )
        (
            (equal (caar P) E)
            (list (get_fnargs (cdar P)) (get_fnbody (car P)))
        )
        (
            T
            (fl-interp-atom E (cdr P) C)
        )
    )
)

(defun get_fnbody (L)
    (cond
        ((eq (car L) '=) (cadr L))
        (t (get_fnbody (cdr L)))
    )
)

(defun get_fnargs (L)
    (cond
        ((eq (car L) '=) nil)
        (t (cons (car L) (get_fnargs (cdr L))))
    )
)

(defun fl-interp (E P)
    (_fl-interp E P NIL)
)

(defun _fl-interp (E P C)
    (if (atom E)  ; this includes the case where expr is nil
        (fl-interp-atom E P C)
        (let
            (
                (f (car E))
                (arg (cdr E))
            )
            (cond
                ; handle built-in functions
                ((eq f 'if) (if (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C) (_fl-interp (caddr arg) P C)))
                ((eq f 'null)  (null (_fl-interp (car arg) P C)))
                ((eq f 'atom)  (atom (_fl-interp (car arg) P C)))
                ((eq f 'eq)  (eq (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f 'first)  (car (_fl-interp (car arg) P C)))
                ((eq f 'rest)  (cdr (_fl-interp (car arg) P C)))
                ((eq f 'cons) (cons (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f 'equal)  (equal (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f 'number)  (numberp (_fl-interp (car arg) P C)))
                ((eq f '+)  (+ (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f '-)  (- (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f '*)  (* (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f '>)  (> (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f '<)  (< (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f '=)  (= (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))
                ((eq f 'and)  (not (null (and (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))))
                ((eq f 'or)  (not (null (or (_fl-interp (car arg) P C) (_fl-interp (cadr arg) P C)))))
                ((eq f 'not)  (not (_fl-interp (car arg) P C)))

                (
                    T
                    (let
                        (
                            (ev_args (eval_args arg P C))
                            (closure (_fl-interp f P C))
                        )
                        (let
                            (
                                (new_context (cons (cons (caar closure) ev_args) C))
                                (body (cadr closure))
                            )
                            (_fl-interp body P new_context)
                        )
                    )
                )
            )
        )
    )
)

(defun eval_args (args P C)
    (cond
        ((null args) nil)
        (t (cons (_fl-interp (car args) P C) (eval_args (cdr args) P C)))
    )
)
