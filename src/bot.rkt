#lang racket/base

(provide (struct-out bot)
         execute
         start-loop)

(require "telegram.rkt"
         "parse.rkt")

(require racket/list)

(struct bot (token db))

(define (execute bot command)
  (command (bot-token bot) (bot-db bot)))

(define (start-loop bot)
  (loop bot (get-initial-update-id bot)))

(define (loop bot update-id)
  (sleep 0.1)
  
  (define next-update-id update-id)
  
  (with-handlers ([exn:fail?
                   (λ (e)
                     (displayln e))])
    (define token (bot-token bot))
  
    (define updates-obj (get-updates token update-id))
    (define updates (hash-ref updates-obj 'result))
    (set! next-update-id (get-next-update-id updates-obj update-id))

    (unless (empty? updates)
      (for ([update updates])
        (define command (parse update))
        (when command 
          (execute bot command)))))

    (loop bot next-update-id))
  

(define (get-initial-update-id bot)
  (define token (bot-token bot))
  (define updates-obj (get-updates token 0))
  (get-next-update-id updates-obj 0))
