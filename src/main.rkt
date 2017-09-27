#lang racket/base

(require "settings.rkt"
         "bot.rkt")

(define cirno (bot token #f))

(thread (λ () (start-loop cirno)))
