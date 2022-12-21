(defun tabuleiro-teste ()
  "Retorna um tabuleiro 3x3 (3 arcos na vertical por 3 arcos na horizontal)
  1 caixa fechada"
	'(
		((0 0 0) (0 0 1) (0 1 1) (0 0 1))
		((0 0 0) (0 1 1) (1 0 1) (0 1 1))
	)
)

(defun tabuleiro-teste2 ()
  "Retorna um tabuleiro igual ao de cima mas com 5 caixas fechadas"
	'(
		((0 1 0) (0 1 1) (0 1 1) (0 1 1))
		((0 0 0) (1 1 1) (1 1 1) (0 1 1))
	)
)

(defun tabuleiro-teste3 ()
  "Retorna um tabuleiro igual ao de cima mas com 5 caixas fechadas"
	'(
		((1 1 0) (1 1 1) (1 1 1) (1 1 1))
		((0 0 0) (1 1 1) (1 1 1) (0 1 1))
	)
)

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
			(> x (length (car tabuleiro))) (> y (length (first (car tabuleiro)))) 
			(= (get-arco-na-posicao x y (car tabuleiro)) 1)) nil)
		(t (cons (arco-na-posicao x y (get-arcos-horizontais tabuleiro)) (cdr tabuleiro)))))

(defun arco-vertical (x y tabuleiro)
	(cond 
		((null tabuleiro) nil)
		((or (< x 1) (< y 1) 
			(> y (length (car tabuleiro))) (> x (length (second (car tabuleiro)))) 
			(= (get-arco-na-posicao y x (cadr tabuleiro)) 1)) nil)
		(t (cons (car tabuleiro) (arco-na-posicao y x (get-arcos-verticais tabuleiro))))))

;; x linha, y coluna
	;; Conta as linhas (x, y) (x+1, y), (y, x), (y+1,x) que existem ao redor de uma caixa
	;; Se for 4 retorna 1 (caixa fechada) caso contrário retorna 0
(defun caixa-fechada (x y tabuleiro)
	(cond
		((or (< x 1) (< y 1) (> y (1- (length (car tabuleiro)))) (> x (length (first (car tabuleiro))))) nil)
		((= (+ 
			(get-arco-na-posicao x y (car tabuleiro)) 
			(get-arco-na-posicao x (1+ y) (car tabuleiro)) 
			(get-arco-na-posicao y x (cadr tabuleiro)) 
			(get-arco-na-posicao y (1+ x) (cadr tabuleiro))) 4) 1)
		(t 0)))

;; logicamente começa-se a partir da última caixa mas conta a partir de qualquer
;; uma propagando-se até a primeira.
;; constraints: y >= 1 e x < length (car tabuleiro) - 1
;; 							x >= 1 e y < length (first (car tabuleiro))
(defun caixas-fechadas (x y tabuleiro)
  (cond 
  	((or (= x 1) (= y 1)) (caixa-fechada x y tabuleiro))
    ((< x y) (+ (caixa-fechada x y tabuleiro) (caixas-fechadas (1- x) y tabuleiro)))
    ((< y x) (+ (caixa-fechada x y tabuleiro) (caixas-fechadas x (1- y) tabuleiro)))
    (t (+ (caixa-fechada x y tabuleiro) 
    	(caixas-fechadas (1- x) (1- y) tabuleiro)
      (caixas-fechadas (1- x) y tabuleiro)
      (caixas-fechadas x (1- y) tabuleiro)))))

(defun n-caixas-fechadas(tabuleiro)
	(caixas-fechadas (1- (length (car tabuleiro))) (length (first (car tabuleiro))) tabuleiro))


