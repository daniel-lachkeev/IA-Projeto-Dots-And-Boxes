(defun breadth-first-search (graph start-node goal-node)
  (let ((queue (list start-node))
        (visited (list start-node)))
    (loop while queue
          do (let ((current (pop queue)))
               (when (equal current goal-node)
                 (return current))
               (loop for next in (neighbors current graph)
                     unless (member next visited)
                     do (progn (push next queue)
                               (push next visited)))))))

(defun neighbors (node graph)
  "Return a list of the neighbors of NODE in GRAPH."
  (cdr (assoc node graph)))


