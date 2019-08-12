#lang racket/base

(provide db-status
         db-init
         get-user-stats
         get-all-stats
         stats-user
         stats-lois
         stats-zashquor
         inc-stats-lois!
         inc-stats-zashquor!
         score)

(require db
         racket/math)

(define (db-init)
  (sqlite3-connect #:database (string->path "../codechan.sqlite3")))

(struct stats (user lois zashquor) #:transparent)
 
(define (get-user-stats db username)
  (define data (query-maybe-row db "select * from lois where user = $1" username))
  (if data
      (apply stats (vector->list data))
      (stats username 0 0)))

(define (get-all-stats db)
  (map (λ (row) (apply stats (vector->list row)))
       (query-rows db "select * from lois")))

(define (db-status db)
  (connected? db))

(define (inc-stats-lois! db username)
  (if (query-maybe-row db "select * from lois where user = $1" username)
      (query-exec db "update lois set lois = lois + 1 where user = $1" username)
      (query-exec db "insert into lois(user, lois, zashquor) values($1, 1, 0)" username)))

(define (inc-stats-zashquor! db username)
  (if (query-maybe-row db "select * from lois where user = $1" username)
      (query-exec db "update lois set zashquor = zashquor + 1 where user = $1" username)
      (query-exec db "insert into lois(user, lois, zashquor) values($1, 0, 1)" username)))
  
(define (score stats)
  (define k (/ (sqrt (+ (sqr (stats-lois stats))
                     (sqr (stats-zashquor stats))))
               100500))
  (* k (- (stats-lois stats)
          (* 0.96 (stats-zashquor stats)))))
