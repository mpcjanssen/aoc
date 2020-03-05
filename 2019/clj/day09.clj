(ns day7)
    (require  
     '[clojure.core.matrix :as m]
     )
*ns*

(defn mem []
        (mapv read-string (-> (slurp "data/day09.txt")
(clojure.string/split #","))))
(mem)


(defn pow [x n]
    (apply * (repeat n x)))

 (pow 10 2)

(defn opcode [{:keys [mem ip]}]
    (mem ip 0))

(defn param [state n]
    (let [{:keys [mem ip]} state]
    (mem (+ ip n) 0)))

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
        :pos ((state :mem) (param state n) 0)
        :rel ((state :mem) (+ (state :base) (param state n)) 0)
        )
    0 )))

(defn targetval [state n]
    (case (mode (opcode state) n)
       :rel (+ (state :base) (param state n))
        (param state n)
        )
 )


(mode 1001 1)
;; (run mem)



(defn doinput [state]
    (let [
          {:keys [mem input base]} state
          mode (mode (opcode state) 1)
          param1 (targetval state 1)
          ;;_ (println (str "tar: " param1 " " mode))
          mem (assoc mem param1  (first input))
          ]
        (update (assoc state :mem mem :yield false) 
                        :ip +  2)
        ))
    


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
    
          mem (assoc (state :mem) target (* param1 param2))
          
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
    
          mem (assoc (state :mem) target (+ param1 param2))
          
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
          mem (assoc (state :mem) target res)         
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
        mem (assoc (state :mem) target res)
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
          oc (opcode state)
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
        99 (assoc state :halted true)
        (throw 
         (Exception. 
          (str "unknown op " operation))))))
     


(defn init-prog [mem input]
              
        { :mem (into {}
          (map-indexed vector mem))
         :input  input
                
         :output [] :base 0 :ip 0 :halted false :yield false} 
    )
    
 
     
(defn dump-state [{:keys [halted newout input output]}]
    (
     
     "halted: " halted
         ", newout: " newout
         ", input: " input
         ", output: " output
         ))


;;(init-amps [1 2])    
     
  


(defn run [mem input]
     (let 
         [
          prog (init-prog mem input)
          
          ]
        ;; (take 5 (iterate step prog))))
        (first (filter #(:halted %)(iterate step prog)))))
         
         

  



 (set! *print-length* 10)
;; (run (read-string "[109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]") [])
;; (run (read-string "[1102,34915192,34915192,7,4,7,99,0]") [])
;;(run (read-string "[104,1125899906842624,99]") [])
(run (mem) [1])



 (set! *print-length* 10)
;; (run (read-string "[109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]") [])
;; (run (read-string "[1102,34915192,34915192,7,4,7,99,0]") [])
;;(run (read-string "[104,1125899906842624,99]") [])
(time (run (mem) [2]))




