#lang racket/base

(provide tele-api-call
         send-message
         get-updates
         get-next-update-id
         get-latest-update-id
         get-chat-id
         get-text
         make-message)

(require "utils.rkt")

(require json
         racket/format
         racket/function
         racket/list
         net/uri-codec)

;; Partially copied from https://github.com/profan/teleracket
(define base-url "https://api.telegram.org")

(define (bot-request base-url bot-token type [params ""])
  (url-open (format "~a/bot~a/~a?~a" base-url bot-token type params)))

(define make-request (curry bot-request base-url))

;; API methods
(define (tele-api-call token method [params '()])
  (string->jsexpr (make-request token
                                method
                                (alist->form-urlencoded params))))

(define (send-message token recipient text)
  (tele-api-call token
                 'sendMessage
                 (make-message recipient text)))

(define (get-updates token offset)
  (tele-api-call token
                 'getUpdates
                 `((offset . ,(~a offset)))))

;; Updates
(define (get-next-update-id updates-obj initial-update-id)
  (define latest-update-id (get-latest-update-id updates-obj))
  (if latest-update-id
      (add1 latest-update-id)
      initial-update-id))

(define (get-latest-update-id updates-obj)
  (define updates (hash-ref updates-obj 'result))
  (if (empty? updates)
      #f
      (hash-ref (last updates) 'update_id)))

(define (get-chat-id update)
  (hash-get-path update '(message chat id)))

(define (get-text update)
  (hash-get-path update '(message text)))

;; Message
(define (make-message recipient message)
  `((chat_id . ,(~a recipient)) (text . ,(~a message))))