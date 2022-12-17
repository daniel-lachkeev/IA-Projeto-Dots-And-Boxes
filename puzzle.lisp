(defun tabuleiro-teste ()
  "Retorna um tabuleiro 3x3 (3 arcos na vertical por 3 arcos na horizontal)"
	'(
		((0 0 0) (0 0 1) (0 1 1) (0 0 1))
		((0 0 0) (0 1 1) (1 0 1) (0 1 1))
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