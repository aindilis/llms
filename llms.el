;; FIXME write a client launcher here instead:

(global-set-key "\C-clmas" 'llms-start)
(global-set-key "\C-clmaS" 'llms-stop)
(global-set-key "\C-clmax" 'llms-submit-file-or-region-to-llms-with-prefix-and-postfix)
(global-set-key "\C-clmaX" 'llms-submit-file-or-region-to-llms-with-prefix-and-postfix-preserving-whitespace-annotations)
(global-set-key "\C-clmao" 'llms-choose-llm)
(global-set-key "\C-clmaR" 'llms-hard-restart)
(global-set-key "\C-clmac" 'llms-count-tokens)
;; (global-set-key "\C-clmgk" 'llms-gptel-emergency-kill-mistral) ;; see gptel-conf.el 

(global-set-key "\C-clc" 'llms-client-complete)

;; (global-set-key "\C-cclaS" 'llms-server-start)

(if (version<= "28.2" emacs-version)
 (progn
  (load-if-exists "/var/lib/myfrdcsa/codebases/minor/llms/frdcsa/emacs/gptel-conf.el")
  (require 'llms-gptel)))

(defvar llms-buffer-name "*LLMs*")

(defvar llms-server-buffer-name "**LLMs Server*")

(defvar llms-current-engine-names (list "Mistral" "Mistral_20240410" "Carl" "Llemma" "Llama7bGsmProlog" "Meditron"))

(defvar llms-current-engine-name "Mistral_20240410")
;; (setq llms-current-engine-name "Llemma")

(defun llms-choose-llm ()
 ""
 (interactive)
 (setq llms-current-engine-name (completing-read-helm "Please chooose an LLM: " llms-current-engine-names)))

(defun llms-start (&optional arg)
 ""
 (interactive "P")
 (if (kmax-buffer-exists-p llms-buffer-name)
  (switch-to-buffer llms-buffer-name)
  (run-in-shell
   (concat
    "FRDCSA_DEFAULT_LLM_ENGINE_NAME="
    (shell-quote-argument llms-current-engine-name)
    (if arg
     " /var/lib/myfrdcsa/codebases/minor/llms/scripts/query-large-language-models--no-logging.pl -m "
     " /var/lib/myfrdcsa/codebases/minor/llms/scripts/query-large-language-models.pl -m ")
    (shell-quote-argument llms-current-engine-name))
   llms-buffer-name)))

(defun llms-stop ()
 ""
 (interactive)
 (if (kmax-buffer-exists-p llms-buffer-name)
  (progn
   (switch-to-buffer llms-buffer-name)
   (comint-interrupt-subjob)
   (cond ((string= llms-current-engine-name "Mistral")
	  (shell-command "/var/lib/myfrdcsa/codebases/internal/perllib/scripts/killall-grep-nonroot mistral-7b-instruct"))
    ((string= llms-current-engine-name "Carl")
	  (shell-command "/var/lib/myfrdcsa/codebases/internal/perllib/scripts/killall-grep-nonroot carl-llama")))
   (kill-buffer (get-buffer llms-buffer-name))
   )))

;; (defun llms-start ()
;;  ""
;;  (interactive)
;;  (if (kmax-buffer-exists-p llms-buffer-name)
;;   (switch-to-buffer llms-buffer-name)
;;   (run-in-shell
;;    "cd /var/lib/myfrdcsa/sandbox/llama.cpp-20230825/llama.cpp-20230825 && ./frdcsa.sh"
;;    llms-buffer-name)))

;; (defun llms-server-start ()
;;  ""
;;  (interactive)
;;  (if (kmax-buffer-exists-p llms-server-buffer-name)
;;   (switch-to-buffer llms-server-buffer-name)
;;   (run-in-shell
;;    "cd /var/lib/myfrdcsa/sandbox/llama.cpp-20230825/llama.cpp-20230825 && ./frdcsa-server.sh"
;;    llms-server-buffer-name)))

(defun llms-submit-file-or-region-to-llms-with-prefix-and-postfix-preserving-whitespace-annotations (&optional arg-contents)
 ""
 (interactive)
 ;; and finally add prefix and postfix
 (let* ((contents (or arg-contents (kmax-get-file-or-region-as-stomped-one-line-preserving-whitespace-annotations))))
  (llms-start)
  ;; (switch-to-buffer llms-buffer-name)
  (end-of-buffer)
  (insert contents)
  ;; (comint-send-input)
  ))

(defun llms-submit-file-or-region-to-llms-with-prefix-and-postfix (&optional arg-contents)
 ""
 (interactive)
 ;; and finally add prefix and postfix
 (let* ((contents (or arg-contents (kmax-get-file-or-region-as-stomped-one-line))))
  (llms-start)
  ;; (switch-to-buffer llms-buffer-name)
  (end-of-buffer)
  (insert contents)
  ;; (comint-send-input)
  ))

(defun llms-hard-restart ()
 ""
 (interactive)
 (llms-stop)

 ;; now stop start-rhasspy-helper dockers
 (shell-command "/var/lib/myfrdcsa/codebases/minor/rhasspy-frdcsa/scripts/stop-rhasspy")

 ;; doesn't seem to work in the script above, so manually invoking
 (rhasspy-helper-kill)

 ;; find all dependencies.

 ;; Make sure chrome, nvtop, mistral rhasspy-helpers, etc aren't
 ;; running
 (shell-command "sudo lsof | grep nvidia_uvm")

 ;; next, reload the nvidia_uvm module
 (shell-command "fix-nvidia-module.sh")
 ;; sudo rmmod nvidia_uvm; sudo modprobe nvidia_uvm")

 ;; now start start-rhasspy-helper screen sessions
 (shell-command "/var/lib/myfrdcsa/codebases/minor/rhasspy-frdcsa/scripts/start-rhasspy-helper")

 ;; restart rhasspy buffer
 (rhasspy-quick-start)

 (llms-start))

(defun llms-count-tokens ()
 ""
 (interactive)
 ;; region, file or buffer
 (let* ((tmp-filename "/tmp/count-tokens-helper")
	(filename (if (kmax-mode-is-derived-from 'dired-mode)
		   (dired-get-filename)
		   "/tmp/count-tokens"))
	(contents (if (kmax-mode-is-derived-from 'dired-mode)
		   (kmax-file-contents filename)
		   (if (not (equal (point) (mark)))
		    (buffer-substring-no-properties (point) (mark))
		    (kmax-buffer-contents)))))
  (kmax-write-string-to-file contents tmp-filename)
  (see
   (shell-command-to-string
    (concat
     "/var/lib/myfrdcsa/codebases/minor/llms/scripts/count-tokens.pl -f "
     (shell-quote-argument tmp-filename))))))

;; GPTEL specifics

;; see /var/lib/myfrdcsa/codebases/minor/llms/frdcsa/emacs/gptel-conf.el

(defun chomp (str)
 ;; from http://www.emacswiki.org/emacs/ElispCookbook
 "..."
 (let ((s (if (symbolp str) (symbol-name str) str)))
  (save-excursion
   (while (and
	   (not (null (string-match "^\\( \\|\f\\|\t\\|\n\\)" s)))
	   (> (length s) (string-match "^\\( \\|\f\\|\t\\|\n\\)" s)))
    (setq s (replace-match "" t nil s)))
   (while (and
	   (not (null (string-match "\\( \\|\f\\|\t\\|\n\\)$" s)))
	   (> (length s) (string-match "\\( \\|\f\\|\t\\|\n\\)$" s)))
    (setq s (replace-match "" t nil s))))
  s))

(add-to-list 'load-path (concat (chomp (shell-command-to-string "pwd")) "/frdcsa/emacs"))

(require 'llms-gptel-util)
