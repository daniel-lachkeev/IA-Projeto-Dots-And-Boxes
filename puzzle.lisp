(defun tabuleiro-teste ()
  "Retorna um tabuleiro 3x3 (3 arcos na vertical por 3 arcos na horizontal)
  1 caixa fechada, 10 arcos"
	'(
((0 0 0) (0 0 1) (0 1 1) (0 0 1))
((0 0 0) (0 1 1) (1 0 1) (0 1 1))
)
)

(defun tabuleiro-teste2 ()
  "Retorna um tabuleiro igual ao de cima mas com 5 caixas fechadas, 15 arcos"
	'(
		((0 1 0) (0 1 1) (0 1 1) (0 1 1))
		((0 0 0) (1 1 1) (1 1 1) (0 1 1))
	)
)

(defun tabuleiro-teste3 ()
  "Retorna um tabuleiro igual ao de cima, com 5 caixas fechadas, 19 arcos"
	'(
		((1 1 0) (1 1 1) (1 1 1) (1 1 1))
		((0 0 0) (1 1 1) (1 1 1) (0 1 1))
	)
)

(defun tabuleiro-teste4 ()
  "Retorna um tabuleiro exemplo 5x6, com 12 caixas fechadas, 51/71 arcos, 
20 jogadas possíveis, 12 horizontais e 8 verticais "
  "Figura 1 do enunciado"
 '(
(;arcos horizontais
(1 2 1 1 0 2)
(2 1 1 1 1 0)
(0 2 1 1 2 0)
(0 1 0 2 2 0)
(1 2 0 0 0 0)
(0 1 2 1 2 1)
)
(;arcos verticais
(1 0 1 0 0)
(2 1 1 2 2)
(2 1 1 2 0)
(1 2 2 1 1)
(1 2 2 0 0)
(0 1 2 1 2)
(2 2 1 2 0)
)
)
)

(defun tabuleiro-teste5 ()
  "Retorna um tabuleiro exemplo 5x6, com todas as caixas fechadas, 71 arcos"
 '(
(;arcos horizontais
(1 2 1 1 1 2)
(2 1 1 1 1 1)
(1 2 1 1 2 1)
(1 1 1 2 2 1)
(1 2 1 1 1 1)
(1 1 2 1 2 1)
)
(;arcos verticais
(1 1 1 1 1)
(2 1 1 2 2)
(2 1 1 2 1)
(1 2 2 1 1)
(1 2 2 1 1)
(1 1 2 1 2)
(2 2 1 2 1)
)
)
)

(defun estado-teste()
  "Retorna um estado faltando com uma jogada restante"
'((((0 1 1 1 1 2) (1 2 1 1 1 1) (1 1 2 1 2 1) (1 1 1 1 2 1) (2 2 2 1 2 2) (2 1 1 1 1 2)) ((1 2 1 2 1) (1 1 2 1 1) (1 1 1 2 1) (2 2 1 2 2) (1 2 2 1 2) (1 1 1 2 2) (1 2 1 1 1))) (0 1))
)

;; Função que gera um tabuleiro de qualquer tamanho
;; O tabuleiro vai ter n x m caixas.
;; Para n = 5, m = 6, deve gerar 6x6 + 7x5 arcos, 71 arcos
(defun tabuleiro (n m)
  (list (arcos m (1+ n)) (arcos n (1+ m))))

(defun arcos (n m)
  (cond ((= m 0) '())
        (t (cons (linha-arcos n) (arcos n (1- m))))))

(defun linha-arcos (n)
  (cond ((= n 0) '())
        (t (cons 0 (linha-arcos (1- n))))))

(defun tabuleiro-30-caixas ()
	(tabuleiro 5 6))

(defun get-arcos-horizontais (tab)
  (car tab))

(defun get-arcos-verticais (tab)
  (cadr tab))

(defun get-arco-na-posicao (x y lista)
	(nth (1- y) 
		(nth (1- x) lista)))

;; função usada para normalizar valores do tabuleiro para um valor só
;; Verificar se uma caixa está fechada não depende do outro jogador
(defun get-arco-na-posicao2 (x y lista)
  (let ((value (nth (1- y) (nth (1- x) lista))))
    (cond 
     ;((null value) nil)
     ((/= value 0) 1)
     (t 0))))

(defun substituir (index list &optional (value 1))
  (cond
    ((= index 1) (cons value (cdr list)))
    (t (cons (car list) (substituir (- index 1) (cdr list) value)))))

(defun arco-na-posicao (x y list &optional (value 1))
  (cond
   ((null list) nil)
   ((= x 1) (cons (substituir y (car list) value) (cdr list)))
   (t (cons (car list) (arco-na-posicao (1- x) y (cdr list) value)))))

(defun verificar-arcop (x y lista-arcos)
  ;; Verifica se é possível colocar um arco numa certa posição
  ;; lista-arcos é uma lista de arcos horizontais ou verticais de um tabuleiro
  (cond 
   ((null lista-arcos) nil)
   ((or (< x 1) (< y 1) 
        (> x (length lista-arcos)) (> y (length (first lista-arcos))) 
        (/= (get-arco-na-posicao2 x y lista-arcos) 0)) nil)
   (t t))
)

(defun arco-horizontal (x y tabuleiro &optional (jogador 1))
	(cond 
		((null tabuleiro) nil)
		((null (verificar-arcop x y (car tabuleiro))) nil)
		(t (cons (arco-na-posicao x y (get-arcos-horizontais tabuleiro) jogador) (cdr tabuleiro)))))

(defun arco-vertical (x y tabuleiro &optional (jogador 1))
	(cond 
		((null tabuleiro) nil)
		((null (verificar-arcop x y (cadr tabuleiro))) nil)
		(t (list (car tabuleiro) (arco-na-posicao x y (get-arcos-verticais tabuleiro) jogador)))))


; Devolve todas as posições possíveis apartir dos arcos horizontais
; No formato de ((1 1) (1 2) (1 3) (2 1) etc )
(defun criar-posicoes (arcos-horizontais &optional (x 1) (y 1))
  (cond 
   ((null arcos-horizontais) nil)
   ((listp (car arcos-horizontais)) (cons (criar-posicoes (car arcos-horizontais) x y) (criar-posicoes (cdr arcos-horizontais) (1+ x) y))) 
   (t (cons (list x y) (criar-posicoes (cdr arcos-horizontais) x (1+ y) )))))

; Devolve todas as posições que estão preparadas para a contagem de caixas
; Função auxiliar para determinar as caixas fechadas
(defun posicoes-caixas (tabuleiro)
  (criar-posicoes (butlast (car tabuleiro)))
)

;; Verifica se uma caixa está fechada 
;; Funciona só com linhas horizontais com exceção da última linha de linhas horizontais
;; Conta as linhas (x, y) (x+1, y), (y, x), (y+1,x) que existem ao redor de uma caixa
;; Se a soma for 4 retorna 1 (caixa fechada) caso contrário retorna 0
;; Se estiver fora dos limites do tabuleiro, devolve nil
(defun caixa-fechada (x y tabuleiro &optional (n-arcos 4))
    (cond
        ((or (< x 1) (< y 1) (> y (length (first (car tabuleiro)))) (> x (1- (length (car tabuleiro))))) nil)
        ((= (+ 
            (get-arco-na-posicao2 x y (car tabuleiro))
            (get-arco-na-posicao2 (1+ x) y (car tabuleiro)) 
            (get-arco-na-posicao2 y x (cadr tabuleiro)) 
            (get-arco-na-posicao2 (1+ y) x (cadr tabuleiro))) n-arcos) 1)
        (t 0)))

;; Devolve uma lista contendo as posições baseados em arcos horizontais 
;; onde representam uma caixa fechada
(defun caixas-fechadas (positions tabuleiro &optional (n-arcos 4))
  (remove-if (lambda (posicao)
               (let ((x (first posicao))
                     (y (second posicao)))
               (= (caixa-fechada x y tabuleiro n-arcos) 0)))
           positions))

(defun n-caixas-fechadas (positions tabuleiro &optional (n-arcos 4))
  (cond ((null positions) nil)
        ((listp (car positions)) (cons (caixas-fechadas (car positions) tabuleiro n-arcos) (n-caixas-fechadas (cdr positions) tabuleiro n-arcos)))
        (t (caixas-fechadas positions tabuleiro n-arcos))))

(defun contar-caixas (caixas-fechadas)
  (cond ((null caixas-fechadas) 0)
        ((listp (car caixas-fechadas)) (+ (length (car caixas-fechadas)) (contar-caixas (cdr caixas-fechadas))))
        (t (contar-caixas (cdr caixas-fechadas)))))

(defun n-contar-caixas (tabuleiro)
  (contar-caixas (n-caixas-fechadas (posicoes-caixas tabuleiro) tabuleiro)))

(defun n-caixas-quase-fechadas (tabuleiro)
  (contar-caixas (n-caixas-fechadas (posicoes-caixas tabuleiro) tabuleiro 3))
)

(defun n-caixas-semi-fechadas (tabuleiro)
   (contar-caixas (n-caixas-fechadas (posicoes-caixas tabuleiro) tabuleiro 2))
)

(defun n-caixas-pouco-fechadas (tabuleiro)
  (+ 
   (contar-caixas (n-caixas-fechadas (posicoes-caixas tabuleiro) tabuleiro 0))
   (contar-caixas (n-caixas-fechadas (posicoes-caixas tabuleiro) tabuleiro 1))
))

(defun operadores ()
 (list 'arco-horizontal 'arco-vertical))

(defun no-teste () 
  (cria-no-alphabeta (criar-estado (tabuleiro-teste4)) 20)
)

(defun no-estado (no)
	(first no))

(defun no-tabuleiro (no)
  (first (no-estado no))
)

; Lista todas as posições das jogadas possíveis de fazer com uma das listas de arcos
; Pára quando não há mais elementos
; Vai para a próxima linha quando chegar ao fim da linha
; Se não houver linha (= 0), adiciona o x y atual às jogadas possíveis e passa para a frente
; Caso contrário, passa para a frente
(defun gerar-jogadas (lista jogadas &optional (x 1) (y 1))	
  (cond
   ((null lista) jogadas)
   ((null (car lista)) (gerar-jogadas (cdr lista) jogadas 1 (1+ y)))
   ((zerop (car (car lista))) 
   	(gerar-jogadas (cons (cdar lista) (cdr lista)) (cons (list y x) jogadas) (1+ x) y))
   (t (gerar-jogadas (cons (cdar lista) (cdr lista)) jogadas (1+ x) y))))

(defun novo-sucessor (no operador x y jogador)
  (let ((novo-tabuleiro (funcall operador x y (no-tabuleiro no) jogador)))
    (cond ((null novo-tabuleiro) nil)
    	(t (cria-no-alphabeta 
    		(list novo-tabuleiro (second (first no))) 
    		(1+ (no-profundidade no)) 
    		no)
))))


(defun sucessores-operador (jogadas no operador jogador)
  (mapcar (lambda (coord) (novo-sucessor no operador (car coord) (cadr coord) jogador)) jogadas)
)

(defun sucessores-alphabeta (no jogador)
  (cond
   ((null no) nil)
   (t (append 
       (sucessores-operador (gerar-jogadas (get-arcos-horizontais (no-tabuleiro no)) '()) no #'arco-horizontal jogador)
       (sucessores-operador (gerar-jogadas (get-arcos-verticais (no-tabuleiro no)) '()) no #'arco-vertical jogador)
))))

(defun sucessores-jogadas (estado)
  (cond
   ((null estado) nil)
   (t (append (mapcar (lambda (sublist) (append sublist (list 'arco-horizontal))) (gerar-jogadas (get-arcos-horizontais (estado-tabuleiro estado)) '())) (mapcar (lambda (sublist) (append sublist (list 'arco-vertical))) (gerar-jogadas (get-arcos-verticais (estado-tabuleiro estado)) '()))))
))

;; Funções específicas a Parte 2 do Projeto

;; Cria estado vazio representado o progresso do jogo
(defun criar-estado (tabuleiro)
  (list tabuleiro '(0 0))
)

;; Devolve o tabuleiro do estado
(defun estado-tabuleiro (estado) 
  (car estado)
)

;; Devolve a quantidade de caixas fechadas pelo jogador 1
(defun estado-caixas-jogador1 (estado)
  (first (second estado))
)

;; Devolve a quantidade de caixas fechadas pelo jogador 2
(defun estado-caixas-jogador2 (estado)
  (second (second estado))
)

;; Incrementa o nº de caixas fechadas do jogador 1 por x caixas
(defun estado-incrementar-caixas-jogador1 (estado caixas)
  (list (estado-tabuleiro estado) (list (+ (estado-caixas-jogador1 estado) caixas) (estado-caixas-jogador2 estado)))
)

;; Incrementa o nº de caixas fechadas do jogador 2 por x caixas 
(defun estado-incrementar-caixas-jogador2 (estado caixas)
  (list (estado-tabuleiro estado) (list (estado-caixas-jogador1 estado) (+ (estado-caixas-jogador2 estado) caixas)))
)

(defun estado-incrementar-caixas (estado caixas jogador)
  (cond
   ((= jogador 1) (estado-incrementar-caixas-jogador1 estado caixas))
   ((= jogador 2) (estado-incrementar-caixas-jogador2 estado caixas))
   (t nil)
))

(defun estado-resultado (estado)
  ;; Indica o jogador que ganhou tendo em conta a pontuação atual
  ;; 1 - Jogador1 ganhou, 2 - Jogador2 ganhou, 0 - Empate
  (let ((resultado (second estado)))
    (cond
     ((> (first resultado) (second resultado)) 1)
     ((< (first resultado) (second resultado)) 2)
     (t 0)))
)


(defun limpar-estado ()
  (criar-estado (tabuleiro 5 6))
)

; Verifica se o tabuleiro encontra-se cheio 
; Se preencher todas as linhas do tabuleiro
(defun tabuleiro-preenchidop (tabuleiro)
  (cond
   ((>= (n-linhas tabuleiro) (linhas-max tabuleiro)) t)
   (t nil)))

(defun estado-solucao (estado)
  ;; Verifica se o jogo terminou dando a indicação do jogador que ganhou
  (cond
   ((null estado) nil)
   ((tabuleiro-preenchidop (estado-tabuleiro estado)) (estado-resultado estado))
   (t nil))
)

;; Devolve o nº de linhas máximas que poderão haver num tabuleiro
(defun linhas-max (tabuleiro)
  (cond 
   ((null tabuleiro) 0)
   ((listp (caar tabuleiro)) (+ (linhas-max (car tabuleiro)) (linhas-max (cdr tabuleiro))))
   ((listp (car tabuleiro)) (+ (length (car tabuleiro)) (linhas-max (cdr tabuleiro))))
   (t 0)))

; conta nº de linhas preenchidas de um tabuleiro
(defun n-linhas (tabuleiro)
  (cond
   ((null tabuleiro) 0)
   ((listp (car tabuleiro)) (+ (n-linhas (car tabuleiro)) (n-linhas (cdr tabuleiro))))
   (t (+ (car (convert-to-ones tabuleiro)) (n-linhas (cdr tabuleiro))))))


(defun avaliacao (no)
  "Função que avalia o estado do tabuleiro dando importância ao número de caixas que são possíveis de serem fechadas no estado atual. Quanto maior for o número, maior é a avaliação.
   O ideaia é maximizar o nº de caixas prontas para fechar para o jogador atual e minimiza-las ao outro jogador também como minimizar jogadas que dão origem a caixas quase fechadas para o outro jogador"
  (- (* 10 (n-caixas-quase-fechadas (no-tabuleiro no))) (n-caixas-semi-fechadas (no-tabuleiro no)))
)