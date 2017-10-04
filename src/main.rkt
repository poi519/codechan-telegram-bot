#lang racket/base

(require "settings.rkt"
         "bot.rkt"
         "db.rkt")

(define db (db-init db-host db-port))

(define cirno (bot token db))

(start-loop cirno)
