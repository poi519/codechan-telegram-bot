#lang racket/base

(provide pong
         db-test
         lois
         top)

(require racket/list
         racket/string)

(require "telegram.rkt"
         "db.rkt"
         "utils.rkt")

(define (pong chat-id)
  (λ (token db)
    (send-message token chat-id "pong")))

(define (db-test chat-id)
  (λ (token db)
    (send-message token chat-id  (format "~a" (db-status db)))))

(define (lois update)
  (λ (token db)
    (define from (hash-get-path update '(message from username)))
    (define username (first (get-mentioned-usernames update)))
    (cond
      [(equal? (substring username 1) from)
       (send-message token
                  (get-chat-id update)
                  (format "Нельзя ставить лойсы самому себе"))]
      [else
       (define user-stats (get-user-stats username))
       (inc-stats-lois! user-stats)
       (send-message token
                     (get-chat-id update)
                     (format "Лойс поставлен"))])))

(define (top chat-id)
  (λ (token db)
    (displayln (get-all-stats))
    (define data (get-all-stats))
    (define lines
      (map (λ (stats)
             (format "~a лойсы: ~a"
                     (stats-user stats)
                     (stats-lois stats)))
           data))
    (send-message token
                  chat-id
                  (string-join lines "\n"))))
