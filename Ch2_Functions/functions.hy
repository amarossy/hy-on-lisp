; ======= Notes in Hy language on Paul Graham's On Lisp, Chapter 2: Functions =======

; Creates a function
(defn double [x]
  (* 2 x))

; Calls the function
(print (double 2.3))

; Prints the function's memory address
(print double)

; As in Python, we can access a function by its name from globals
(print (get (globals) "double"))

; Lambda expression is defined with the 'fn' keyword
(fn [x] (* x 2))

; Prints the lambda expression's address
(print (fn [x] (* x 2)))

; As lambda expression is an anonymous function, it can also appear in a function call
(print ((fn [x] (* x 2)) 5))

; In Hy, in contrast to Common Lisp, one cannot overload function and argument names
; (setv double 2)
; (double double)   <- this doesn't work in Hy

; As function are ordinary data objects in Hy, too, they can be assigned to a variable
(setv double-fn double)
(print (double-fn 100))

; Let us check if the two functions are technically the same
(print (= double double-fn))

; Same with the function in globals
(print (= double-fn (get (globals) "double")))

; We can also assign a lambda expression to a variable
; ... which is equal to a function definition
(setv double-lambda (fn [x] (* x 2)))
(print (double-lambda 100))

; === 2.2 Functional arguments ===

(print (+ 1 2))

; (apply #'+ '(1 2))  <- this doesn't work in Hy
; But we can use Hy's #* unpacking operator to apply a list to a function
(print (+ #* [1 2]))

; The unpacking operator #* can also be used in lambda expressions
(print((fn [x] (+ #* x)) [1 2 3]))

; This function repeats a list n times
; returns [1, 2, 3, 1, 2, 3, 1, 2, 3]
(print(* 3 [1 2 3]))

; This function multiplies each element of a list with n
; note that (map <function> <list>) only returns a map object,
; so we need to convert it to a list
; returns [4, 8, 12]  
(defn multiply-list [lst n]
  (list (map (fn [x] (* x n)) lst)))

(print (multiply-list [1 2 3] 4))

