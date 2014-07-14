;;; Exercise 2.82.  Show how to generalize apply-generic to handle coercion in
;;; the general case of multiple arguments. One strategy is to attempt to
;;; coerce all the arguments to the type of the first argument, then to the
;;; type of the second argument, and so on.

(define (apply-generic op . args)
  (let* ([type-tags (map type-tag args)]
         [proc (get op type-tags)])
    (if proc
      (apply proc (map contents args))
      (apply apply-generic op (unify-types op args)))))

(define (unify-types op args)
  (define types (map type-tag args))
  (define (fail)
    (error "No method for these types"
           (list op types)))
  (if (every (lambda (t) (eq? (car types))) types)
    (fail))
  (let try ([base-type-candidates types])
    (if (null? base-type-candidates)
      (fail)
      (let* ([base-type (car base-type-candidates)]
             [coercers (map (lambda (another-type)
                              (get-coercion base-type another-type))
                            types)])
        (if (memq #f coercers)
          (try (cdr base-type-candidates))
          (map (lambda (c a) (c a)) coercers args))))))

; Note that unify-types assumes that get-coercion returns an "identity"
; procedure if it is called with the same types.  For example:

(define %get-coercion get-coercion)
(define (get-coercion from-type to-type)
  (define (identity x) x)
  (if (eq? from-type to-type)
    identity
    (%get-coercion from-type to-type)))

;;; Give an example of a situation where this strategy (and likewise the
;;; two-argument version given above) is not sufficiently general. (Hint:
;;; Consider the case where there are some suitable mixed-type operations
;;; present in the table that will not be tried.)

; TODO
