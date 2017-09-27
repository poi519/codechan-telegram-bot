#lang racket/base

(require racket/list)

(require "commands.rkt")

(provide (all-defined-out))

(define (parse update)
  (define text (get-text update))
  (cond
    [(not text) #f]
    [(is-ping? text) (pong (get-chat-id update))]
    [else #f]))

(define (is-ping? text)
  (regexp-match #px"^(?i:Сырна (пинг|ping))($|[\\s])" text))

;;; These functions should be moved somewhere else

(define (hash-get-path h path)
  (cond
    [(empty? path) h]
    [(not (hash? h)) #f]
    [(hash-has-key? h (first path)) (hash-get-path (hash-ref h (first path))
                                                   (rest path))]
    [else #f]))

(define (get-chat-id update)
  (hash-get-path update '(message chat id)))

(define (get-text update)
  (hash-get-path update '(message text)))


