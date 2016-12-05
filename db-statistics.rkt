#lang racket/base
; db-statistics.rkt
(require racket/lazy-require
         racket/class
         ;racket/format
         racket/gui/base
         ;racket/list
         "db.rkt")
(lazy-require [racket/format (~r)]

              [racket/list (first)]
              [racket/list (empty?)]
              [racket/list (rest)]
              [racket/list (second)])
(provide stats-frame update-stats)

(define stats-frame (new frame%
                         [label "Ivy Statistics"]
                         [width 800]
                         [height 100]))

(define stats-vpanel
  (new vertical-panel%
       [parent stats-frame]
       [alignment '(left center)]))

(define (remove-children)
  (for ([child (in-list (send stats-vpanel get-children))])
    (send stats-vpanel delete-child child)))

(define (greater lst [num 0] [name ""])
  (cond [(empty? lst) (values num name)]
        [else
         (define len (length (second (first lst))))
         (if (> len num)
             (greater (rest lst) len (first (first lst)))
             (greater (rest lst) num name))]))

; give an up-to-date reading of the database
(define (create-children)
  (define imgs-pairs (table-pairs 'images))
  (define tags-pairs (table-pairs 'tags))
  
  (new message%
       [parent stats-vpanel]
       [label (format "Total images/tags: ~a / ~a" (length imgs-pairs) (length tags-pairs))])
  
  (let ([avg (/ (for/sum ([ip (in-list imgs-pairs)])
                  (length (second ip)))
                (length imgs-pairs))])
    (new message%
         [parent stats-vpanel]
         [label (format "Average tags per image: ~a" (~r (exact->inexact avg) #:precision 3))]))
  
  (new message%
       [parent stats-vpanel]
       [label
        (let-values ([(num name) (greater imgs-pairs)])
          (format "Largest number of tags on an image: ~a (~a)"
                  num name))])
  
  (new message%
       [parent stats-vpanel]
       [label
        (let-values ([(num name) (greater tags-pairs)])
          (format "Largest number of images in a tag category: ~a (~a)"
                  num name))])
  
  (void))

(define (update-stats)
  (remove-children)
  (create-children))
