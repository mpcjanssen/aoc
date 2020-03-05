(ns day5)
*ns*

(def mem
    (mapv read-string (-> (slurp "data/day05.txt")
(clojure.string/split #","))))
;;mem


(defn pow [x n]
    (apply * (repeat n x)))

 (pow 10 2)

(defn opcode [{:keys [mem ip]}]
    (mem ip))

(defn param [state n]
    (let [{:keys [mem ip]} state]
    (mem (+ ip n))))

(defn operation [opcode]
           (mod opcode 100))

(defn mode [opcode n] 
    (if ( = 0 (mod 
     (quot opcode 
           (pow 10 (inc n)))
     10)) :pos :imm))
    

(defn paramval [state n]
    (if (= :imm (mode (opcode state) n))
        (param state n)
        ((state :mem) (param state n))
        )
    )


(mode 1200 3)
;; (run mem)


(defn doinput [state]
    (let [
          {:keys [mem input]} state
          param1 (param state 1)
          mem (assoc mem param1 input)
          ]
        (update (assoc state :mem mem) :ip +  2))
        )
    


(defn dooutput [state]
    (let [
          param1 (paramval state 1)
          ]
        ;;(println newoutput)
        (update (update state :ip + 2)
               :output conj param1 ) 
         
         )
        
        )
    

(defn doplus [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (param state 3)
    
          mem (assoc (state :mem) target (+ param1 param2))
          
          ]
        ;;(println (str target "," param1 "," param2))
        (update (assoc state :mem mem) :ip + 4)
        )
    )

(defn domult [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (param state 3)
    
          mem (assoc (state :mem) target (* param1 param2))
          
          ]
        ;;(println (str target "," param1 "," param2))
        (update (assoc state :mem mem) :ip + 4)
        )
    )

(defn doequals [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (param state 3)
        targetval (if (= param1 param2) 1 0)   
          mem (assoc (state :mem) target targetval)         
          ]
        ;;(println (str target "," param1 "," param2))
        (update (assoc state :mem mem) :ip + 4)
        )
    )

(defn doless [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (param state 3)
        targetval (if (< param1 param2) 1 0)  
        mem (assoc (state :mem) target targetval)
          ]
        ;;(println (str target "," param1 "," param2))
        (update (assoc state :mem mem) :ip + 4)
        )
    )

(defn dojumptrue [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)         
          ]
    (if (not (zero? param1))
        (assoc state :ip param2)     
        (update state :ip + 3)
        )
    ))

(defn dojumpfalse [state]
    (let [
    
        param1 (paramval state 1)
        param2 (paramval state 2)
    

          
          ]
    (if  (zero? param1)
        (assoc state :ip param2)     
        (update state :ip + 3)
        )
    ))



(defn step [state] 
    ;;(println state)
    ;;(println pos)
        (let [
          operation (operation (opcode state))
          ]
              
    (case operation
        1 (doplus state)
        2 (domult state)
        3 (doinput state)
        4 (dooutput state)
        5 (dojumptrue state)
        6 (dojumpfalse state)
        7 (doless state)
        8 (doequals state)
        99 (assoc state :halted true)
        (throw 
         (Exception. 
          (str "unknown op " operation))))))

(defn run [mem input]
    "Run the progam in mem with input and return a sequence of all outputs"
   (:output (last (take-while #(not (:halted %))
     (iterate step {:mem mem :output [] :input input :ip 0 :halted false})))))
     


(run mem 1)

(last (run mem 1))

(last (run mem 5))
