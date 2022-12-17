;; Menu Inicial
;; Fun��o respons�vel por gerar o menu inicial da aplica��o.
(defun main-menu ()
  (format t "~%***************************~%")
  (format t "*       Dots & Boxes      *~%")
  (format t "***************************~%")
  (format t "* 1 - Escolher problema   *~%")
  (format t "* 0 - Fechar              *~%")
  (format t "***************************~%~%")

  (format t "Op��o > ")
  (let ((option (read)))
    (cond ((not (numberp option)) (format t "Valor inv�lido~%~%") (main-menu))
          ((= option 1) (problems-menu))
          (T (format t "Fim de jogo.")))))

;; Menu de Problemas
;; Fun��o respons�vel por gerar o menu para escolha do problema.
(defun problems-menu ()
  (format t "~%***************************~%")
  (format t "*         Problemas       *~%")
  (format t "***************************~%")
  (format t "* 1 - Escolher problema   *~%")
  (format t "* 0 - Voltar              *~%")
  (format t "***************************~%~%")

  (format t "Op��o > ")
  (let ((option (read)))
    (cond ((not (numberp option)) (format t "Valor inv�lido~%~%") (problems-menu))
          ((= option 1))
          ((= option 0) (main-menu))
          (T (format t "Fim de jogo.")))))

;; Menu de Algoritmos
;; Fun��o respons�vel por gerar o menu para escolha do algoritmo.
(defun algorithms-menu ()
  (format t "~%***************************~%")
  (format t "*        Algoritmos       *~%")
  (format t "***************************~%")
  (format t "* 1 - BFS                 *~%")
  (format t "* 2 - DFS                 *~%")
  (format t "* 3 - A*                  *~%")
  (format t "* 0 - Voltar              *~%")
  (format t "***************************~%~%")

  (format t "Op��o > ")
  (let ((option (read)))
    (cond ((not (numberp option)) (format t "Valor inv�lido~%~%") (algorithms-menu))
          ((= option 1))
          ((= option 0) (problems-menu))
          (T (format t "Fim de jogo.")))))

;; Menu de Profundidade (opcional)