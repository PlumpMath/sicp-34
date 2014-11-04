;;; Exercise 3.24.  In the table implementations above, the keys are tested for
;;; equality using equal? (called by assoc). This is not always the appropriate
;;; test. For instance, we might have a table with numeric keys in which we
;;; don't need an exact match to the number we're looking up, but only a number
;;; within some tolerance of it. Design a table constructor make-table that
;;; takes as an argument a same-key? procedure that will be used to test
;;; ``equality'' of keys. Make-table should return a dispatch procedure that
;;; can be used to access appropriate lookup and insert! procedures for a local
;;; table.

(define (make-table same-key?)
  (define local-table (list '*table*))
  (define (associate key table)
    (cond [(null? table) #f]
          [(same-key? key (caar table)) (car table)]
          [else (associate key (cdr table))]))
  (define (lookup key-1 key-2)
    (let ((subtable (associate key-1 (cdr local-table))))
      (if subtable
          (let ((record (associate key-2 (cdr subtable))))
            (if record
                (cdr record)
                #f))
          #f)))
  (define (insert! key-1 key-2 value)
    (let ([subtable (associate key-1 (cdr local-table))])
      (if subtable
          (let ([record (associate key-2 (cdr subtable))])
            (if record
                (set-cdr! record value)
                (set-cdr! subtable
                          (cons (cons key-2 value)
                                (cdr subtable)))))
          (set-cdr! local-table
                    (cons (list key-1
                                (cons key-2 value))
                          (cdr local-table)))))
    'ok)
  (define (dispatch m)
    (cond [(eq? m 'lookup-proc) lookup]
          [(eq? m 'insert-proc!) insert!]
          [else (error "Unknown operation -- TABLE" m)]))
  dispatch)

(use srfi-13)
(define t (make-table string-ci=))
(print ((t 'lookup-proc) "foo" "bar"))
((t 'insert-proc!) "foo" "bar" "baz")
(print ((t 'lookup-proc) "FoO" "bAr"))
