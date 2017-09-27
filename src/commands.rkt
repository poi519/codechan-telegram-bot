#lang racket/base

(require "telegram.rkt")

(provide (all-defined-out))

(define (pong chat-id)
  (λ (token db)
    (send-message token chat-id "pong")))
