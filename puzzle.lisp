(defun arco-vertical (x y tabuleiro)
	(setf (nth (- x 1) (nth (- y 1) (second tabuleiro))) 1)
	  tabuleiro)

(defun arco-horizontal (x y tabuleiro)
	(setf (nth (- x 1) (nth (- y 1) (first tabuleiro))) 1)
	  tabuleiro)

(defun arco-vertical2 (x y tabuleiro)
  (let ((sub-list (nth (1- y) (second tabuleiro))))
    (if and (and sub-list (>= y 1) (<= y (length sub-list)) 
       		(and sub-list (>= x 1) (<= x (length first tabuleiro))))
        (progn
          (setf (nth (1- x) sub-list) 1)
          tabuleiro)
        (error "Posição Errada"))))
