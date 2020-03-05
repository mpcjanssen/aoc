(ns day8)

(def data 
    (map read-string (map str (slurp "data/day08.txt"))))
;;data



(defn layers [data width height]
    (let [
          ppl (* width height)
          ]
    (partition ppl data ))
 
 )




(let [check-layer
    
    (first (sort-by #(% 0) 
         (map frequencies 
              (layers data 25 6))))]
    (* (check-layer 1)
       (check-layer 2)))


(defn transpose [m]
  (apply mapv vector m))



(defn color [pixel]
    (case (first (filter #(not (= % 2)) pixel)
    )
    1 "@"
    0 " "
    ))

(let [
        l      (layers data 25 6)
      pixels
      (transpose l)]
    (doseq [line 
    (partition 25 (map color pixels))]
        (println (apply str line))
    ))

