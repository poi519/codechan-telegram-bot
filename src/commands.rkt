#lang racket/base

(provide pong)

(require "telegram.rkt")

(define (pong chat-id)
  (λ (token db)
    (send-message token chat-id "pong")))
