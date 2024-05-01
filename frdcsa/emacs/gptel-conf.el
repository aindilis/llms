(global-set-key "\C-clmgs" 'llms-gptel-set-model-claude-3-sonnet)
(global-set-key "\C-clmgo" 'llms-gptel-set-model-claude-3-opus)
(global-set-key "\C-clmgm" 'llms-gptel-set-model-mistral-7b-instruct)
(global-set-key "\C-clmgm" 'llms-gptel-set-model-mistral-7b-instruct)
(global-set-key "\C-clmgk" 'llms-gptel-emergency-kill-mistral)
(global-set-key "\C-clmgv" 'llms-gptel-see-or-view-current-model)

(load-if-exists "/home/andrewdo/.emacs.d-28.2/elpa/gptel-0.8.5/gptel.el")
;; (load-if-exists "/home/andrewdo/.emacs.d-28.2/elpa/gptel-0.8.5/gptel-curl.el")
;; (load-if-exists "/home/andrewdo/.emacs.d-28.2/elpa/gptel-0.8.5/gptel-org.el")
(load-if-exists "/home/andrewdo/.emacs.d-28.2/elpa/gptel-0.8.5/gptel-anthropic.el")
;; (load-if-exists "/home/andrewdo/.emacs.d-28.2/elpa/gptel-0.8.5/gptel-openai.el")

(require 'gptel)
;; (require 'gptel-curl)
;; (require 'gptel-org)
(require 'gptel-anthropic)
;; (require 'gptel-openai)

(gptel-make-openai "llama-cpp"          ;Any name
  :stream t                             ;Stream responses
  :protocol "http"
  :host "127.0.0.1:9001"                ;Llama.cpp server location
  :models '("test"))                    ;Any names, doesn't matter for Llama


;; (gptel-make-anthropic "Claude"          ;Any name you want
;;  :stream t                             ;Streaming responses
;;  :key "" 
;;  :models '("claude-3-opus-20240229"))

;; FIXME: have it double check before calling any API that costs money
;; or is insecure, have it specify the reason for the double check.

(defun llms-gptel-emergency-kill-mistral ()
 ""
 (interactive)
 (async-shell-command "killall-grep-nonroot mistral"))

(defun llms-gptel-see-or-view-current-model (&optional delay)
 ""
 (interactive)
 (see gptel-model nil))

(defun llms-gptel-set-model-mistral-7b-instruct ()
 ""
 (interactive)
 (setq
  gptel-model "mistral-7b-instruct"
  gptel-backend (gptel-make-openai "llama-cpp"
                 :stream t
                 :protocol "http"
                 :host "127.0.0.1:9001"
		 ;; :endpoint "/completion"
                 :models '("mistral-7b-instruct"))))

(defun llms-gptel-set-model-claude-3-sonnet ()
 ""
 (interactive)
 (setq
  gptel-model "claude-3-sonnet-20240229"
  gptel-backend (gptel-make-anthropic "Claude"
                 :stream t :key "<REDACTED>")))

(defun llms-gptel-set-model-claude-3-opus ()
 ""
 (interactive)
 (setq
  gptel-model "claude-3-opus-20240229" 
  gptel-backend (gptel-make-anthropic "Claude"
                 :stream t :key "<REDACTED>")))

(llms-gptel-set-model-mistral-7b-instruct)

(provide 'llms-gptel)

;; How does one switch which backend to use when using gptel? 

;; To switch the backend used by gptel in Emacs:

;; 1. Open the `gptel-config.el` file, usually located in `~/.emacs.d/gptel/`.

;; 2. Look for the line that sets the `gptel-backend` variable, e.g.:
;;    ```
;;    (setq gptel-backend 'openai)
;;    ```

;; 3. Change `'openai` to the desired backend symbol, e.g. `'anthropic` for Claude.

;; 4. Save the file.

;; 5. Restart Emacs for the changes to take effect.

;; The available backend options depend on what's supported by gptel. Common ones include `'openai` for OpenAI models and `'anthropic` for Anthropic's Claude. Check the gptel documentation for a full list of supported backends and their configuration.

;; ;; How does one switch which model to use when using gptel? 

;; To switch the model used by gptel in Emacs:

;; 1. Make sure you have configured the desired backend (e.g., OpenAI, Anthropic) in your `gptel-config.el` file or elsewhere in your Emacs configuration.

;; 2. Set the `gptel-model` variable to the name of the model you want to use. For example:
;;    ```elisp
;;    (setq gptel-model "claude-v1")
;;    ```
;;    Replace `"claude-v1"` with the name of the model you want to use.

;; 3. If you have multiple backends configured, you can also specify which backend to use by setting the `gptel-backend` variable. For example:
;;    ```elisp
;;    (setq gptel-backend (gptel-make-anthropic "Claude"
;;                           :stream t
;;                           :key "your-api-key"
;;                           :models '("claude-v1")))
;;    ```
;;    This sets the backend to Anthropic's Claude and specifies the model name and other options.

;; 4. After setting the `gptel-model` and/or `gptel-backend` variables, the specified model will be used for subsequent gptel commands and functions.

;; You can also define functions to quickly switch between different models or backends, like the `llms-gptel-set-model-claude-3-sonnet` and `llms-gptel-set-model-claude-3-opus` functions in your provided code.


(setq llms-free-models-alist '(("mistral-7b-instruct" . t) ("claude-3-sonnet-20240229" . nil) ("claude-3-opus-20240229" . nil)))
(setq llms-private-models-alist '(("mistral-7b-instruct" . t) ("claude-3-sonnet-20240229" . nil) ("claude-3-opus-20240229" . nil)))
(setq llms-gptel-model-default-max-region-length '(("mistral-7b-instruct" . 1000) ("claude-3-sonnet-20240229" . 200) ("claude-3-opus-20240229" . 100)))
(setq llms-gptel-model-absolute-max-region-length '(("mistral-7b-instruct" . 10000) ("claude-3-sonnet-20240229" . 1000) ("claude-3-opus-20240229" . 1000)))

(defun case-alist (key alist)
 ""
 (interactive)
 (cdr (assoc key alist)))

(defun llms-gptel-free-model-p (arg-gptel-model)
  ""
 (interactive)
 (case-alist arg-gptel-model llms-free-models-alist))

(defun llms-gptel-private-model-p (arg-gptel-model)
  ""
 (interactive)
 (case-alist arg-gptel-model llms-private-models-alist))

(defun llms-client-complete ()
 ""
 (interactive)
 (setq llms-gptel-warnings nil)
 (if (not (version<= "28.2" emacs-version))
  ;; (push "Not running a recent enough version of Emacs." llms-gptel-warnings))
  (error "ERROR: Not running a recent enough version of Emacs."))
 (if (not (region-active-p))
  ;; (push "Region not active." llms-gptel-warnings)
  (error "ERROR: Region not active."))
 (if (not (llms-gptel-region-shorter-than-absolute-max-region-length-p))
  (error "ERROR: Region is longer than absolute max region length for model." llms-gptel-warnings))

 (llms-gptel-see-or-view-current-model 1.0)

 (if (not (llms-gptel-region-shorter-than-default-max-region-length-p))
  (push "WARNING: Region is longer than default max region length for model." llms-gptel-warnings))
 (if (not (llms-gptel-free-model-p gptel-model))
  (push "WARNING: gptel-model is not free." llms-gptel-warnings))
 (if (not (llms-gptel-private-model-p gptel-model))
  (push "WARNING: gptel-model is not private." llms-gptel-warnings))
 ;; (llms-gptel-confirm-proceed "Region is shorter than default max region length: ")))
 (if (llms-gptel-confirm-proceed-past-warnings (reverse llms-gptel-warnings))
  (progn
   (see "DOING: (gptel-send)" 0.1)
   (gptel-send)
   )
  (error "NOT DOING: (gptel-send)")))

(defun llms-gptel-confirm-use-of-model (model message)
 ""
 (interactive)
 (llms-gptel-confirm-proceed
  (concat message " " gptel-model " - Proceed anyway?: ")))

(defun llms-gptel-region-shorter-than-default-max-region-length-p ()
 ""
 (interactive)
 (>
  (llms-gptel-default-max-region-length gptel-model)
  (length (buffer-substring-no-properties (point) (mark)))))

(defun llms-gptel-region-shorter-than-absolute-max-region-length-p ()
 ""
 (interactive)
 (>
  (llms-gptel-absolute-max-region-length gptel-model)
  (length (buffer-substring-no-properties (point) (mark)))))

(defun llms-gptel-confirm-proceed (message)
 ""
 (interactive)
 (y-or-n-p message))

(defun llms-gptel-default-max-region-length (arg-gptel-model)
 ""
 (case-alist arg-gptel-model llms-gptel-model-default-max-region-length))

(defun llms-gptel-absolute-max-region-length (arg-gptel-model)
 ""
 (case-alist arg-gptel-model llms-gptel-model-absolute-max-region-length))

;; (llms-gptel-default-max-region-length "claude-3-opus-20240229")

;; (llms-gptel-confirm-proceed "I'm a dork")

;; (llms-gptel-region-shorter-than-default-max-region-length-p)

;; (setq gptel-model "claude-3-opus-20240229")
;; (setq gptel-model "claude-3-sonnet-20240229")
;; (setq gptel-model "mistral-7b-instruct")

;; (llms-client-complete)

(defun llms-gptel-confirm-proceed-past-warnings (warnings)
 ""
 (if (> (length warnings) 0)
  (if (llms-gptel-confirm-proceed (concat (pop warnings) " Proceed?: "))
   (llms-gptel-confirm-proceed-past-warnings warnings)
   nil)
  t))

;; Please list all the websites you know of for looking for monthly rental apartments in the United States. 

;; Here are some popular websites for finding monthly rental apartments in the United States:

;; 1. Apartments.com
;; 2. Rent.com
;; 3. ApartmentGuide.com
;; 4. Zillow Rentals
;; 5. Trulia Rentals
;; 6. HotPads
;; 7.Padmapper
;; 8. Craigslist
;; 9. Apartment List
;; 10. Zumper
;; 11. ForRent.com
;; 12. RadPad
;; 13. RentCafe
;; 14. ApartmentFinder
;; 15. RentHop (mainly for major cities)

;; These websites allow you to search for rental listings by location, price range, number of bedrooms, and other filters. Many of them provide virtual tours, photos, and detailed information about available units.
