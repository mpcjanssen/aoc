(def mem
    (into [] (map read-string (-> (slurp "data/day02.txt")
(clojure.string/split #",")))))
mem

(defn opcode [state]
    ((state :mem) (state :ip)))



(defn step [state] 
    ;; (println state)
    ;;(println pos)
    (if (= (opcode state) 99)
        (assoc state :halted true)
        (let [
          opcodes {1 + 2 *}
          oc (opcode state)
          mem (state :mem)
          ip (state :ip)
          arg1 (mem (mem (+ ip 1)))
          arg2 (mem (mem (+ ip 2)))
          target (mem (+ ip 3))]
        {:mem (assoc mem target ((opcodes oc) arg1 arg2)) :ip (+ ip 4) :halted false} )))

(defn run [mem]
   (:mem (last (take-while #(not (:halted %))
     (iterate step {:mem mem :ip 0 :halted false})))))
     
(run [2 4 4 5 99 0])

(defn run-program [mem noun verb]
    (run (assoc (assoc mem 1 noun) 2 verb)))


(run-program data 12 2)

(defn solve [z]
(first (for [ noun (range 100) verb (range 100)
     :let [endstate (run-program data noun verb)]
     :when (= (endstate 0) z)]  
                 {:noun noun :verb verb})))
   

(def solution (solve 19690720))
solution


(run-program data 38 92)

(+ (* 100 (solution :noun))
   (solution :verb))




