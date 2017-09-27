#lang racket/base

(require json
         racket/date
         racket/format
         racket/function
         racket/port
         net/url
         net/uri-codec)

;; Change this later
(provide (all-defined-out))

;; Partially copied from https://github.com/profan/teleracket
(date-display-format 'rfc2822)
(define base-url "https://api.telegram.org")

(define (url-open url)
  (let* ([input (get-pure-port (string->url url) #:redirections 5)]
         [response (port->string input)])
    (close-input-port input)
    response))

(define (current-date->string)
  (date->string (seconds->date (current-seconds)) #t))

(define (bot-request base-url bot-token type [params ""])
  (url-open (format "~a/bot~a/~a?~a" base-url bot-token type params)))

(define (make-message recipient message)
  `((chat_id . ,(~a recipient)) (text . ,(~a message))))

(define make-request (curry bot-request base-url))

(define (tele-api-call token method [params '()])
  (string->jsexpr (make-request token
                                method
                                (alist->form-urlencoded params))))

;; Public

(define (send-message token recipient text)
  (tele-api-call token
                 'sendMessage
                 (make-message recipient text)))

(define (get-updates token offset)
  (tele-api-call token
                 'getUpdates
                 `((offset . ,(~a offset)))))