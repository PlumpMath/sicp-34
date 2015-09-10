;;; Exercise 4.38.  Modify the multiple-dwelling procedure to omit the
;;; requirement that Smith and Fletcher do not live on adjacent floors. How
;;; many solutions are there to this modified puzzle?

(load "./sec-4.3.3.scm")

(ambtest '(begin

            (define (distinct? items)
              (cond ((null? items) true)
                    ((null? (cdr items)) true)
                    ((member (car items) (cdr items)) false)
                    (else (distinct? (cdr items)))))

            (define (multiple-dwelling)
              (let ((baker (amb 1 2 3 4 5))
                    (cooper (amb 1 2 3 4 5))
                    (fletcher (amb 1 2 3 4 5))
                    (miller (amb 1 2 3 4 5))
                    (smith (amb 1 2 3 4 5)))
                (require
                  (distinct? (list baker cooper fletcher miller smith)))
                (require (not (= baker 5)))
                (require (not (= cooper 1)))
                (require (not (= fletcher 5)))
                (require (not (= fletcher 1)))
                (require (> miller cooper))
                ; (require (not (= (abs (- smith fletcher)) 1)))
                (require (not (= (abs (- fletcher cooper)) 1)))
                (list (list 'baker baker)
                      (list 'cooper cooper)
                      (list 'fletcher fletcher)
                      (list 'miller miller)
                      (list 'smith smith))))

            (let ((answer (multiple-dwelling)))
              (print answer))

            ))

; baker    | 1 | 1 | 1 | 3 | 3 |
; cooper   | 2 | 2 | 4 | 2 | 4 |
; fletcher | 4 | 4 | 2 | 4 | 2 |
; miller   | 3 | 5 | 5 | 5 | 5 |
; smith    | 5 | 3 | 3 | 1 | 1 |
