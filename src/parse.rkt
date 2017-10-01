#lang racket/base

(provide parse)

(require racket/list)

(require "commands.rkt"
         "telegram.rkt")

(define (parse update)
  (define text (get-text update))
  (cond
    [(not text) #f]
    [(is-ping? text) (pong (get-chat-id update))]
    [(is-db-up? text) (db-test (get-chat-id update))]
    [(is-lois? update) (lois update)]
    [(is-top? text) (top (get-chat-id update))]
    [else (displayln update)
          #f]))

(define (is-ping? text)
  (regexp-match #px"^(?i:Сырна (пинг|ping))($|[\\s])" text))

(define (is-db-up? text)
  (regexp-match #px"^(?i:Сырна (дб|db))($|[\\s])" text))

(define (contains-lois? text)
  (regexp-match #px"(?i:(^|[\\s])(лойс|lois)($|[\\s]))" text))

(define lois-allowed-chats '(-1001120821314))

(define (is-lois? update)
  (and (member (get-chat-id update) lois-allowed-chats)
       (contains-lois? (get-text update))
       (not (empty? (get-mentions update)))))

(define (is-top? text)
  (regexp-match #px"^(?i:Сырна (топ|top))($|[\\s])" text))
