(setq bsky-tl-cmd '("bsky" "tl" "--json"))
(setq bsky-tl-json (shell-command-to-string (mapconcat #'shell-quote-argument bsky-tl-cmd " ")))
(setq bsky-posts-str (cl-remove-if (lambda (x)
				 (zerop (length x))) (split-string bsky-tl-json "\n")))
(setq bsky-posts (mapcar (lambda (post)
			   (json-parse-string post :object-type 'alist)) bsky-posts-str))

;; アクセスを抑えるためにキャッシュさせる
;; 更新時にはこの変数も更新する
(setq bsky-tl-data nil)


(defun fetch-tl-data ()
  "TLのデータを取得する。取得したデータはbsky-tl-dataにも格納される。通常はそちらの値を参照する。"
  (let* ((cmd (mapconcat #'shell-quote-argument '("bsky" "tl" "--json") " "))
	 (tl-json (async-shell-command cmd))
	 (posts-str (cl-remove-if (lambda (x)
				    (zerop (length x))) (split-string bsky-tl-json "\n")))
	 (bsky-posts (reverse
		      (mapcar (lambda (post)
				(json-parse-string post :object-type 'alist)) bsky-posts-str))))
    (setq bsky-tl-data bsky-posts)
    bsky-posts))

(defun date-format (date)
  (let* ((min (nth 1 date))
	 (hour (nth 2 date))
	 (day (nth 3 date))
	 (mon(nth 4 date))
	 (year (nth 5 date)))
    (format "%s/%s/%s %s:%s" year mon day hour min)))

(defun bsky-tl-string ()
  (mapcar (lambda (post)
	    (let-alist post
	      (format "%s (@%s) %s\n%s\n     ━━━━━━━━━━  👍(%s) 💭(%s) 💬(%s) 🔁(%s)"
		      .post.author.displayName
		      .post.author.handle
		      (date-format (parse-time-string .post.author.createdAt))
		      .post.record.text
		      .post.likeCount
		      .post.quoteCount
		      .post.replyCount
		      .post.repostCount))) bsky-tl-data))


(defun bsky-tl ()
  (with-current-buffer (get-buffer-create "*Bluesky*")
    (insert (mapconcat #'identity (bsky-tl-string) "\n"))))

(fetch-tl-data)
(bsky-tl)


(defun bsky-post (text)
  "与えられた文字列をポストする。stdinを使用していないので長文投稿は支障が出る可能性がある。"
  (async-shell-command
   (build-command-string (mapconcat #'shell-quote-argument `("bsky" "post" ,text) " "))))

(defun bsky-post-with-input ()
  "ミニバッファに入力された文字列を投稿する。"
  (interactive)
  (let* ((text (read-from-minibuffer "Bluesky> ")))
    (bsky-post text)))


;; NOTE: 行数で色を切り替えているので投稿ごとに色が切り替わらない
(defun display-list-with-overlays (strings odd-color even-color)
  "文字列リスト STRINGS をバッファに挿入し、偶数と奇数の行で背景色を切り替える。"
  (let ((buf (get-buffer-create "*Overlay Colors*"))
        (odd-color odd-color)
        (even-color even-color))
    (with-current-buffer buf
      (erase-buffer)
      (dolist (str strings)
        (let ((start (point))
              (end nil)
              (bg-color (if (cl-evenp (line-number-at-pos)) even-color odd-color)))
          (insert str "\n")
          (setq end (point))
          (let ((ov (make-overlay start end)))
            (overlay-put ov 'face `(:background ,bg-color))))))
    (display-buffer buf)))

;; (display-list-with-overlays '("Apple\nBanana" "Orange" "Cherry") "#313244" "#1e1e2e")
;; (display-list-with-overlays (bsky-tl-string) "#313244" "#1e1e2e")



;; =========================================================================================================================

(post-createdat (car bsky-posts))

(date-format (parse-time-string "2023-04-06T08:36:18.769Z"))

(format-time-string "%m" (iso8601-parse "2023-04-06T08:36:18.769Z") (current-time-zone))

;; (current-time-zone)

(format-time-string "%Y" (days-to-time ))

(parse-time-string "2023-04-06T08:36:18.769Z")



;; (18  36  8    6   4   2023 nil nil 0)
;; (sec min hour day mon year dow dst tz)
(parse-time-string "2023-04-06T08:36:18.769Z")


(nth 1 (parse-time-string "2023-04-06T08:36:18.769Z"))


(post-createdat (car bsky-posts))
(post-createdat (car bsky-posts) "%Y/%M %D")

(mapconcat #'post-displayname bsky-posts "\n------------------------\n")










(let ((keys (split-string "post.record.text" "\\."))
      (post (car bsky-posts)))


  )

(let ((head (gethash (car keys) post)))
    (message (car keys))

    (if (= (length keys) 1)
	head
      (recur-gethash post (cdr keys) head)))

(defun recur-gethash (post keys head)
  (recur-gethash post (cdr keys) head)
  )


(recur-gethash (car bsky-posts) '("post" "record" "text") nil)

(gethash "record"
	 (gethash "post" (car bsky-posts)))

