#lang racket/base
; files.rkt
; definitions of file paths that ivy uses
(provide (all-defined-out))

; base directory where ivy will put all of its files
(define ivy-path
  (cond [(eq? (system-type) 'unix)
         ; check XDG variable first, then default
         ; to ~/.config/ivy
         (let ([xdg (getenv "XDG_CONFIG_HOME")])
           (if xdg
               (build-path xdg "ivy")
               (build-path (find-system-path 'home-dir)
                           ".config/ivy")))]
        [(eq? (system-type) 'windows)
         (normal-case-path
          (build-path (find-system-path 'home-dir)
                      "appdata/local/ivy"))]
        [(eq? (system-type) 'macosx)
         (build-path (find-system-path 'home-dir)
                     "Library/Application Support/ivy")]))

(define master-file (build-path ivy-path "catalog.sqlite"))

; path for cached thumbnails
(define thumbnails-path (build-path ivy-path "thumbnails"))

(define logo
  (if (eq? (system-type) 'unix)
      (let* ([base "share/icons/hicolor/128x128/apps/ivy-logo-128px.png"]
             [uls (build-path "/usr/local" base)]
             [us (build-path "/usr" base)])
        (cond [(file-exists? uls) uls]
              [(file-exists? us) us]
              [else (build-path "img/ivy-logo-128px.png")]))
      (build-path "img/ivy-logo-128px.png")))