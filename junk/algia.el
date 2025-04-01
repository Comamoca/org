(defun algia--send-reaction (arg)
  (message "Send reaction"))


(insert-text-button "Like"
		    'action 'algia--send-reaction
		    'follow-link t)



(defun insert-horizonal-line ()
  (interactive)
  (insert (make-string (window-width) ?─)))


(with-current-buffer (get-buffer-create "*algia*"))

(defun algia--like (id emoji))

(make-process
             :name "algia-like"
             :buffer (get-buffer-create "*algia-like*")
             :command '("algia" "like" "--id" id "--emoji" "♥️")
             ;; :sentinel (lambda (proc event)
             ;;             (message "Process %s: %s" proc event)))))
  (message "Started process: %s" proc))

(setq json-data "{\"kind\":1,\"id\":\"68b50df38d6a5490c5e258787aa6a3d52b9f73b2d4820f618815deba2ea32fd2\",\"pubkey\":\"21ac29561b5de90cdc21995fc0707525cd78c8a52d87721ab681d3d609d1e2df\",\"created_at\":1742320324,\"tags\":[[\"e\",\"13bdfceb5d48f45052cf3f2c7ed6379db62e2fbd95af52dc337bc9d8c15d034e\",\"\",\"root\"],[\"p\",\"8949de6098740431d2e50166f6e65a4c109326ca37e66fd74e42c037b3882ba7\"],[\"p\",\"21ac29561b5de90cdc21995fc0707525cd78c8a52d87721ab681d3d609d1e2df\"]],\"content\":\"おやすみ\",\"sig\":\"e95490c579c3b24331197d946b40847b05f917ae90149bc7d3301dee9580d631ea5d0c3a8e720be52e2f4e3d9e3a3563c31432deff9f2b6dcb5e7561c48da1b0\"}")


(let-alist (json-parse-string json-data :object-type 'alist)
;; .created_at
;; .pubkey
;; .content
  (message (format "%s" .content)))




(defun algia--post (content)
  (let ((proc (make-process
	       :name "algia-post"
	       :buffer (get-buffer-create "*algia-post*")
	       :command '("algia" "post" "--stdin")
	       :connection-type 'pipe)))
    (process-send-string proc content)
    (process-send-eof proc)))

(defun algia-post ()
  (interactive)
  (algia--post (read-string "algia post > ")))

(defun algia--submit-input ()
  (interactive)
  (let ((input (buffer-string)))
    ;; (message "Received input: %s" input)
    (algia--post input)
    (kill-buffer-and-window)))

(defun algia-post-buffer ()
  (interactive)
  (let* ((buffer (generate-new-buffer "*multi-line-input*"))
	 (window (display-buffer-in-side-window
		  buffer
		  '((side . bottom) (window-height . 10)))))
    (select-window window)

    (with-current-buffer buffer
      (erase-buffer)
      (text-mode)
      (local-set-key (kbd "C-c C-c") #'algia--submit-input))))
