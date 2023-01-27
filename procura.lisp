;; Implementado por Rafael Palma
;; Adaptado por Daniel Lachkeev

(defun cria-no-alphabeta (estado &optional (profundidade 0) (pai NIL) (alfa most-negative-double-float) (beta most-positive-double-float))
  (list estado alfa beta profundidade pai))

(defun no-pai (no) (car (cddddr no)))

(defun no-alpha (no) (cadr no))

(defun no-beta (no) (caddr no))

(defun no-profundidade (no) (cadddr no))

(defun alpha-beta (no profundidade-maxima jogador)
  (let* ((enemy (trocar-jogador jogador)))
    (labels ((maximize (sucessores alpha beta profundidade adversario)
               (if (null sucessores)
                   alpha
                 (let* ((no (car sucessores))
                        (alpha (max alpha (iter no (+ profundidade 1) alpha beta adversario))))
                   (if (<= beta alpha)
                       alpha
                     (maximize (cdr sucessores) alpha beta profundidade adversario)))))
             (minimize (sucessores alpha beta profundidade adversario)
               (if (null sucessores)
                   beta
                 (let* ((no (car sucessores))
                        (beta (min alpha (iter no (+ profundidade 1) alpha beta adversario))))
                   (if (<= beta alpha)
                       beta
                     (minimize (cdr sucessores) alpha beta profundidade adversario)))))
             (iter (no profundidade
                       &optional (alpha most-negative-double-float) (beta most-positive-double-float) adversario)
               (let ((novos-sucessores (sucessores-alphabeta no))
                     (solucao (estado-solucao (no-tabuleiro no))))
                 (cond ((null novos-sucessores) 0)
                       ((and (not (null solucao)) (= solucao jogador)) 9999)
                       ((and (not (null solucao)) (= solucao adversario)) (- 9999))
                       ((= profundidade profundidade-maxima) (avaliacao no))
                       ((/= jogador enemy)
                        (maximize novos-sucessores alpha beta profundidade (trocar-jogador jogador)))
                       (t (minimize novos-sucessores alpha beta profundidade jogador))))))
      (iter no 0))))