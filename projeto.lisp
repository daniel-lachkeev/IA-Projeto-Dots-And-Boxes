;; Menu Inicial
;; Gera o menu inicial do programa
(defun main-menu ()
  (format t "~%+-------------------------+~%")
  (format t "|       Dots & Boxes      |~%")
  (format t "+-------------------------+~%")
  (format t "| 2 - Vs Humano (Hotseat) |~%")
  (format t "| 1 - Vs CPU              |~%")
  (format t "| 0 - Sair                |~%")
  (format t "+-------------------------+~%~%")

  (format t "> ")
  (let ((option (read)))
    (cond ((or 
      (not (numberp option)) 
      (< option 0) (> option 2))
        (progn (format t "Opção inválida, escreva apenas um número inteiro entre 0 a 2~%") (main-menu)))
      ((= option 1) (vs-cpu))
      ((= option 2) (vs-human))
      (T (format t "Game Over!")))))

;; Menu Vs Human
(defun vs-human ())

;; Menu Vs CPU
(defun vs-cpu ())

;; Devolver um tabuleiro preparado para ser imprimido facilmente
(defun format-tabuleiro (tabuleiro)
  (list (car tabuleiro) (apply #'mapcar #'list (cadr tabuleiro)))
)

;; Usa-se "values" para não ter o NIL a mostrar no final.
(defun imprimir-tabuleiro (tabuleiro posicoes-caixas caixas-fechadas)
  (let ((horizontal-lines (car tabuleiro))
        (vertical-lines (cadr tabuleiro)))
    (cond ((and (null horizontal-lines) (null vertical-lines)) (values))
          (t (progn (imprimir-linha-horizontal (car horizontal-lines))
                    (imprimir-linha-vertical (car vertical-lines) (boxes-to-print (car posicoes-caixas) (car caixas-fechadas)))
                    (imprimir-tabuleiro (list (cdr horizontal-lines) (cdr vertical-lines)) (cdr posicoes-caixas) (cdr caixas-fechadas)))))))

;; Imprime o tabuleiro mostrando caixas que estão fechadas
;; 
(defun imprimir-tabuleiro-caixas (tabuleiro)
  (imprimir-tabuleiro (format-tabuleiro tabuleiro) (posicoes-caixas tabuleiro) (n-caixas-fechadas (posicoes-caixas tabuleiro) tabuleiro))
)

(defun imprimir-linha-horizontal (lista-arcos)
  (cond ((null lista-arcos) (format t "~%"))
         (t (format t "+~{~A~^+~}+~%" (mapcar (lambda (x) (if (eq x 1) "-" " ")) (convert-to-ones lista-arcos))))))

(defun imprimir-linha-vertical (lista-arcos boxes-to-print)
  (cond ((null lista-arcos) (format t "~%"))
        (t (format t "~{~A~}~%" (zigzag-pattern (mapcar (lambda (x) (if (eq x 1) "|" " ")) (convert-to-ones lista-arcos)) boxes-to-print)))))

;; Função auxiliar para preparar cada linha de tabuleiro para ser imprimida
(defun convert-to-ones (line)
  (mapcar (lambda (x) (if (/= x 0) 1 x)) line))

;; Função auxiliar para determinar que caixas que se deve imprimir
(defun boxes-to-print (posicoes-lista caixas-lista)
  (mapcar (lambda (x) (if (find x caixas-lista :test #'equal) "X" " ")) posicoes-lista))

;; Função auxiliar para combinar 2 listas em padrão zig-zague para ajudar a imprimir linhas com caixas
(defun zigzag-pattern (list1 list2)
  (cond ((and (null list1) (null list2)) '())
        ((null list1) (cons (car list2) (zigzag-pattern list1 (cdr list2))))
        ((null list2) (cons (car list1) (zigzag-pattern (cdr list1) list2)))
        (t (cons (car list1) (cons (car list2) (zigzag-pattern (cdr list1) (cdr list2)))))))