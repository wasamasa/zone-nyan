(require 'esxml)


;;; helpers

(defmacro zone-nyan-with-colors (&rest body)
  `(let ((white  "#ffffff")
         (gray   "#999999")
         (black  "#000000")
         (indigo "#003366")

         (red    "#ff0000")
         (orange "#ff9900")
         (yellow "#ffff00")
         (green  "#33ff00")
         (cyan   "#0099ff")
         (violet "#6633ff")

         (rose   "#ff99ff")
         (pink   "#ff3399")
         (rouge  "#ff9999")
         (bread  "#ffcc99"))
     ,@body))

(defun zone-nyan-window-data ()
  (let* ((width (window-body-width nil t))
         (height (window-body-height nil t))
         (smaller-side (min width height))
         (scale (/ smaller-side 70))
         (center-width (* 70 scale))
         (gutter-width (/ (- width center-width) scale))
         (left (floor (/ gutter-width 2.0)))
         (right (ceiling (/ gutter-width 2.0)))
         (center-height (* 70 scale))
         (gutter-height (/ (- height center-height) scale))
         (top (floor (/ gutter-height 2.0)))
         (bottom (ceiling (/ gutter-height 2.0))))
    (list width height scale left right top bottom)))

(defun zone-nyan-svg (width height scale fill &rest body)
  `(svg (@ (xmlns "http://www.w3.org/2000/svg")
           (width ,(number-to-string width))
           (height ,(number-to-string height)))
        ,(zone-nyan-rect 0 0 width height fill)
        (g (@ (transform ,(format "scale(%s)" scale)))
           ,@body)))
(put 'zone-nyan-svg 'lisp-indent-function 4)

(defun zone-nyan-group (x y &rest body)
  `(g (@ (transform ,(format "translate(%s,%s)" x y)))
      ,@body))
(put 'zone-nyan-group 'lisp-indent-function 2)

(defun zone-nyan-group-spliced (x y body)
  `(g (@ (transform ,(format "translate(%s,%s)" x y)))
      ,@body))
(put 'zone-nyan-group-spliced 'lisp-indent-function 2)

(defun zone-nyan-rect (x y width height fill)
  `(rect (@ (x ,(number-to-string x))
            (y ,(number-to-string y))
            (width ,(number-to-string width))
            (height ,(number-to-string height))
            (fill ,fill))))

(defun zone-nyan-pixel (x y fill)
  (zone-nyan-rect x y 1 1 fill))


;;; components

(defun zone-nyan-rainbow (x y left top flip &optional old)
  (if (not old)
      (let* ((offset (if flip 27 26))
             (width (+ offset left))
             (stripe-width 8)
             (stripe-height 3)
             (stripes (/ width stripe-width))
             (initial-stripe-width (mod width stripe-width))
             (flip-offset (if (not flip) 0 1))
             (indexed-colors '((0 . red) (1 . orange) (2 . yellow)
                               (3 . green) (4 . cyan) (5 . violet)))
             pieces)
        (zone-nyan-group-spliced x y
          (progn
            (dolist (indexed-color indexed-colors)
              (let* ((index (car indexed-color))
                     (color (cdr indexed-color))
                     ;; HACK: this feels pretty wrong
                     (hex-code (symbol-value color))
                     (initial-y (+ top (mod (1+ (+ stripes flip-offset)) 2) -1
                                   (* index stripe-height))))
                (push (zone-nyan-rect 0 initial-y
                                      initial-stripe-width stripe-height
                                      hex-code)
                      pieces)
                (dolist (i (number-sequence 0 (1- stripes)))
                  (let* ((piece-x (+ initial-stripe-width (* i stripe-width)))
                         (stripe-offset (mod (+ stripes i flip-offset) 2))
                         (piece-y (+ top stripe-offset -1
                                     (* index stripe-height))))
                    (push (zone-nyan-rect piece-x piece-y
                                          stripe-width stripe-height
                                          hex-code)
                          pieces)))))
            (message "%s + %s * %s = %s + %s"
                     initial-stripe-width stripes stripe-width left offset)
            pieces)))
    (if flip
        (zone-nyan-group x y
          (zone-nyan-rect  0  0 2 3 red)
          (zone-nyan-rect  2  1 8 3 red)
          (zone-nyan-rect 10  0 8 3 red)
          (zone-nyan-rect 18  1 8 3 red)

          (zone-nyan-rect  0  3 2 3 orange)
          (zone-nyan-rect  2  4 8 3 orange)
          (zone-nyan-rect 10  3 8 3 orange)
          (zone-nyan-rect 18  4 8 3 orange)

          (zone-nyan-rect  0  6 2 3 yellow)
          (zone-nyan-rect  2  7 8 3 yellow)
          (zone-nyan-rect 10  6 8 3 yellow)
          (zone-nyan-rect 18  7 8 3 yellow)

          (zone-nyan-rect  0  9 2 3 green)
          (zone-nyan-rect  2 10 8 3 green)
          (zone-nyan-rect 10  9 8 3 green)
          (zone-nyan-rect 18 10 8 3 green)

          (zone-nyan-rect  0 12 2 3 cyan)
          (zone-nyan-rect  2 13 8 3 cyan)
          (zone-nyan-rect 10 12 8 3 cyan)
          (zone-nyan-rect 18 13 8 3 cyan)

          (zone-nyan-rect  0 15 2 3 violet)
          (zone-nyan-rect  2 16 8 3 violet)
          (zone-nyan-rect 10 15 8 3 violet)
          (zone-nyan-rect 18 16 8 3 violet))
      (zone-nyan-group x y
        (zone-nyan-rect  0  1 3 3 red)
        (zone-nyan-rect  3  0 8 3 red)
        (zone-nyan-rect 11  1 8 3 red)
        (zone-nyan-rect 19  0 8 3 red)

        (zone-nyan-rect  0  4 3 3 orange)
        (zone-nyan-rect  3  3 8 3 orange)
        (zone-nyan-rect 11  4 8 3 orange)
        (zone-nyan-rect 19  3 8 3 orange)

        (zone-nyan-rect  0  7 3 3 yellow)
        (zone-nyan-rect  3  6 8 3 yellow)
        (zone-nyan-rect 11  7 8 3 yellow)
        (zone-nyan-rect 19  6 8 3 yellow)

        (zone-nyan-rect  0 10 3 3 green)
        (zone-nyan-rect  3  9 8 3 green)
        (zone-nyan-rect 11 10 8 3 green)
        (zone-nyan-rect 19  9 8 3 green)

        (zone-nyan-rect  0 13 3 3 cyan)
        (zone-nyan-rect  3 12 8 3 cyan)
        (zone-nyan-rect 11 13 8 3 cyan)
        (zone-nyan-rect 19 12 8 3 cyan)

        (zone-nyan-rect  0 16 3 3 violet)
        (zone-nyan-rect  3 15 8 3 violet)
        (zone-nyan-rect 11 16 8 3 violet)
        (zone-nyan-rect 19 15 8 3 violet)))))

(defun zone-nyan-tail (x y frame)
  (cond
   ((= frame 0)
    (zone-nyan-group x y
      (zone-nyan-rect   0  0 4 3 black)
      (zone-nyan-rect   1  1 4 3 black)
      (zone-nyan-rect   2  2 4 3 black)
      (zone-nyan-rect   3  3 3 3 black)
      (zone-nyan-pixel  5  6     black)

      (zone-nyan-rect   1  1 2 1 gray)
      (zone-nyan-rect   2  2 2 1 gray)
      (zone-nyan-rect   3  3 2 1 gray)
      (zone-nyan-rect   4  4 2 1 gray)))
   ((or (= frame 1) (= frame 5))
    (zone-nyan-group x (1+ y)
      (zone-nyan-rect   1  0 2 4 black)
      (zone-nyan-rect   0  1 4 2 black)
      (zone-nyan-rect   2  2 4 3 black)
      (zone-nyan-rect   4  5 2 1 black)

      (zone-nyan-rect   1  1 2 2 gray)
      (zone-nyan-rect   2  3 2 1 gray)
      (zone-nyan-rect   4  3 2 2 gray)))
   ((= frame 2)
    (zone-nyan-group x (+ 4 y)
      (zone-nyan-pixel  5  0     black)
      (zone-nyan-rect   2  1 4 1 black)
      (zone-nyan-rect   0  2 6 2 black)
      (zone-nyan-rect   1  4 4 1 black)

      (zone-nyan-rect   2  2 4 1 gray)
      (zone-nyan-rect   1  3 3 1 gray)))
   ((= frame 3)
    (zone-nyan-group x (+ 4 y)
      (zone-nyan-rect   4  0 2 1 black)
      (zone-nyan-rect   2  1 4 3 black)
      (zone-nyan-rect   1  2 2 4 black)
      (zone-nyan-rect   0  3 4 2 black)

      (zone-nyan-rect   4  1 2 2 gray)
      (zone-nyan-rect   2  2 2 1 gray)
      (zone-nyan-rect   1  3 2 2 gray)))
   ((= frame 4)
    (zone-nyan-group (1- x) (+ y 2)
      (zone-nyan-rect   1  0 4 1 black)
      (zone-nyan-rect   0  1 7 2 black)
      (zone-nyan-rect   2  3 5 1 black)
      (zone-nyan-rect   5  4 2 1 black)

      (zone-nyan-rect   1  1 3 1 gray)
      (zone-nyan-rect   2  2 4 1 gray)
      (zone-nyan-pixel  6  3     gray)))))

(defun zone-nyan-legs (x y frame)
  (cond
   ((= frame 0)
    (zone-nyan-group x y
      (zone-nyan-rect   1  0 2 1 black)
      (zone-nyan-rect   1  1 3 1 gray)
      (zone-nyan-rect   0  1 1 3 black)
      (zone-nyan-rect   1  3 3 1 black)
      (zone-nyan-rect   3  2 2 1 black)
      (zone-nyan-rect   1  2 2 1 gray)

      (zone-nyan-rect   6  2 4 1 black)
      (zone-nyan-rect   6  3 3 1 black)
      (zone-nyan-rect   7  2 2 1 gray)

      (zone-nyan-rect  15  2 4 1 black)
      (zone-nyan-rect  16  3 3 1 black)
      (zone-nyan-rect  16  2 2 1 gray)

      (zone-nyan-rect  20  2 4 1 black)
      (zone-nyan-rect  21  3 2 1 black)
      (zone-nyan-rect  21  2 2 1 gray)))
   ((= frame 1)
    (zone-nyan-group (1+ x) y
      (zone-nyan-rect   1  0 3 3 black)
      (zone-nyan-rect   0  1 3 3 black)
      (zone-nyan-rect   1  1 2 2 gray)

      (zone-nyan-pixel  5  2     black)
      (zone-nyan-rect   6  2 3 2 black)
      (zone-nyan-rect   6  2 2 1 gray)

      (zone-nyan-pixel 15  2     black)
      (zone-nyan-rect  16  2 3 2 black)
      (zone-nyan-rect  16  2 2 1 gray)

      (zone-nyan-pixel 20  2     black)
      (zone-nyan-rect  21  2 3 2 black)
      (zone-nyan-rect  21  2 2 1 gray)))
   ((= frame 2)
    (zone-nyan-group (+ x 2) (1+ y)
      (zone-nyan-rect   0  0 3 4 black)
      (zone-nyan-pixel  3  2     black)
      (zone-nyan-rect   1  1 2 2 gray)

      (zone-nyan-pixel  5  2     black)
      (zone-nyan-rect   6  2 3 2 black)
      (zone-nyan-rect   6  2 2 1 gray)

      (zone-nyan-pixel 15  2     black)
      (zone-nyan-rect  16  2 3 2 black)
      (zone-nyan-rect  16  2 2 1 gray)

      (zone-nyan-pixel 20  2     black)
      (zone-nyan-rect  21  2 3 2 black)
      (zone-nyan-rect  21  2 2 1 gray)))
   ((= frame 3)
    (zone-nyan-group (1+ x) (1+ y)
      (zone-nyan-rect   1  0 3 3 black)
      (zone-nyan-rect   0  1 3 3 black)
      (zone-nyan-rect   1  1 2 2 gray)

      (zone-nyan-pixel  5  2     black)
      (zone-nyan-rect   6  2 3 2 black)
      (zone-nyan-rect   6  2 2 1 gray)

      (zone-nyan-pixel 15  2     black)
      (zone-nyan-rect  16  2 3 2 black)
      (zone-nyan-rect  16  2 2 1 gray)

      (zone-nyan-pixel 20  2     black)
      (zone-nyan-rect  21  2 3 2 black)
      (zone-nyan-rect  21  2 2 1 gray)))
   ((= frame 4)
    (zone-nyan-group (1- x) y
      (zone-nyan-rect   2  0 3 3 black)
      (zone-nyan-rect   1  1 3 3 black)
      (zone-nyan-rect   0  2 3 3 black)
      (zone-nyan-rect   1  2 2 2 gray)
      (zone-nyan-pixel  3  2     gray)

      (zone-nyan-pixel  5  3     black)
      (zone-nyan-rect   6  3 3 2 black)
      (zone-nyan-rect   6  3 2 1 gray)

      (zone-nyan-pixel 15  3     black)
      (zone-nyan-rect  16  3 3 2 black)
      (zone-nyan-rect  16  3 2 1 gray)

      (zone-nyan-pixel 20  3     black)
      (zone-nyan-rect  21  3 3 2 black)
      (zone-nyan-rect  21  3 2 1 gray)))
   ((= frame 5)
    (zone-nyan-group (1- x) y
      (zone-nyan-rect   2  0 3 3 black)
      (zone-nyan-rect   1  1 3 3 black)
      (zone-nyan-rect   0  2 3 3 black)
      (zone-nyan-rect   1  2 2 2 gray)
      (zone-nyan-pixel  2  1     gray)
      (zone-nyan-pixel  3  2     gray)

      (zone-nyan-rect   5  3 3 2 black)
      (zone-nyan-rect   6  3 2 1 gray)
      (zone-nyan-pixel  8  3     black)

      (zone-nyan-rect  15  3 3 2 black)
      (zone-nyan-rect  16  3 2 1 gray)
      (zone-nyan-pixel 18  3     black)

      (zone-nyan-pixel 20  3     black)
      (zone-nyan-rect  21  2 3 3 black)
      (zone-nyan-pixel 22  2     gray)
      (zone-nyan-rect  21  3 2 1 gray)))))

(defun zone-nyan-pop-tart (x y)
  (zone-nyan-group x y
    (zone-nyan-rect   2  0 17 18 black)
    (zone-nyan-rect   1  1 19 16 black)
    (zone-nyan-rect   0  2 21 14 black)

    (zone-nyan-rect   2  1 17 16 bread)
    (zone-nyan-rect   1  2 19 14 bread)

    (zone-nyan-rect   4  2 13 14 rose)
    (zone-nyan-rect   3  3 15 12 rose)
    (zone-nyan-rect   2  4 17 10 rose)

    (zone-nyan-pixel  9  3       pink)
    (zone-nyan-pixel 12  3       pink)
    (zone-nyan-pixel  4  4       pink)
    (zone-nyan-pixel 16  5       pink)
    (zone-nyan-pixel  8  7       pink)
    (zone-nyan-pixel  5  9       pink)
    (zone-nyan-pixel  9 10       pink)
    (zone-nyan-pixel  3 11       pink)
    (zone-nyan-pixel  7 13       pink)
    (zone-nyan-pixel  4 14       pink)))

(defun zone-nyan-face (x y)
  (zone-nyan-group x y
    (zone-nyan-rect   2  0  2  1 black)
    (zone-nyan-rect   1  1  4  2 black)
    (zone-nyan-pixel  5  2       black)

    (zone-nyan-rect  12  0  2  1 black)
    (zone-nyan-rect  11  1  4  2 black)
    (zone-nyan-pixel 10  2       black)

    (zone-nyan-rect   0  5 16  5 black)
    (zone-nyan-rect   1  3 14  8 black)
    (zone-nyan-rect   2  3 12  9 black)
    (zone-nyan-rect   3  3 10 10 black)

    (zone-nyan-rect   2  1  2  3 gray)
    (zone-nyan-rect   4  2  1  2 gray)
    (zone-nyan-pixel  5  3       gray)

    (zone-nyan-rect  12  1  2  3 gray)
    (zone-nyan-rect  11  2  1  2 gray)
    (zone-nyan-pixel 10  3       gray)

    (zone-nyan-rect   2  4 12  7 gray)
    (zone-nyan-rect   1  5 14  5 gray)
    (zone-nyan-rect   3 11 10  1 gray)

    (zone-nyan-rect   2  8  2  2 rouge)
    (zone-nyan-rect  13  8  2  2 rouge)

    (zone-nyan-rect   4  6  2  2 black)
    (zone-nyan-pixel  4  6       white)

    (zone-nyan-rect  11  6  2  2 black)
    (zone-nyan-pixel 11  6       white)

    (zone-nyan-rect   5 10  7  1 black)
    (zone-nyan-pixel  5  9       black)
    (zone-nyan-pixel  8  9       black)
    (zone-nyan-pixel 11  9       black)

    (zone-nyan-pixel  9  7       black)))

;;; frontend

(defun zone-nyan-image (time)
  (let* ((frame (% time 6))
         (rainbow-flipped (not (zerop (% (/ time 2) 2))))
         (pop-tart-offset (if (< frame 2) 0 1))
         (face-x-offset (if (or (zerop frame) (> frame 3)) 0 1))
         (face-y-offset (if (or (< frame 2) (> frame 4)) 0 1))

         (window-data (zone-nyan-window-data))
         (width (car window-data))
         (height (cadr window-data))
         (scale (nth 2 window-data))
         (left (nth 3 window-data))
         (right (nth 4 window-data))
         (top (nth 5 window-data))
         (bottom (nth 6 window-data)))
    (sxml-to-xml
     (zone-nyan-with-colors
      (zone-nyan-svg width height scale indigo
        (zone-nyan-rainbow 0 27 left top rainbow-flipped nil)

        (zone-nyan-group left top
          (zone-nyan-tail 19 32 frame)
          (zone-nyan-legs 23 41 frame)
          (zone-nyan-pop-tart 25 (+ 25 pop-tart-offset))
          (zone-nyan-face (+ 35 face-x-offset) (+ 30 face-y-offset))))))))

(defvar zone-nyan-preview-buffer-name "*zone nyan*")

(defvar zone-nyan-interval (/ 1.0 10))

(defun zone-nyan ()
  (delete-other-windows)
  (let ((time 0))
    (while (not (input-pending-p))
      (erase-buffer)
      (insert (propertize " " 'display
                          (create-image (zone-nyan-image time) 'svg t)))
      (setq time (1+ time))
      (sit-for zone-nyan-interval))))

(defun zone-nyan-preview ()
  (interactive)
  (let ((zone-programs [zone-nyan]))
    (zone)))
