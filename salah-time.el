;;; salah-time --- display salah time -*- lexical-binding: t -*-
;;
;; Copyright © 2019 Azzam Syawqi Aziz
;;
;; Author: Azzam Syawqi Aziz <azzamsa@azzamsa.com>
;; URL: https://github.com/azzansa/salah-time
;; Version: 0.1.0
;; Keywords: convenience
;; Package-Requires: ((request "20181129.1138"))

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This package will send an anonymous request to https://time.siswadi.com/pray/
;; to get the list of salah time, then return requested time and wakting time
;; via libnotify.


;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(require 'request)

(defcustom salah-time-city ""
  "A name of city."
  :type 'string
  :group 'salah-time)

(defun siswadi-request ()
  "Get salah time from siswadi.
Return 400 if failed."
  (let* ((siswadi-response (request (concat "https://time.siswadi.com/pray/" salah-time-city)
                                    :parser 'json-read
                                    :sync t))
         (data (request-response-data siswadi-response))
         (status (request-response-status-code siswadi-response)))
    (if (eq status 200)
        data
      404)))

(defvar salah-alias-data '(("s" . "Fajr")
                           ("d" . "Dhuhr")
                           ("a" . "Asr")
                           ("m" . "Maghrib")
                           ("i" . "Isha"))
  "Alias list for tipe salah.
User can input single letter instead of full tipe salah name.")

(defun waiting-time (goal-time)
  "Return Hour and Minutes of remaining time against salah time (GOAL-TIME)."
  (let* ((curr-time (split-string (format-time-string "%H %M" (current-time))))
         (curr-hour-in-sec (* (string-to-number (nth 0 curr-time)) 3600))
         (curr-minute-in-sec (* (string-to-number (nth 1 curr-time)) 60))
         (curr-time-in-sec (+ curr-hour-in-sec curr-minute-in-sec))
         (goal-hour-in-sec (* (nth 2 (parse-time-string goal-time)) 3600))
         (goal-minute-in-sec (* (nth 1 (parse-time-string goal-time)) 60))
         (goal-in-sec (+ goal-hour-in-sec goal-minute-in-sec))
         (remaining-sec (- goal-in-sec curr-time-in-sec)))
    (format-seconds "%H %M" remaining-sec)))

;;;###autoload
(defun salah-time ()
  "Show salah time via libnotify.
Accept user input defined in 'salah-alias-data'"
  (interactive)
  (let* ((salah-alias (read-string "Salah: "))
         (salah-type (cdr (assoc salah-alias salah-alias-data)))
         (siswadi-response (siswadi-request)))
    (if (eq siswadi-response 404)
        (message "Salah Time request failed")
      (let ((time (assoc (intern salah-type) (nth 0 siswadi-response))))
        (start-process "Salah Time"
                       nil
                       "notify-send" "--app-name=Shalah Time"
                       "--urgency=normal"
                       (format "%s Time" (car time))
                       (format "\n%s :  %s\nWaiting time: %s"
                               (car time) (cdr time) (waiting-time (cdr time))))))))

(provide 'salah-time)
;;; salah-time.el ends here
