#lang racket/base

(provide (all-defined-out))

(require racket/list
         racket/port
         racket/date
         net/url)
;; Net
(define (url-open url)
  (let* ([input (get-pure-port (string->url url) #:redirections 5)]
         [response (port->string input)])
    (close-input-port input)
    response))

;; Date
(date-display-format 'rfc2822)

(define (current-date->string)
  (date->string (seconds->date (current-seconds)) #t))

;; Hash
(define (hash-get-path h path)
  (cond
    [(empty? path) h]
    [(not (hash? h)) #f]
    [(hash-has-key? h (first path)) (hash-get-path (hash-ref h (first path))
                                                   (rest path))]
    [else #f]))
