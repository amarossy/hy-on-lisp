
; Creates a function
(defn double [x]
  (* 2 x))

; Calls the function
(print (double 2.3))

; Prints the function address
(print double)

; As in Python, we can access a function by its name from globals
(print (get (globals) "double"))

; Lambda expression
((fn [x] (* x 2)) 5)

; As lambda expression is an anonymous function, it can also appear in a function call
(print ((fn [x] (* x 2)) 5))

; Prints the lambda expression address
(print (fn [x] (* x 2)))

; In Hy, one cannot overload function and argument names
; (setv double 2)
; (double double)   <- this doesn't work in Hy

; As function are ordinary data objects in Hy, too, they can be assigned to a variable
(setv double-fn double)
(print (double-fn 100))

; Let us check if the two functions are technically the same
(print (= double double-fn))

; Let us check if the two functions are the same in terms of their address
(print (= double-fn (get (globals) "double")))

; We can also assign a lambda expression to a variable, which is equal to a function
(setv double-lambda (fn [x] (* x 2)))
(print (double-lambda 100))

; === 2.2 Functional arguments ===

(print (+ 1 2))

; (apply #'+ '(1 2))  <- this doesn't work in Hy
; In Hy, we can use Python's unpacking operator *
; So, while Hy doesn't have apply, we can use #* to unpack a list into arguments
(print (+ #* [1 2]))

