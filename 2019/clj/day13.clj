(defn mem []
        (mapv read-string (-> (slurp "data/day13.txt")
                              (clojure.string/split #","))))

;;(mem)


(defn pow [x n]
    (apply * (repeat n x)))

 (pow 10 2)

(defn opcode [{:keys [mem ip]}]
    ;;(println mem)
    (get mem ip 0))

(defn param [state n]
    (let [{:keys [mem ip]} state]
    (get mem (+ ip n) 0)))

(defn operation [opcode]
           (mod opcode 100))

(defn mode [opcode n] 
    (case (mod 
     (quot opcode 
           (pow 10 (inc n)))
     10) 0 :pos 1 :imm 2 :rel))
    

(defn paramval [state n]
    (let [raw (param state n)]
      ;;  (println raw)
    (or (case (mode (opcode state) n)
        :imm (param state n)
        :pos ((:mem state) (param state n) 0)
        :rel ((:mem state) (+ (:base state) (param state n)) 0)
        )
    0 )))

(defn targetval [state n]
    (case (mode (opcode state) n)
       :rel (+ (:base state) (param state n))
        (param state n)
        )
 )


(mode 1001 1)
;; (run mem)



(defn doinput [state]
  ;;  (println state)
    
 ;;   (dump-state state)
    (if (seq (:input state))
    (let [
          {:keys [mem input base]} state
          mode (mode (opcode state) 1)
          param1 (targetval state 1)
          ;;_ (println (str "tar: " param1 " " mode))
          mem (assoc mem param1  (first input))
          ]
        (update (update (assoc state :mem mem) 
                        :ip +  2) :input rest)
        )
    (assoc state :signal :input)))
    

(defn dooutput [state]
    (let [
          param1 (paramval state 1)
    
          ]
        (update (update state :ip + 2)
               :output conj param1 ) 
         
         )
        
        )
    

(defn dobase [state]

    (let [
        
          param1 (paramval state 1)
          ;;_ (println "xxxx")
          ;;_ (println param1)

          newstate (update (update state :ip + 2)
               :base + param1 )
          ;;_ (println newstate)] newstate
          ] newstate
        
        ))
    

(defn domult [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (targetval state 3)
    
          mem (assoc (:mem state) target (* param1 param2))
          
          ]
        ;;(println (str target "," param1 "," param2))
        (update (assoc state :mem mem) :ip + 4)
        )
    )

(defn doplus [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (targetval state 3)
    
          mem (assoc (:mem state) target (+ param1 param2))
          
          ]
       ;; (println (str target "," param1 "," param2))
        (update (assoc state :mem mem) :ip + 4)
        )
    )

(defn doequals [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (targetval state 3)
        res (if (= param1 param2) 1 0)   
          mem (assoc (:mem state) target res)         
          ]
       ;; (println (str target "," param1 "," param2))
        (update (assoc state :mem mem) :ip + 4)
        )
    )

(defn doless [state]
    (let [
        param1 (paramval state 1)
        param2 (paramval state 2)
        target (targetval state 3)
        res (if (< param1 param2) 1 0)  
        mem (assoc (:mem state) target res)
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
    ;;(println (state)
    ;;(println pos)
        (let [
          oc (opcode state)
           ;;   _ (println oc)
          op (operation oc)
          ]
    ;;(println oc)
              
    (case op
        1 (doplus state)
        2 (domult state)
        3 (doinput state)
        4 (dooutput state)
        5 (dojumptrue state)
        6 (dojumpfalse state)
        7 (doless state)
        8 (doequals state)
       9 (dobase state)
        99 (assoc state :signal :halt)
        (throw 
         (Exception. 
          (str "unknown op " operation))))))
     


(defrecord Intcode [mem input output base ip signal])



(defn init-prog [mem]
       ;; (println input)
        (Intcode.
          (into {} (map-indexed vector mem))
          ()
                
          []  0  0  nil) )
    
 (defn clear-signal [prog]
     (assoc prog :signal nil))
     
(defn dump-state [{:keys [signal input output]}]
    (str   "signal: " signal
         ", input: " input
         ", output: " output
         ))


(init-prog [1 2])    
     
  


(defn run-to-signal [prog input]
    (let [
          prog 
          (clear-signal (assoc prog :input input))
          ]
   ;; (println input)
        ;; (take 5 (iterate step prog))))
        (first (filter #(:signal %) (iterate step prog)))))
         
         

  



(set! *print-length* 25)

(def output 
    (
     :output
     (run-to-signal (init-prog (mem)) nil)))
               
output


(defn run-to-signal [prog input]
    (let [
          prog 
          (clear-signal (assoc prog :input input))
          ]
   ;; (println input)
        ;; (take 5 (iterate step prog))))
        (first (filter #(:signal %) (iterate step prog)))))
         
         

  



(defn blocks [output]

   (filter #(= (last %) 2 )
           (partition 3 output) 
    
))

(count (blocks  (:output
        (run-to-signal (init-prog (mem)) nil))))



(defn run-to-signal [prog input]
    (let [
          prog 
          (clear-signal (assoc prog :input input))
          ]
   ;; (println input)
        ;; (take 5 (iterate step prog))))
        (first (filter #(:signal %) (iterate step prog)))))
         
         

  





(defn ballxpos [output]
    (first (last (filter #(= (last %) 4)
                (partition 3 output))
    )))

(defn paddlexpos [output]
    (first (last (filter #(= (last %) 3)
                (partition 3 output))
    )))

(defn score [output]
    (last (last (filter #(= 
                    [(first %) (second %)]
                     [-1 0]  )
                (partition 3 output))
    )))


(set! *print-length* 25)

(defn run-game [prog input]
    (let [
          state (run-to-signal prog input)
          signal (:signal state)
          output (:output state)
          score (score output)
          paddle (paddlexpos output)
          ball (ballxpos output)
          input (compare ball paddle)
          ]
        ;; (println score)
         ;; (println paddle)
          (case signal
              :halt score
             :input (recur (assoc state :output []) [input]))))
            ;;  :input score)))
      
      
(run-game (init-prog (assoc (mem) 0 2)) nil)
               

