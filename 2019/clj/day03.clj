(ns  day3 (:require [clojure.set :as s]) )

(defn parse-line [line]
  (into [] 
       (clojure.string/split line #",")))


(def data (with-open [rdr (clojure.java.io/reader "./data/day03.txt")]
    (doall (map parse-line (line-seq rdr)))))

;;data


(defn spec-dir [spec] (subs spec 0 1))
(defn spec-dist [spec] (read-string (subs spec 1)))

      

(spec-dist "U123")

(defn create-line [start spec]
    (let [
          dir (spec-dir spec)
          dist (spec-dist spec)
          x (start 0)
          y (start 1)
          dx (case dir
                 "L" -1
                 "R" 1
                 0)
          dy (case dir
                 "U" -1
                 "D" 1
                 0)
          
          
          ]
        (for [d (range 0 (inc dist))]
            [(+ x (* dx d))
               (+ y (* dy d))]
            
            )
             ))


(create-line [0 0] "L21" )


(defn add-segment [line spec]
    (into line 
         (rest (create-line (last line) spec))))


( add-segment [[0 0] [1 1]] "U4")


(into [[0 0]] [[1 1][2 2]])

(defn full-line [start specs]
    (reduce 
     #(add-segment %1 %2 )
     [start] specs)
    ) 


(println (full-line [0 0] ["U12" "L4" "D12" "R4"]))


(def lines (map #(full-line [0 0] %) data ))

(count lines)

(defn manhattan [p1 p2]
    (let [
          dx  (Math/abs (- (p1 0) (p2 0)))
           dy (Math/abs (- (p1 1) (p2 1)))
         ]
        (+ dx dy)
        )
    )

(manhattan [0 0] [12 -11])




(def points (
             map #(into #{} %) lines))


(time (def crossings (apply  s/intersection points)))
;; crossings


 (second (sort (map #(manhattan [0 0] %) crossings)))
     
     

(defn steps [line p]
    (.indexOf line p))

(steps [[1 1] [2 2]] [2 2])



(time (second (sort (let [
      line1 (first lines)
      line2 (second lines)
      ]
    
    (for [p crossings]
        
        (+ (steps line1 p)
         (steps line2 p)))))))
