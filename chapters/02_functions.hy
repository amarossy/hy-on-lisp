; ======= Notes in Hy language on Paul Graham's On Lisp, Chapter 2: Functions =======

(print "========== 2.2 Defining Functions (p. 10.) ==========")

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

(print "========== 2.3 Functional Arguments (p. 13.) ==========")

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

; If we want to use a function with map, which takes two arguments,
; we can use a lambda expression with map
(defn multiply [x y]
  (* x y))

(defn multiply-list [lst n]
  (list (map (fn [x] (multiply x n)) lst)))

(print (multiply-list [1 2 3 4 5] 10))

; Common Lisp's 'mapcar' is equivalent to Hy's 'map'
; Remember, that (map) returns a map object, so we need to convert it to a list with (list)
; returns [11, 12, 13]
(print (list(map (fn [x] (+ x 10)) [1 2 3])))

; ... or with other line breaks
; returns [11, 12, 13]
(print (list
        (map
          (fn [x] (+ x 10))
          [1 2 3])))

; Hy can also sort a list, just like Python or Common Lisp
(print(sorted [1 4 2 5 6 7 3]))

; Hy doesn't have a remove-if function, so we have to define it ourselves
(defn remove-if [pred lst]
  (list (filter (fn [x] (not (pred x))) lst))) 

; ... and Hy also doesn't have an evenp function, so we have to define it ourselves, too
(defn evenp [x]
  (= (% x 2) 0))

; but finally the usage isn't bad...
(print(remove-if evenp [1 2 3 4 5 6]))

; it also works on an empty list
(print(remove-if evenp []))


(print "========== 2.4 Functions as Properties (p. 15.) ==========")

; Hy has pattern matching the same way as Python
(defn behave [animal] (match animal
  "dog" ["bark" "woof"]
  "cat" "meow"
  "duck" "quack"
  "default" "unknown")) 

(print(behave "dog"))

; In the following example, the 'get' function gets a value from a dictionary
; and the (get animal "behavior") returns the function bark or meow
; note, that in Hy the dictionary key is a string (and not a symbol as in Common Lisp)
; Wrapping get in double paranthesis calls the function directly, 
; similarly to funcall in Common Lisp

(defn behave [animal]
  ((get animal "behavior")))

(defn bark [] (print "Woof!"))
(defn meow [] (print "Meow!"))

(setv animal1 {"name" "Dog" "behavior" bark})
(setv animal2 {"name" "Cat" "behavior" meow})

(behave animal1)
(behave animal2)


(print "========== 2.5 Scope (p. 16.) ==========")

; In Hy, the scoping rules of variables in functions follow lexical scoping.
; This means that the value of a variable is determined by the environment 
; in which the function is defined.
; In this case, the (let) creates a scope and defines a variable y with the value 7.
; The function scope-test is defined in this scope and uses the variable y.
; Because of lexical scoping, the function scope-test captures the original value of y.
(let [y 7]
  (defn scope-test [x] [x y]))

; Here we create another scope and another y variable in this scope with the value 5.
; However, the scope-test function still uses the original value of y, which is 7.
; This is different from Common Lisp (and the book's example), where the function
; would use the value of y in the scope where it is called due to dynamic scoping.
; Prints [3 7] instead of [3 5] as in the book.
(let [y 5]
  (print(scope-test 3)))

(print "========== 2.6 Closures (p. 17.) ==========")

; The Hy implementation of the book's example list+
; the anonymous function (fn [x] (+ x n)) is a closure, 
; as it captures the variable n from the surrounding scope of list+
; Note that Hy uses map instead of mapcar
(defn list+ [lst n]
  (list (map (fn [x] (+ x n)) lst))) 

(print (list+ [1 2 3] 10))  ; returns [11, 12, 13]

; The following example from the book demonstrates that the closure captures the variable n
; (let [counter 0]
;   (defn new-id []
;     (setv counter (+ counter 1))
;     counter)

;   (defn reset-id []
;     (setv counter 0))) 

; (print(new_id))
; 
; Hy version first without a closure:
(setv counter [0])

(defn new-id []
  (setv (get counter 0) (+ (get counter 0) 1))
  (get counter 0))

(defn reset-id []
  (setv (get counter 0) 0))

(print (new-id))  ; Call the new-id function
(print (new-id))  ; Call the new-id function again to see the increment
(print (new-id))  ; Call the new-id function again to see the increment
(reset-id)        ; Reset the counter
(print (new-id))  ; Call new-id after reset to see the counter reset

; This worked, but it is not a closure. Instead, we can use a closure 
; to achieve the same result. In the code below, the counter is held
; in a list so that it remains mutable and accessible by both functions,
; without encountering scope issues. The `(defn create-id-generator [])`
; function creates a closure where the counter is defined.
; This way, both `new-id` and `reset-id` share the same `counter` state.
(defn create-id-generator []
  (setv counter [0])

  (defn new-id []
    (setv (get counter 0) (+ (get counter 0) 1))
    (get counter 0))

  (defn reset-id []
    (setv (get counter 0) 0))

  [new-id reset-id])

(setv [new-id reset-id] (create-id-generator))

(print (new-id))  ; Call new-id to get the first ID
(print (new-id))  ; Call new-id again to see the incremented ID
(reset-id)        ; Reset the counter
(print (new-id))  ; Call new-id after reset to verify the counter resets

; (page 18)
; The next example returns a lambda function that adds 'n' to its argument 'x'
(defn adder [n]
  (fn [x] (+ x n)))

; We can now create as many adder functions as we want
(setv add2 (adder 2))
(setv add10 (adder 10))

(print (add2 5))   ; returns 7
(print (add10 5))  ; returns 15

; (page 19)
; This function can change its internal state by passing a second argument
; Note, that in Hy, you cannot modify a variable from an outer scope directly 
; inside a nested function without declaring it as nonlocal
; Also note, that optional arguments are defined in Hy as [parameter default-value]
(defn make-adderb [n]
  (fn [x [change None]]
    (if change
      (do (nonlocal n)
          (setv n x) 
          (print f"n changed to {x}"))
      (+ x n))))

(setv addx (make-adderb 1))
(print (addx 3))            ; output 4
(addx 3 True)
(print (addx 3))            ; output 6
(assert (= (addx 4) 7))     ; testing

(print "========== 2.7 Local functions (p. 21.) ==========")

; (page 21)
; In Hy, we can apply a lambda function to a list with map
(print(list(map (fn [x] (+ 2 x)) [2 5 7 3])))

; Ok the next example became a bit more complicated in Hy
; because it lacks the copy-tree function from Common Lisp
;   (mapcar #’copy-tree ’((a b) (c d e)))
; became (note that you have to install hyrule package for this to work):
(import hyrule.collections [postwalk])
(setv trail '((a b) (c d e)))
(defn extract-symbols [x]
  (cond (isinstance x hy.models.Symbol) (str x)
        (isinstance x hy.models.Expression) (list (map extract-symbols x))
        True x))
(print (list (map (fn [x] (postwalk extract-symbols x)) trail)))

; ... in short, here we are walking through the list with a recursive function
; called by a lambda function mapped to the list

; === Labels (p. 22)

; In Hy, there is no 'labels' macro, so we have to use let to define a local function
; TODO: This example is not working yet, has to be corrected. Because it gives hy.models.Symbol
(defn count-instances [obj lsts]
  (let [[instances-in (fn [lst]
                        (cond (isinstance lst list) (instances-in (rest lst))
                              (+ (if (= (first lst) obj) 1 0)
                                 (instances-in (rest lst)) 0)))]]
    (map (fn [lst] (instances-in lst)) lsts)))

(count-instances 'a '((a b) (c d e)))