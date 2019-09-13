#lang racket/base

(provide pong
         db-test
         lois
         zashquor
         top)

(require racket/list
         racket/string)

(require "telegram.rkt"
         "db-sqlite.rkt"
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

    (define mentioned-usernames (get-mentioned-usernames update))
    
    (define username
      (if (empty? mentioned-usernames)
          (hash-get-path update '(message reply_to_message from username))
          (first (get-mentioned-usernames update))))
      
    (displayln from)
    (displayln username)
    (cond
      [(not (member from loisers)) 
       (send-message token
                      (get-chat-id update)
                      "Ты не можешь влиять на лойсо-зашкварные характеристики участников")]
      [(equal? username from)
       (send-message token
                  (get-chat-id update)
                  cannot-do-message)]
      [else
       (inc-function! db username)
       (send-message token
                     (get-chat-id update)
                     success-message)])))

;;; Hardcode for now
(define loisers
 '("quasipoi" "stdray" "A72A9B1A7446E5A4977EFFE3B5759C" "volchique" "sdfyu89sadhuaod1" "lenzlenz123"
  "kartofell_god" "tgnl0" "mike_123" "deadalivee"))

(define (top chat-id)
  (λ (token db)
    (define data (get-all-stats db))
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
