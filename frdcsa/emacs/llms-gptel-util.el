;;;;;;;;;;;;;;;;;;;;
;; UTIL FUNCTIONS ;;
;;;;;;;;;;;;;;;;;;;;

(defun see (data &optional duration)
 ""
 (interactive)
 (message (prin1-to-string data))
 (sit-for (if duration duration 2.0))
 data)

(provide 'llms-gptel-util)
