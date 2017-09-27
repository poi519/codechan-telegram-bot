#lang racket/base

(require racket/list)

(require "telegram.rkt"
         "parse.rkt")

(provide (all-defined-out))

(struct bot (token db))

(define (execute bot command)
  (command (bot-token bot) (bot-db bot)))

(define (get-initial-update-id bot)
  (define token (bot-token bot))
  (define updates-obj (get-updates token 0))
  (get-next-update-id updates-obj 0))

(define (start-loop bot)
  (loop bot (get-initial-update-id bot)))

(define (loop bot update-id)
  (define token (bot-token bot))
  
  (define updates-obj (get-updates token update-id))
  (define updates (hash-ref updates-obj 'result))

  (unless (empty? updates)
    (for ([update updates])
      (displayln update)
      (define command (parse update))
      (when command 
        (execute bot command))))
  (sleep 0.1)

  (loop bot (get-next-update-id updates-obj update-id)))

;; maybe move to telegram.rkt
(define (get-next-update-id updates-obj initial-update-id)
  (define latest-update-id (get-latest-update-id updates-obj))
  (if latest-update-id
      (add1 latest-update-id)
      initial-update-id))

(define (get-latest-update-id updates-obj)
  (define updates (hash-ref updates-obj 'result))
  (if (empty? updates)
      #f
      (hash-ref (last updates) 'update_id)))

