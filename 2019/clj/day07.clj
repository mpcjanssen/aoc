(require '[clojupyter.misc.helper :as helper])
(helper/add-dependencies
'[org.clojure/math.combinatorics "0.1.6"]) 

(ns day7)
    (require  '[clojure.math.combinatorics :as combo])
*ns*

(defn mem []
    (mapv read-string (-> (slurp "data/day07.txt")
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
    (if (not (seq (state :input)))
    (assoc state :yield true)
    (let [
          {:keys [mem input]} state
          param1 (param state 1)
          mem (assoc mem param1 (first input))
          ]
        (update (update (assoc state :mem mem :yield false) 
                        :ip +  2)
                :input #(drop 1 %)))
        ))
    


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
     


(defn process-input [id program]
   ;(println (str "xxxx " id))
    (let [res (step program)]
        
  (if  (or (:yield res) (:halted res))
     res
      (recur id res)
      )))


(defn init-amps [phases]

     (reduce  
      #(assoc 
        %1 %2 
              
        { :mem (mem )
         :input (if (= %2 (first phases)) [%2 0] [%2])
                
         :output [] :ip 0 :halted false :yield false} ) 
      {} phases))
    
    
 
     
(defn dump-state [{:keys [halted newout input output]}]
    (
     
     "halted: " halted
         ", newout: " newout
         ", input: " input
         ", output: " output
         ))


;;(init-amps [1 2])    
     
  


 (defn loop-step [[amps ctxts]]
    
     (let [
           [c n] (first ctxts)
           ;;_ (println c)
           
           amp (amps c)
           ;;_ (println (amp :input))
           
           newamp (amps n)
           res  (process-input c (assoc amp :output []))
           output (last (res :output))
           ;;_ (println (res :output))
           ;;clearout (assoc res :output [] :yield false)
           nextamp  (update newamp 
                          :input  conj output)]
           
         ;;(println output)
            [(assoc amps n nextamp  c res)           
           
         (drop 1 ctxts)]
         )
     )


(defn run-loop [order]
     (let 
         [
          amps (init-amps order)
          
          ctxts (partition 2 1 (cycle order))
          ]
         (iterate loop-step [amps ctxts])))
         
         
(defn runfororder [order]
 (last (:output ((first (loop-step (last (take-while 
 #(not (:halted ((first %1) (last order))))
 (run-loop order))))) (last order))))
    )

;;(first 
;; (drop 6
;; (run-loop [5 6 7 8 9])))

  



 (apply max (map runfororder (combo/permutations (range  5))))



 (apply max (map runfororder (combo/permutations (range 5 10))))


