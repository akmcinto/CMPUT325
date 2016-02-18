(defun fl-interp-atom-context (E C)
    (cond
        ((null C) E)
        (
            (equal E (caar C))
            (cdar C)
        )
        (
            T
            (fl-interp-atom-context E (cdr C))
        )
    )
)

(defun fl-interp-atom (E P C)
    (cond
        ((null P) (fl-interp-atom-context E C))
        ((equal (caar P) E) (list (get_fnargs (cdar P)) (get_fnbody (car P))))
        (t (fl-interp-atom E (cdr P) C))
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
    (cond
        ((atom E) (fl-interp-atom E P C))  ; this includes the case where expr is nil
        ;((numberp (car E)) E)
        (t
            (let ((f (car E)) (arg (cdr E)))
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
                    ((equal (fl-interp-atom f P C) f) E)

                    (t
                        (let
                            ((ev_args (eval_args arg P C))
                                (closure (_fl-interp f P C)))
                            (let
                                ((new_context (get_context (car closure) ev_args C))
                                    (body (cadr closure)))
                                (_fl-interp body P new_context)
                            )
                        )
                    )
                )
            )
        )
    )
)

(defun get_context (vars nums C)
    (cond
        ((null nums) C)
        (t (cons (cons (car vars) (car nums)) (get_context (cdr vars) (cdr nums) C)))
    )
)

(defun eval_args (args P C)
    (cond
        ((null args) nil)
        (t (cons (_fl-interp (car args) P C) (eval_args (cdr args) P C)))
    )
)
