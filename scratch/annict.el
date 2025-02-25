(setq annict-token "w2CTj30liTLCucp-JAYGBmDn68QtbIphPGNB_uaamFs")

(defun send-request (path)
  "AnnictへAPIリクエストを送信する。pathの先頭にスラッシュは不要。"
  (let ((endpoint "https://api.annict.com/v1/"))
    (plz 'get (concat endpoint path)
      :headers `(("Authorization" . ,(concat "Bearer " annict-token)))
      :as #'json-read)))



(let* ((resp (send-request "me/works"))
       (works (cdr (assoc 'works resp)))
       (info (mapcar (lambda (work)
		       `((title . ,(cdr (assoc 'title work)))
			 (id . ,(cdr (assoc 'id work))))) works)))
  info
  )

(defun create-anime-timetable()
  (let* ((now (format-time-string "%Y/%m/%d %R"))
	 (resp (send-request (url-encode-url (concat "me/programs?filter_started_at_gt=" now))))
	 (programs (cdr (assoc 'programs resp))))
    (remove nil (mapcar (lambda (program)
			  (let ((episode (cdr (assoc 'episode program)))
				(work (cdr (assoc 'work program))))
			    (if (null episode)
				nil
			      (list (cdr (assoc 'title work))
				    (cdr (assoc 'title episode))
				    (cdr (assoc 'number_text episode))
				    (format-time-string "%Y/%m/%d (%a) %R" (encode-time (parse-time-string (cdr (assoc 'started_at program)))))
				    )
			      )

			    )) programs))
    ))



(let ((buffer (get-buffer-create "*annict*")))
  (save-current-buffer
    (set-buffer buffer)
    (setq tabulated-list-format
          [("番組名" 30 t)
           ("タイトル" 15 t)
           ("話" 10 t)
           ("放送日時" 10 t)
	   ]) 
    (setq tabulated-list-entries
	  (mapcar (lambda (item)
		    (list nil (vconcat item))) (create-anime-timetable))) 
    (tabulated-list-mode)
    (tabulated-list-init-header)
    (tabulated-list-print))
  (switch-to-buffer buffer)
  )



(let ((buffer (get-buffer-create "*tbl-test*"))) ; 新しいバッファを作成
  (save-current-buffer
    (set-buffer buffer)
    ;; tabulated-list-formatでカラムを定義
    (setq tabulated-list-format
          [("id" 3 t)
           ("name" 10 t)]) 
    (setq tabulated-list-entries
          '((nil ["1" "hoge"])
	    (nil ["2" "fuga"])))
    ;; tabulated-list-modeを有効にして、ヘッダーを初期化
    (tabulated-list-mode)
    (tabulated-list-init-header)
    (tabulated-list-print)
    )
  ;; 新しく作成したバッファを表示
  (switch-to-buffer buffer)
  )
