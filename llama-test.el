;;; llama-tests.el --- Tests for Llama  -*- lexical-binding:t -*-

;; Copyright (C) 2020-2024 Jonas Bernoulli

;; Authors: Jonas Bernoulli <emacs.llama@jonas.bernoulli.dev>
;; Homepage: https://git.sr.ht/~tarsius/llama
;; Keywords: extensions

;; SPDX-License-Identifier: GPL-3.0-or-later

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation, either version 3 of the License,
;; or (at your option) any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this file.  If not, see <https://www.gnu.org/licenses/>.

;;; Code:

(require 'llama)

(ert-deftest llama-test-101-basic nil

  (should (equal (##list  %1)
                 (lambda (%1)
                   (list  %1))))

  (should (equal (##list  %1 %1)
                 (lambda (%1)
                   (list  %1 %1))))

  (should (equal (##list  %1 %2)
                 (lambda (%1 %2)
                   (list  %1 %2))))

  (should (equal (##list     %2 %1)
                 (lambda (%1 %2)
                   (list     %2 %1))))

  (should (equal (##list  'const %1)
                 (lambda (       %1)
                   (list  'const %1))))

  (should (equal (##list  %1 'const)
                 (lambda (%1)
                   (list  %1 'const))))

  (should (equal (##list  %1 'const %2)
                 (lambda (%1        %2)
                   (list  %1 'const %2))))

  (should (equal (##list     %2 'const %1)
                 (lambda (%1 %2)
                   (list     %2 'const %1))))

  (should (equal (##list  %1 %2 %3 %4 %5 %6 %7 %8 %9)
                 (lambda (%1 %2 %3 %4 %5 %6 %7 %8 %9)
                   (list  %1 %2 %3 %4 %5 %6 %7 %8 %9))))

  (should (equal (##list  %1 %2 %1 %3 %5 %4    %6 %7    %9 %8)
                 (lambda (%1 %2    %3    %4 %5 %6 %7 %8 %9)
                   (list  %1 %2 %1 %3 %5 %4    %6 %7    %9 %8))))
  )

(ert-deftest llama-test-102-basic-optional nil

  (should (equal (##list            &1)
                 (lambda (&optional &1)
                   (list            &1))))

  (should (equal (##list  %1           &2)
                 (lambda (%1 &optional &2)
                   (list  %1           &2))))

  (should (equal (##list  %2 %1                 &4 &3)
                 (lambda (   %1 %2 &optional &3 &4)
                   (list  %2 %1                 &4 &3))))
  )

(ert-deftest llama-test-103-basic-rest nil

  (should (equal (##list        &*)
                 (lambda (&rest &*)
                   (list        &*))))

  (should (equal (##list  %1       &*)
                 (lambda (%1 &rest &*)
                   (list  %1       &*))))

  (should (equal (##list  %1           &2       &*)
                 (lambda (%1 &optional &2 &rest &*)
                   (list  %1           &2       &*))))
  )

(ert-deftest llama-test-201-unused-implicit-mandatory nil

  (should (equal (##list      %2)
                 (lambda (_%1 %2)
                   (list      %2))))

  (should (equal (##list      %2 %3)
                 (lambda (_%1 %2 %3)
                   (list      %2 %3))))

  (should (equal (##list          %3)
                 (lambda (_%1 _%2 %3)
                   (list          %3))))

  (should (equal (##list  %1     %3)
                 (lambda (%1 _%2 %3)
                   (list  %1     %3))))

  (should (equal (##list          %3         %6)
                 (lambda (_%1 _%2 %3 _%4 _%5 %6)
                   (list          %3         %6))))
  )

(ert-deftest llama-test-202-unused-implicit-optional nil

  (should (equal (##list                &2)
                 (lambda (&optional _&1 &2)
                   (list                &2))))

  (should (equal (##list                &2 &3)
                 (lambda (&optional _&1 &2 &3)
                   (list                &2 &3))))

  (should (equal (##list                    &3)
                 (lambda (&optional _&1 _&2 &3)
                   (list                    &3))))

  (should (equal (##list            &1     &3)
                 (lambda (&optional &1 _&2 &3)
                   (list            &1     &3))))

  (should (equal (##list                    &3         &6)
                 (lambda (&optional _&1 _&2 &3 _&4 _&5 &6)
                   (list                    &3         &6))))
  )

(ert-deftest llama-test-203-unused-implicit-mixed nil

  (should (equal (##list  %1               &3)
                 (lambda (%1 &optional _&2 &3)
                   (list  %1               &3))))

  (should (equal (##list  %1                   &4)
                 (lambda (%1 &optional _&2 _&3 &4)
                   (list  %1                   &4))))

  (should (equal (##list  %1 %2               &4)
                 (lambda (%1 %2 &optional _&3 &4)
                   (list  %1 %2               &4))))


  (should (equal (##list      %2               &4     &6)
                 (lambda (_%1 %2 &optional _&3 &4 _&5 &6)
                   (list      %2               &4     &6))))
  )

(ert-deftest llama-test-301-unused-explicit-trailing nil

  (should (equal (##list  _%1)
                 (lambda (_%1)
                   (list))))

  (should (equal (##list      _%2)
                 (lambda (_%1 _%2)
                   (list))))

  (should (equal (##list  %1 _%2)
                 (lambda (%1 _%2)
                   (list  %1))))

  (should (equal (##list  %1     _%3)
                 (lambda (%1 _%2 _%3)
                   (list  %1))))
  )

(ert-deftest llama-test-302-unused-explicit-border nil

  (should (equal (##list  _%1           &2)
                 (lambda (_%1 &optional &2)
                   (list                &2))))

  (should (equal (##list      _%2           &3)
                 (lambda (_%1 _%2 &optional &3)
                   (list                    &3))))

  (should (equal (##list  %1 _%2           &3)
                 (lambda (%1 _%2 &optional &3)
                   (list  %1               &3))))

  (should (equal (##list  %1 _%2               &4)
                 (lambda (%1 _%2 &optional _&3 &4)
                   (list  %1                   &4))))

  (should (equal (##list  %1     _%3                   &6)
                 (lambda (%1 _%2 _%3 &optional _&4 _&5 &6)
                   (list  %1                           &6))))
  )

(ert-deftest llama-test-303-unused-redundant nil

  (should (equal (##list  _%1 %2)
                 (lambda (_%1 %2)
                   (list      %2))))

  (should (equal (##list            _&1 &2)
                 (lambda (&optional _&1 &2)
                   (list                &2))))
  )

(ert-deftest llama-test-401-abbrev nil
  ;; llama-test-101-basic(s/%1/%/)

  (should (equal (##list  %)
                 (lambda (%)
                   (list  %))))

  (should (equal (##list  % %)
                 (lambda (%)
                   (list  % %))))

  (should (equal (##list  % %2)
                 (lambda (% %2)
                   (list  % %2))))

  (should (equal (##list     %2 %)
                 (lambda (% %2)
                   (list     %2 %))))

  (should (equal (##list  'const %)
                 (lambda (       %)
                   (list  'const %))))

  (should (equal (##list  % 'const)
                 (lambda (%)
                   (list  % 'const))))

  (should (equal (##list  % 'const %2)
                 (lambda (%        %2)
                   (list  % 'const %2))))

  (should (equal (##list     %2 'const %)
                 (lambda (% %2)
                   (list     %2 'const %))))

  (should (equal (##list  % %2 %3 %4 %5 %6 %7 %8 %9)
                 (lambda (% %2 %3 %4 %5 %6 %7 %8 %9)
                   (list  % %2 %3 %4 %5 %6 %7 %8 %9))))

  (should (equal (##list  % %2 % %3 %5 %4    %6 %7    %9 %8)
                 (lambda (% %2   %3    %4 %5 %6 %7 %8 %9)
                   (list  % %2 % %3 %5 %4    %6 %7    %9 %8))))
  )

(ert-deftest llama-test-402-abbrev-optional nil
  ;; llama-test-102-basic-optional(s/&1/&/)

  (should (equal (##list            &1)
                 (lambda (&optional &1)
                   (list            &1))))

  (should (equal (##list  %           &2)
                 (lambda (% &optional &2)
                   (list  %           &2))))

  (should (equal (##list  %2 %                 &4 &3)
                 (lambda (   % %2 &optional &3 &4)
                   (list  %2 %                 &4 &3))))
  )

(ert-deftest llama-test-501-function-position nil

  (should (equal (##+ (% %2 2) %1)
                 (lambda (%1 %2)
                   (+ (% %2 2) %1))))

  (should (equal (##+ (* %2 2) %)
                 (lambda (% %2)
                   (+ (* %2 2) %))))

  (should (equal (##% %2 2)
                 (lambda (_%1 %2)
                   (% %2 2))))

  (should (equal (##* %1 2)
                 (lambda (%1)
                   (* %1 2))))

  (should (equal (##% %2 %1)
                 (lambda (%1 %2)
                   (% %2 %1))))
  )

(ert-deftest llama-test-901-errors-first nil
  (should-error (##list  %1   &1))
  (should-error (##list  &1   %1))
  (should-error (##list  %1  _%1))
  (should-error (##list _%1   %1))
  (should-error (##list  %1  _&1))
  (should-error (##list _&1   %1))
  (should-error (##list  %1   %1  &1))
  )

(ert-deftest llama-test-902-errors-second nil
  (should-error (##list  %2   &2))
  (should-error (##list  &2   %2))
  (should-error (##list  %2  _%2))
  (should-error (##list _%2   %2))
  (should-error (##list  %2  _&2))
  (should-error (##list _&2   %2))
  (should-error (##list  %2   %2  &2))
  )

(ert-deftest llama-test-903-errors-abbrev nil
  (should-error (##list  %    &))
  (should-error (##list  &    %))
  (should-error (##list  %   _%))
  (should-error (##list _%    %))
  (should-error (##list  %   _&))
  (should-error (##list _&    %))
  (should-error (##list  %    %   &))
  (should-error (##list  %    %1))
  (should-error (##list  %   _%1))
  (should-error (##list  %    &1))
  (should-error (##list  %   _&1))
  (should-error (##list  %1   %))
  )

;; Local Variables:
;; eval: (prettify-symbols-mode -1)
;; indent-tabs-mode: nil
;; End:
;;; llama-tests.el ends here
