(set! *print-length* 10)
(set! *warn-on-reflection* true)

(require 
     asdasd
 '[clojure.string :as s])

(defn parse [data]
    (map read-string (map str data)))

(defn day-input []
                (slurp "data/day16.txt"))

(day-input)

(defn nop [a b] a)
 

(defn pattern [n m]
  ;;  (println (str n ":" m))
 (let [base [nop, +, nop, -]
       idx  (base (mod (quot  m n) 4))]
  idx))
 


(map #(pattern 1 %) (range 1 10))


(defn calculate-digit [input  n offset]
     ;;(println input)
       (let [start (+ n offset)]  
        (mod (Math/abs (last (reduce 
                              (fn [[c s]  d] 
                                  [(inc c) 
                                   ((pattern start  c ) s d)])
                              [start 0]
                              (drop (dec n) input)))) 10)))



(calculate-digit [1 2 3 4 5 6 7 8] 1 0)
                 



(defn fft-step [[input offset]]
 [(map-indexed (fn [idx digit] (calculate-digit input (inc idx) offset))
   input) offset])

(fft-step [[1 2 3 4 5 6 7 8] 0])



(defn fft [input steps offset]
   (first 
    (drop 
     steps 
     (iterate fft-step [(drop offset input) offset]))))



(println (fft (parse "69317163492948606335995924319873") 100 1))
(println (fft (parse "12345678") 4 0))
(time (println  (fft (parse (day-input)) 100 0)))



(def offset (read-string (apply str  (take 7 (day-input)))))
offset
         

(defn fast-digit [input n]
    (mod (apply + (drop (dec n) input)) 10))


(fast-digit [1 2 3 4 5] 3)

(defn ffft-step [input]
 (map-indexed 
  (fn [idx digit] (fast-digit input (inc idx)))
  input))

(ffft-step [1 2 3 4 5 6 7 8])



(defn ffft [input steps]
   (first 
    (drop 
     steps 
     (iterate ffft-step input))))





(println (ffft (parse "69317163492948606335995924319873") 100 ))
(println (ffft (parse "12345678") 4))
(time (println  (ffft (parse (day-input)) 100)))



(def input2 (apply vector (flatten (repeat 10000 (parse (day-input))))))
(time (println (take 8  (drop offset (ffft input2 100)))))
;;(count input2)


(defn day16 [^long part input]
  (let [signal (mapv #(Character/digit (char %) 10) (s/trim input))]
    (case part
      1 (let [pattern (fn [n] (rest (cycle (sequence (comp (map (partial repeat n)) cat) [0 1 0 -1]))))
              pattern-m (fn [n] (mapv #(into [] (take n) (pattern %)) (range 1 (inc n))))
              last-digit (fn [^long x] (rem (Math/abs x) 10))
              dot (fn [v w] (last-digit (reduce + (mapv * v w))))
              mmul (fn [m v] (mapv (partial dot v) m))]
          (apply str (take 8 (nth (iterate (partial mmul (pattern-m (count signal))) signal) 100))))
      2 (let [phase (fn [^ints arr] (loop [n (- (count arr) 2)]
                                      (when (>= n 0)
                                        (aset arr n (rem (+ (aget arr n) (aget arr (inc n))) 10))
                                        (recur (dec n)))))
              offset (Integer/parseInt (subs input 0 7))]
          (let [m (- (* 10000 (count signal)) offset)
                left (rem m (count signal))
                arr (int-array (take m (concat (take-last left signal) (cycle signal))))]
            (dotimes [_ 100] (phase arr)) (apply str (take 8 arr)))))))

(time (day16 2 (day-input)))

(mapv #(Character/digit (char %) 10) (s/trim (day-input)))


