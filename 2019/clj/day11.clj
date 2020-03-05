(defn mem []
        (mapv read-string (-> (slurp "data/day11.txt")
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
         
         

  



 (set! *print-length* 10)
;; (run (read-string "[109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]") [])
;; (run (read-string "[1102,34915192,34915192,7,4,7,99,0]") [])
;;(run (read-string "[104,1125899906842624,99]") [])
(run-to-signal (init-prog (mem)) [1])

 

(defn orient [[dx dy] newspec]
    (case [dx dy newspec]
        [0 1 0] [1 0]
        [0 1 1] [-1 0]
        
        [0 -1 0] [-1 0]
        [0 -1 1] [1 0]
  
        [1 0 0] [0 -1]
        [1 0 1] [0 1]

        [-1 0 0] [0 1]
        [-1 0 1] [0 -1]
     
        )
    ) 

(defn- continue-paint-hull [hull robot]
      ;;(println  (robot :prog))
       (let 
           [
             color (hull (robot :pos) 0 )
            ;;_ (println (str color ", " (robot :orient)))
            res (run-to-signal (robot :prog) [color])
            ;;_ (println res)
            signal (:signal res)
            [newcol orientspec] (:output res)
            newhull (assoc hull (robot :pos) newcol)
            [dx dy] (orient (robot :orient) orientspec)
            [cx cy] (robot :pos)
            newpos [(+ cx dx) (+ cy dy)]
            newrobot {
                :pos newpos
                :orient [dx dy]
                :prog (assoc res :output [])}
             ]
           (case signal
               :input (recur newhull newrobot)
                :halt newhull
                :error)
       ))

(defn paint-hull [mem]
    (let [
     hull {}
     robot 
     {:pos [0 0]
      :orient [0 -1]
      :prog (init-prog mem)
      }
     
     ]
    
    (continue-paint-hull hull robot)))

 (count (paint-hull (mem)))

(defn paint-hull2 [mem]
    (let [
     hull {[0 0] 1}
     robot 
     {:pos [0 0]
      :orient [0 -1]
      :prog (init-prog mem)
      }
     
     ]
    
    (continue-paint-hull hull robot)))

(def id (paint-hull2 (mem)))
id


(apply max (sort (map #(first %) (keys id ))))

 (last (sort (map #(last %) (keys id ))))



(defn transpose [m]
  (apply mapv vector m))

(defn showline [l]
    (reverse (map #(if (= 0 %) "." "@") l)))

(doseq [l (map #(apply str %) (map   showline (transpose (partition 43 (for [y (range  6) x (range 43)]
   (id [x y] 0) ))) ))] (println l))


%run day10.ipynb
