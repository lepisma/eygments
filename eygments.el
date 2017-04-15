;;; eygments.el --- Export Emacs theme to pygments css   -*- lexical-binding: nil -*-

;; Copyright (C) 2017 Abhinav Tushar

;; Author: Abhinav Tushar <abhinav.tushar.vs@gmail.com>
;; Version: 0.1.0
;; URL: https://github.com/lepisma/eygments

;;; Commentary:

;; eygments.el helps you export the current Emacs theme as pygments (and rogue)
;; compatible CSS snippet
;; This file is not a part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Code:

(defun eygments--header ()
  "Return header"
  "/* Pygments theme exported from Emacs */")

(defun eygments--rule (class color &optional rule-pair)
  "Return a css rule for given CLASS and COLOR. Optionally apply
provided RULE-PAIR alist like (\"background-color\" . \"red\")."
  (concat ".highlight "
          (if class (concat "." class " "))
          "{ color: " color "; "
          (if rule-pair (concat (car rule-pair) ": " (cdr rule-pair) "; "))
          "}"))

(defun eygments--face-foreground (face)
  "Return foreground of given FACE. Fallback to default foreground."
  (let ((fore (face-foreground face)))
    (if fore fore (face-foreground 'default))))

(defmacro eygments--eval (stuff)
  "Eval STUFF in current faces' context"
  `(let* ((foreground (face-foreground 'default))
         (background (face-background 'default))
         (builtin (eygments--face-foreground 'font-lock-builtin-face))
         (comment (eygments--face-foreground 'font-lock-comment-face))
         (constant (eygments--face-foreground 'font-lock-constant-face))
         (doc (eygments--face-foreground 'font-lock-doc-face))
         (func (eygments--face-foreground 'font-lock-function-name-face))
         (keyword (eygments--face-foreground 'font-lock-keyword-face))
         (regex (eygments--face-foreground 'font-lock-regexp-grouping-construct))
         (string (eygments--face-foreground 'font-lock-string-face))
         (type (eygments--face-foreground 'font-lock-type-face))
         (variable (eygments--face-foreground 'font-lock-variable-name-face))
         (warning (eygments--face-foreground 'font-lock-warning-face)))
     ,stuff))

(defun eygments--palette-info ()
  "Generate color palette info."
  (eygments--eval
   (let ((colors
          '(foreground
            background
            builtin
            comment
            constant
            doc
            func
            keyword
            regex
            string
            type
            variable
            warning))
         (text))
     (setq text "/* Palette\n")
     (dolist (item colors text)
       (setq text (concat text (symbol-value item) "  " (symbol-name item) "\n")))
     (setq text (concat text "*/")))))

(defun eygments--css ()
  "Generate CSS."
  (eygments--eval
   (concat "/* Style */\n"
           ;; Main stuff
           (eygments--rule nil foreground `("background-color" . ,background)) "\n"
           ;; Comment
           (eygments--rule "c" comment) "\n"
           ;; Error
           (eygments--rule "err" warning) "\n"
           ;; Generic
           (eygments--rule "g" foreground) "\n"
           ;; Keyword
           (eygments--rule "k" keyword) "\n"
           ;; Literal
           (eygments--rule "l" foreground) "\n"
           ;; Name
           (eygments--rule "n" foreground) "\n"
           ;; Operator
           (eygments--rule "o" func) "\n"
           ;; Other
           (eygments--rule "x" constant) "\n"
           ;; Punctuation
           (eygments--rule "p" foreground) "\n"
           ;; Comment.Multiline
           (eygments--rule "cm" comment) "\n"
           ;; Comment.Preproc
           (eygments--rule "cp" func) "\n"
           ;; Comment.Single
           (eygments--rule "c1" comment) "\n"
           ;; Comment.Special
           (eygments--rule "cs" func) "\n"
           ;; Generic.Deleted
           (eygments--rule "gd" string) "\n"
           ;; Generic.Emphasis
           (eygments--rule "ge" foreground `("font-style" . "italic")) "\n"
           ;; Generic.Error
           (eygments--rule "gr" warning) "\n"
           ;; Generic.Heading
           (eygments--rule "gh" constant) "\n"
           ;; Generic.Inserted
           (eygments--rule "gi" func) "\n"
           ;; Generic.Output
           (eygments--rule "go" foreground) "\n"
           ;; Generic.Prompt
           (eygments--rule "gp" foreground) "\n"
           ;; Genric.Strong
           (eygments--rule "gs" foreground `("font-weight" . "bold")) "\n"
           ;; Generic.Subheading
           (eygments--rule "gu" constant) "\n"
           ;; Generic.Traceback
           (eygments--rule "gt" foreground) "\n"
           ;; Keyword.Constant
           (eygments--rule "kc" constant) "\n"
           ;; Keyword.Declaration
           (eygments--rule "kd" keyword) "\n"
           ;; Keyword.Namespace
           (eygments--rule "kn" func) "\n"
           ;; Keyword.Pseudo
           (eygments--rule "kp" func) "\n"
           ;; Keyword.Reserved
           (eygments--rule "kr" keyword) "\n"
           ;; Keyword.Type
           (eygments--rule "kt" type) "\n"
           ;; Literal.Date
           (eygments--rule "ld" foreground) "\n"
           ;; Literal.Number
           (eygments--rule "m" string) "\n"
           ;; Literal.String
           (eygments--rule "s" string) "\n"
           ;; Name.Attribute
           (eygments--rule "na" foreground) "\n"
           ;; Name.Builtin
           (eygments--rule "nb" builtin) "\n"
           ;; Name.Class
           (eygments--rule "nc" type) "\n"
           ;; Name.Constant
           (eygments--rule "no" constant) "\n"
           ;; Name.Decorator
           (eygments--rule "nd" type) "\n"
           ;; Name.Entity
           (eygments--rule "ni" constant) "\n"
           ;; Name.Exception
           (eygments--rule "ne" constant) "\n"
           ;; Name.Function
           (eygments--rule "nf" func) "\n"
           ;; Name.Label
           (eygments--rule "nl" foreground) "\n"
           ;; Name.Namespace
           (eygments--rule "nn" foreground) "\n"
           ;; Name.Other
           (eygments--rule "nx" foreground) "\n"
           ;; Name.Property
           (eygments--rule "py" type) "\n"
           ;; Name.Tag
           (eygments--rule "nt" type) "\n"
           ;; Name.Variable
           (eygments--rule "nv" variable) "\n"
           ;; Operator.Word
           (eygments--rule "ow" func) "\n"
           ;; Text.Whitespace
           (eygments--rule "w" foreground) "\n"
           ;; Literal.Number.Float
           (eygments--rule "mf" string) "\n"
           ;; Literal.Number.Hex
           (eygments--rule "mh" string) "\n"
           ;; Literal.Number.Integer
           (eygments--rule "mi" string) "\n"
           ;; Literal.Number.Oct
           (eygments--rule "mo" string) "\n"
           ;; Literal.String.Backtick
           (eygments--rule "sb" comment) "\n"
           ;; Literal.String.Char
           (eygments--rule "sc" string) "\n"
           ;; Literal.String.Doc
           (eygments--rule "sd" doc) "\n"
           ;; Literal.String.Double
           (eygments--rule "s2" string) "\n"
           ;; Literal.String.Escape
           (eygments--rule "se" constant) "\n"
           ;; Literal.String.Heredoc
           (eygments--rule "sh" doc) "\n"
           ;; Literal.String.Interpol
           (eygments--rule "si" string) "\n"
           ;; Literal.String.Other
           (eygments--rule "sx" string) "\n"
           ;; Literal.String.Regex
           (eygments--rule "sr" regex) "\n"
           ;; Literal.String.Single
           (eygments--rule "s1" string) "\n"
           ;; Literal.String.Symbol
           (eygments--rule "ss" string) "\n"
           ;; Name.Builtin.Pseudo
           (eygments--rule "bp" builtin) "\n"
           ;; Name.Variable.Class
           (eygments--rule "vc" type) "\n"
           ;; Name.Variable.Global
           (eygments--rule "vg" variable) "\n"
           ;; Name.Variable.Instance
           (eygments--rule "vi" variable) "\n"
           ;; Literal.Number.Integer.Long
           (eygments--rule "il" string) "\n")))

;;;###autoload
(defun eygments-export ()
  (interactive)
  (insert (eygments--header))
  (insert "\n\n")
  (insert (eygments--palette-info))
  (insert "\n\n")
  (insert (eygments--css)))

(provide 'eygments)
;;; eygments.el ends here

