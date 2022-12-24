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

(defvar abertos '())
(defvar fechados '())

(defvar abertos-teste (list (no-teste (tabuleiro-teste2) 5)))
(defvar a (no-teste (tabuleiro-teste) 5))

(defun get-arcos-horizontais (tab)
  (car tab))

(defun get-arcos-verticais (tab)
  (cadr tab))

(defun get-arco-na-posicao (x y lista)
	(nth (1- x) 
		(nth (1- y) lista)))

(defun substituir (index list &optional (value 1))
  (cond
    ((= index 1) (cons value (cdr list)))
    (t (cons (car list) (substituir (- index 1) (cdr list) value)))))

(defun arco-na-posicao (x y list &optional (value 1))
  (cond
   ((null list) nil)
   ((= x 1) (cons (substituir y (car list) value) (cdr list)))
   (t (cons (car list) (arco-na-posicao (1- x) y (cdr list) value)))))

(defun arco-horizontal (x y tabuleiro)
	(cond 
		((null tabuleiro) nil)
		((or (< x 1) (< y 1) 
			(> x (length (first (car tabuleiro)))) (> y (length (car tabuleiro))) 
			(= (get-arco-na-posicao x y (car tabuleiro)) 1)) nil)
		(t (cons (arco-na-posicao y x (get-arcos-horizontais tabuleiro)) (cdr tabuleiro)))))

(defun arco-vertical (x y tabuleiro)
	(cond 
		((null tabuleiro) nil)
		((or (< x 1) (< y 1) 
			(> x (length (second (car tabuleiro)))) (> y (length (car tabuleiro))) 
			(= (get-arco-na-posicao x y (cadr tabuleiro)) 1)) nil)
		(t (cons (car tabuleiro) (arco-na-posicao y x (get-arcos-verticais tabuleiro))))))

; Verifica se uma caixa está fechada 
; Funciona só com linhas horizontais com exceção da última linha de linhas horizontais
; Conta as linhas (x, y) (x+1, y), (y, x), (y+1,x) que existem ao redor de uma caixa
; Se for 4 retorna 1 (caixa fechada) caso contrário retorna 0
(defun caixa-fechada (x y tabuleiro)
	(cond
		((or (< x 1) (< y 1) (> y (1- (length (car tabuleiro)))) (> x (length (first (car tabuleiro))))) nil)
		((= (+ 
			(get-arco-na-posicao x y (car tabuleiro)) 
			(get-arco-na-posicao x (1+ y) (car tabuleiro)) 
			(get-arco-na-posicao y x (cadr tabuleiro)) 
			(get-arco-na-posicao y (1+ x) (cadr tabuleiro))) 4) 1)
		(t 0)))

; Conta número de caixas fechadas no tabuleiro inteiro
; logicamente começa-se a partir da última caixa mas conta a partir de qualquer
; uma propagando-se até a primeira.
; constraints: y >= 1 e x < length (car tabuleiro) - 1
; 					   x >= 1 e y < length (first (car tabuleiro))
(defun caixas-fechadas (x y tabuleiro)
  (cond 
  	((or (= x 1) (= y 1)) (caixa-fechada x y tabuleiro))
    ((< x y) (+ (caixa-fechada x y tabuleiro) (caixas-fechadas (1- x) y tabuleiro)))
    ((< y x) (+ (caixa-fechada x y tabuleiro) (caixas-fechadas x (1- y) tabuleiro)))
    (t (+ (caixa-fechada x y tabuleiro) 
    	(caixas-fechadas (1- x) (1- y) tabuleiro)
      (caixas-fechadas (1- x) y tabuleiro)
      (caixas-fechadas x (1- y) tabuleiro)))))


; faz o mesmo da caixas-fechadas mas começa sempre a partir da última posição
(defun n-caixas-fechadas(tabuleiro)
	(caixas-fechadas (1- (length (car tabuleiro))) (length (first (car tabuleiro))) tabuleiro))

; Verifica se o tabuleiro corresponde à solução pretendida 
; Se tiver o número de caixas fechadas desejadas
(defun solucaop (tabuleiro objetivo-caixas)
  (cond
   ((= objetivo-caixas (n-caixas-fechadas tabuleiro)) t)
   (t nil)))

; conta nº de linhas de um tabuleiro
(defun n-linhas (tabuleiro)
	(cond
    ((null tabuleiro) 0)
    ((listp (car tabuleiro)) (+ (n-linhas (car tabuleiro)) (n-linhas (cdr tabuleiro))))
    (t (+ (car tabuleiro) (n-linhas (cdr tabuleiro))))))

; Heurística definida no enunciado
(defun base-heuristic (tabuleiro objetivo-caixas)
	(- objetivo-caixas (n-caixas-fechadas tabuleiro)))

; Nossa heurística
; O objetivo é ter em conta também o nº de linhas que foram colocadas
; Porque as jogadas que preencham muitas linhas mas que não fecham caixas
; com eficiência deverão ser mais penalizadas.
; Vamos partir do exemplo da figura 2 do enunciado
; Na solução há 5 caixas e 15 linhas portanto vamos assumir que existem em
; média 3 linhas por caixa. 
; Vamos agora supor que temos 3 caixas fechadas e 12 linhas ao meio do jogo
; O primeiro operador vai ser então (5-3)^3 = 8, e o segundo vai ser 
; |15 - 12| = 3 ; A heurística total vai ser 8 + 3 = 11.
; Agora vamos ver outro exemplo. Temos 1 caixa fechada e 15 linhas. Apesar de 
; nº linhas coincidir, a heurística vai ser limitada severamente pelo nº de caixas.
; (5-1)^3 + (|15-15|) = 64
; Basicamente quanto mais perto tivermos da solução, com menor número de jogadas
; menor é o valor da heurística ; Se estivermos numa jogada em que não há caixas 
; para fechar, todas as jogadas seguintes vao ter a mesma heurística
(defun my-heuristic (tabuleiro objetivo-caixas) 
	(+ 
		(expt (- objetivo-caixas (n-caixas-fechadas tabuleiro)) 3)
		(abs (- (* 3 objetivo-caixas) (n-linhas tabuleiro)))))

(defun operadores ()
 (list 'arco-horizontal 'arco-vertical))

(defun cria-no (tabuleiro objetivo-caixas &optional (profundidade 0) (pai nil) (heuristica 0))
  (list tabuleiro objetivo-caixas profundidade pai heuristica))

(defun no-teste (tabuleiro objetivo-caixas)
	(cond 
		((null tabuleiro) nil)
		(t (cria-no tabuleiro objetivo-caixas 0 nil (funcall #'base-heuristic tabuleiro objetivo-caixas)))))

(defun no-teste2 (tabuleiro objetivo-caixas)
	(cond 
		((null tabuleiro) nil)
		(t (cria-no tabuleiro objetivo-caixas 0 nil (funcall #'my-heuristic tabuleiro objetivo-caixas)))))

(defun no-estado (no)
	(first no))

(defun no-objetivo (no)
	(second no))

(defun no-profundidade (no)
	(third no))

(defun no-pai (no)
  (fourth no))

; Devolve o valor da heurística
(defun no-heuristica (no)
	(fifth no))

(defun no-custo(no)
	; Soma da profundidade e da heurística 
	(+ (no-profundidade no) (no-heuristica no)))

(defun calcular-heuristica (tabuleiro heuristicaf)
	(funcall heuristicaf tabuleiro (no-objetivo no)))

; Lista todas as posições das jogadas possíveis de fazer com linhas horizontais
; Pára quando não há mais elementos
; Vai para a próxima linha quando chegar ao fim da linha
; Se não houver linha (= 0), adiciona o x y atual às jogadas possíveis e passa para a frente
; Caso contrário, passa para a frente
(defun gerar-jogadas-horizontais (lista jogadas &optional (x 1) (y 1))	
  (cond
   ((null lista) jogadas)
   ((null (car lista)) (gerar-jogadas-horizontais (cdr lista) jogadas 1 (1+ y)))
   ((zerop (car (car lista))) 
   	(gerar-jogadas-horizontais (cons (cdar lista) (cdr lista)) (cons (list x y) jogadas) (1+ x) y))
   (t (gerar-jogadas-horizontais (cons (cdar lista) (cdr lista)) jogadas (1+ x) y))))

; Lista todas as posições das jogadas possíveis de fazer com linhas verticais
; Pára quando não há mais elementos
; Vai para a próxima coluna quando chegar ao fim da linha
; Se não houver linha (= 0), adiciona o x y atual às jogadas possíveis e passa para a frente
; Caso contrário, passa para a frente
(defun gerar-jogadas-verticais (lista jogadas &optional (x 1) (y 1))	
  (cond
   ((null lista) jogadas)
   ((null (car lista)) (gerar-jogadas-verticais (cdr lista) jogadas 1 (1+ y)))
   ((zerop (car (car lista))) 
   	(gerar-jogadas-verticais (cons (cdar lista) (cdr lista)) (cons (list x y) jogadas) (1+ x) y))
   (t (gerar-jogadas-verticais (cons (cdar lista) (cdr lista)) jogadas (1+ x) y))))

(defun novo-sucessor (no operador x y &optional (heuristica 0))
  (let ((novo-estado (funcall operador x y (no-estado no))))
    (cond ((null novo-estado) nil)
    	(t (cria-no 
    		novo-estado 
    		(no-objetivo no) 
    		(1+ (no-profundidade no)) 
    		no 
    		(+ (no-heuristica no) heuristica))))))

(defun sucessores-operador (jogadas no operador &optional (heuristica 0))
  (mapcar (lambda (coord) (novo-sucessor no operador (car coord) (cadr coord) heuristica)) jogadas))

(defun sucessores (no)
  (cond
   ((null no) nil)
   (t (append (sucessores-operador (gerar-jogadas-horizontais (car (no-estado no)) '()) a #'arco-horizontal)
              (sucessores-operador (gerar-jogadas-verticais (cadr (no-estado no)) '()) a #'arco-vertical)))))