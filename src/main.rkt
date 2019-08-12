#lang racket/base

(require "settings.rkt"
         "bot.rkt"
         "db-sqlite.rkt")

(define db (db-init))

(define cirno (bot token db))

(start-loop cirno)
