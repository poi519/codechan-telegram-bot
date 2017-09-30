#lang racket/base

(provide pong
		 db-test)

(require "telegram.rkt"
		 "db.rkt")

(define (pong chat-id)
  (λ (token db)
    (send-message token chat-id "pong")))

(define (db-test chat-id)
  (λ (token db)
    (send-message token chat-id  (format "~a" (db-status)))))
