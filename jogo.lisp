(defvar *estado* (limpar-estado))
(defvar *jogador* 1)
(defvar *humano-jogador* 1)

(defun main-menu ()
;; Gera o menu inicial do programa onde se faz o arranque dos estados e variáveis
  (setf *estado* (limpar-estado))
  ;(setf *estado* (estado-teste))
  (format t "~%+-------------------------+~%")
  (format t "|       Dots & Boxes      |~%")
  (format t "+-------------------------+~%")
  (format t "| 2 - Jogar Vs CPU        |~%")
  (format t "| 1 - CPU Vs CPU          |~%")
  (format t "| 0 - Sair                |~%")
  (format t "+-------------------------+~%~%")

  (format t "> ")
  (let ((option (read)))
    (cond ((or 
      (not (numberp option)) 
      (< option 0) (> option 2))
        (progn (format t "Opção inválida, escreva apenas um número inteiro entre 0 a 2~%") (main-menu)))
      ((= option 1) (cpu-vs-cpu))
      ((= option 2) (player-vs-cpu))
      (T (format t "Game Over!")))))

;; Menu Vs Human
(defun player-vs-cpu ()
  ; Pedir o tempo ao jogador 
  ; X - (entre 1 e 20) tempo em milisegundos para o computador e em segundos para o jogador
  ; Pedir quem vai jogar primeiro, 1 - Humano primeiro, 2 - Humano segundo
  (let ((tempo (ler-input "Tempo de jogada (entre 1 e 20) em segundos para si e em ms para o computador: "))
        (jogador-primeiro (ler-input "Escolha se joga primeiro ou segundo (1/2): ")))
    (cond 
     ((or (null (integerp tempo)) (null (integerp jogador-primeiro))) (progn 
        (format t "Erro de input, verifique se está a inserir 2 números~%") 
        (player-vs-cpu)))
     ((or (< tempo 1) (> tempo 20) (< jogador-primeiro 1) (> jogador-primeiro 2)) (progn 
        (format t "Erro de validação, verifique se está a inserir o primeiro número de 1 a 20 e segundo número 1 ou 2~%") 
        (player-vs-cpu)))
     (t (progn 
          (setf *jogador* 1)
          (setf *humano-jogador* jogador-primeiro)
          (imprimir-estado *estado*)
  ; Loop principal do jogo
          (loop while (null (tabuleiro-preenchidop (car *estado*)))
                do (progn 
                     (jogar *estado*)
                     (imprimir-estado *estado*)))
          (fim-do-jogo *estado*)
          (values)
)))))

;; Menu Vs CPU
(defun vs-cpu ())

;; Equivalente a função input do python
(defun ler-input(texto)
  (progn
    (format t texto)
    (read))
)

(defun trocar-jogador (jogador)
  (+ (mod jogador 2) 1)
)

(defun proximo-jogador ()
  ;; Alterna entre jogador 1 e 2
  (setf *jogador* (trocar-jogador *jogador*))
)

;; Pede ao jogador um arco para meter no tabuleiro
;; Caso for inválido, continua a pedir até for válido
;; Devolve uma jogada válida
(defun ler-jogada (tabuleiro)
  (let ((x (ler-input "Insira coordenada x: "))
        (y (ler-input "Insira coordenada y: "))
        (arco (ler-input "Arco Horizontal ou Vertical? (H/V): ")))
    (cond 
     ((or (not (integerp x)) (not (integerp y)) (and (not (string-equal arco "H")) (not (string-equal arco "V"))))
      (progn 
        (format t "Erro de input, verifique se está a inserir 2 números e uma letra H ou V~%") 
        (ler-jogada tabuleiro)))
     ((and (string-equal arco "H") 
           (not (null (verificar-arcop x y (car tabuleiro))))) (list x y 'arco-horizontal))
     ((and (string-equal arco "V") 
           (not (null (verificar-arcop x y (cadr tabuleiro))))) (list x y 'arco-vertical))
     (t (progn
          (format t "Erro de jogada, a posição já se encontra preenchida ou está fora do tabuleiro~%") 
          (ler-jogada tabuleiro)))))
)

(defun atualizar-estado (estado-antigo estado-novo)
;; Atualiza a variável estado para um novo estado, fazendo também o incremento de pontuação caso o estado novo feche uma ou mais caixas também como a mudança de jogador num turno em que não se fechou nenhuma caixa
  (let ((caixas-antigo (n-contar-caixas (estado-tabuleiro estado-antigo)))
        (caixas-novo (n-contar-caixas (estado-tabuleiro estado-novo))))
    (progn
      (cond 
       ((= caixas-antigo caixas-novo) 
        (progn
          (proximo-jogador)
          (setf *estado* estado-novo)))
       (t (setf *estado* (estado-incrementar-caixas estado-novo (- caixas-novo caixas-antigo) *jogador*)))
))))


(defun jogada-humano (estado)
  (progn
    (let ((jogada (ler-jogada (car estado))))
      (atualizar-estado estado (aplicar-jogada estado jogada)))
    ;(imprimir-estado *estado*)
    (values)
))

(defun aplicar-jogada (estado jogada)
  (list (funcall (third jogada) (first jogada) (second jogada) (estado-tabuleiro estado) *jogador*) (second estado))
)

;; Devolve uma jogada aleatória para efeitos de teste
(defun jogada-aleatoria (estado)
  (let ((jogadas (sucessores-jogadas estado)))
    (progn
      (atualizar-estado estado (aplicar-jogada estado (nth (random (length jogadas)) jogadas)))
      ;(imprimir-estado *estado*)
      (values)
)))
      


;;Devolve uma lista em que o primeiro elemento é uma jogada realizada e o segundo elemento o novo estado
;;do jogo resultante da aplicação da jogada.
(defun jogar (estado)
  (cond
   ((and (= *jogador* 1) (= *humano-jogador* 1)) (jogada-humano estado))
   ((and (= *jogador* 2) (= *humano-jogador* 1)) (jogada-aleatoria estado))
   ((and (= *jogador* 1) (= *humano-jogador* 2)) (jogada-aleatoria estado))
   ((and (= *jogador* 2) (= *humano-jogador* 2)) (jogada-humano estado))
   (t nil)
  ; Verificar se o jogador atual é humano ou CPU
  ; Caso for humano, usar jogada-humano
  ; Caso for CPU, usar jogada-computador - alfa-beta e devolver a melhor jogada
  ; Se for CPU vs CPU os dois jogadores jogada-computador
))

(defun fim-do-jogo (estado)
  ;; Apresenta uma mensagem de fim do jogo indicando o resultado
  (let ((jogador-vencedor (estado-solucao estado)))
    (cond
     ((null jogador-vencedor) (format t "Erro!~%"))
     ((= jogador-vencedor 0) (format t "Fim do jogo! O resulado é um empate!~%" ))
     (t (format t "Fim do jogo! O vencedor é o Jogador ~a!~%" jogador-vencedor))
)))

(defun imprimir-estado (estado)
  (progn
    (imprimir-tabuleiro-caixas (car estado))
    (format t "Jogador 1 : ~a - ~a : Jogador 2~%" (first (second estado)) (second (second estado)))
    (format t "Agora é o turno de Jogador ~a!~%" *jogador*)
    (values))
)

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
;; Exemplo "| | | |   |" , "X X X X   " -> "|X|X|X|X|   |"
(defun zigzag-pattern (list1 list2)
  (cond ((and (null list1) (null list2)) '())
        ((null list1) (cons (car list2) (zigzag-pattern list1 (cdr list2))))
        ((null list2) (cons (car list1) (zigzag-pattern (cdr list1) list2)))
        (t (cons (car list1) (cons (car list2) (zigzag-pattern (cdr list1) (cdr list2)))))))
