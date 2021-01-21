
(module inline '#%kernel
  (#%require (for-syntax '#%kernel))
  (#%provide begin-encourage-inline
             app-discourage-inline)

  ;; Attach a property to encourage the bytecode compiler to inline
  ;; functions:
  (define-syntaxes (begin-encourage-inline)
    (lambda (stx)
      (let-values ([(l) (syntax->list stx)])
        (if l
            (datum->syntax
             stx
             (cons
              (quote-syntax begin)
              (map
               (lambda (form)
                 (syntax-property form
                                  'compiler-hint:cross-module-inline 
                                  #t))
               (cdr l)))
             stx
             stx)
            (raise-syntax-error #f "bad syntax" stx)))))

  (define-syntaxes (app-discourage-inline)
    (lambda (stx)
      (let-values ([(l) (syntax->list stx)])
        (if l
            (syntax-property (datum->syntax stx (cdr l) stx stx)
                             'compiler-hint:app-no-inline
                             #t)
            (raise-syntax-error #f "bad syntax" stx))))))
