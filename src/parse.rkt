#lang racket/base

(provide parse)

(require "commands.rkt"
         "telegram.rkt")

(define (parse update)
  (define text (get-text update))
  (cond
    [(not text) #f]
    [(is-ping? text) (pong (get-chat-id update))]
    [else #f]))

(define (is-ping? text)
  (regexp-match #px"^(?i:Сырна (пинг|ping))($|[\\s])" text))
