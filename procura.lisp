; Feito com ajuda de um colega que já fez IA
(defun novo-sucessor (teste x)
  (let ((novo-estado (funcall x (no-estado teste))))
    (cond ((null novo-estado) nil)
          (t (list novo-estado (1+ (no-profundidade teste)) teste)))))

(defun sucessores (no operadores algoritmo &optional profundidade)
  (cond ((and profundidade (eq algoritmo 'dfs) (>= (nivel-no no) profundidade)) nil)
        (t (remove nil
            (mapcar #'(lambda (operador) (novo-sucessor no operador)) operadores)))))

(defun nivel-no (no)
  (cadr no))

(defun abertos-bfs (abertos sucessores)
  (append abertos sucessores))

(defun abertos-dfs (abertos sucessores)
  (append sucessores abertos))

(defun no-existep (no lista algoritmo)
  (cond ((null lista) nil)
        ((and (or (eq algoritmo 'bfs) (<= (nivel-no (car lista)) (nivel-no no)))
              (equal (no-estado (car lista)) (no-estado no))) t)
        (t (no-existep no (cdr lista) algoritmo))))

(defun bfs (no-inicial objetivop sucessoresf operadores &optional abertos fechados)
  (if (funcall objetivop no-inicial)
      no-inicial
      (let ((nos-succ (remove-if #'(lambda (x) (or (no-existep x abertos 'bfs)
                                                   (no-existep x fechados 'bfs)))
                                 (funcall sucessoresf
                                          no-inicial operadores 'bfs))))
        (cond ((and (null nos-succ) (null abertos)) nil)
              ((null abertos)
               (bfs (car nos-succ) objetivop sucessoresf operadores
                    (cdr nos-succ) (cons no-inicial fechados)))
              (t (bfs (car abertos) objetivop sucessoresf operadores
                      (abertos-bfs (cdr abertos) nos-succ)
                      (cons no-inicial fechados)))))))

(defun dfs (no-inicial objetivop sucessoresf operadores profundidade
            &optional (abertos nil) (fechados nil))
  (if (funcall objetivop no-inicial)
      no-inicial
      (let ((nos-succ (remove-if #'(lambda (x) (or (no-existep x abertos 'dfs)
                                                   (no-existep x fechados 'dfs)))
                                 (funcall sucessoresf
                                          no-inicial operadores 'dfs profundidade))))
        (cond ((and (null nos-succ) (null abertos)) nil)
              ((null nos-succ)
               (dfs (car abertos) objetivop sucessoresf operadores
                    profundidade (cdr abertos) (cons no-inicial fechados)))
              (t (dfs (car nos-succ) objetivop sucessoresf operadores
                      profundidade (abertos-dfs abertos (cdr nos-succ))
                      (cons no-inicial fechados)))))))


