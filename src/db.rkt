#lang racket/base

(provide db-status)

(require db/mongodb)

(define m (create-mongo))

(define d (make-mongo-db m "cirno-telegram-bot"))

(current-mongo-db d)
(define-mongo-struct message "messages"
  ([user #:required]
   [body #:required]
   [time #:required]))

(define (db-status)
  (mongo? m))
