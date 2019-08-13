#lang racket/base

(provide parse)

(require racket/list)

(require "commands.rkt"
         "telegram.rkt"
         "utils.rkt")

(define (parse update)
  (define text (get-text update))
  (cond
    [(not text) #f]
    [(is-ping? text) (pong (get-chat-id update))]
    [(is-db-up? text) (db-test (get-chat-id update))]
    [(is-lois? update) (lois update)]
    [(is-zashquor? update) (zashquor update)]
    [(is-top? text) (top (get-chat-id update))]
   
    [else (displayln update)
          #f]))

(define (is-ping? text)
  (regexp-match #px"^(?i:Сырна (пинг|ping))($|[\\s])" text))

(define (is-db-up? text)
  (regexp-match #px"^(?i:Сырна (дб|db))($|[\\s])" text))

(define (contains-lois? text)
  (regexp-match #px"(?i:(^|[\\s])(лойс|lois)($|[\\s]))" text))

(define (contains-zashquor? text)
  (regexp-match #px"(?i:(^|[\\s])(зашквор|зашквар|zashkvor|zashquor|zashkvar|zashquar)($|[\\s]))" text))

(define lois-allowed-chats '(-1001120821314))

(define (is-lois? update)
  (lois-zashquor? update contains-lois?))

(define (is-zashquor? update)
  (lois-zashquor? update contains-zashquor?))

(define (lois-zashquor? update text-predicate?)
  (and (member (get-chat-id update) lois-allowed-chats)
       (text-predicate? (get-text update))
       (or (not (empty? (get-mentions update)))
           (hash-get-path update '(message reply_to_message from username)))))

(define (is-top? text)
  (regexp-match #px"^(?i:Сырна (топ|top))($|[\\s])" text))
