#lang racket/base

(provide db-status
         db-init
         get-user-stats
         get-all-stats
         stats-user
         stats-lois
         inc-stats-lois!)

(require db/mongodb
         racket/sequence
         racket/list)

(define (db-init host port)
  (define m (create-mongo #:host host #:port port))
  (define db (make-mongo-db m "cirno-telegram-bot"))
  (current-mongo-db db)
  db)

(define-mongo-struct message "messages"
  ([user #:required]
   [body #:required]
   [time #:required]))

(define-mongo-struct stats "stats"
  ([user #:required]
   [lois #:inc]))

(define (get-user-stats username)
  (define data (sequence->list
                (mongo-dict-query "stats" `#hasheq((user . ,username)))))
  (if (empty? data)
      (make-stats #:user username
                  #:lois 0)
      (first data)))

(define (get-all-stats)
  (sequence->list (mongo-dict-query "stats" '())))

(define (db-status db)
  (hash-has-key? (mongo-db-execute-command! db '((ping . 1)))
                 'ok))
