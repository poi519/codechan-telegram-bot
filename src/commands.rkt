#lang racket/base

(provide pong
         db-test
         lois
         zashquor
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
  (lois-zashquor-helper update
                        inc-stats-lois!
                        "Нельзя ставить лойсы самому себе"
                        "Лойс поставлен"))

(define (zashquor update)
  (lois-zashquor-helper update
                        inc-stats-zashquor!
                        "Нельзя ставить зашкворы самому себе"
                        "Зашкварено"))

(define (lois-zashquor-helper update inc-function! cannot-do-message success-message)
  (λ (token db)
    (displayln update)
    (define from (hash-get-path update '(message from username)))
    (define username (first (get-mentioned-usernames update)))
    (cond
      [(equal? (substring username 1) from)
       (send-message token
                  (get-chat-id update)
                  cannot-do-message)]
      [else
       (define user-stats (get-user-stats username))
       (inc-function! user-stats)
       (send-message token
                     (get-chat-id update)
                     success-message)])))

(define (top chat-id)
  (λ (token db)
    (define data (get-all-stats))
    (define lines
      (map (λ (stats)
             (format "~a лойсы: ~a зашкворы: ~a"
                     (stats-user stats)
                     (stats-lois stats)
                     (stats-zashquor stats)))
           (sort data > #:key score)))
    (send-message token
                  chat-id
                  (string-join lines "\n"))))
