(require '[clojure.string :as s] )



(defn puzzleinput []
    (-> "data/day10.txt"
        (slurp)
    ))

(defn find-astroids [spec]
 (keep-indexed #(if (= "#" %2) %1 ) (map str spec)))


(defn locations [input]
    (let [lines (s/split-lines input)]
    (for [y (range 0 (count lines))
          x (find-astroids (lines y))]
        [x y])))

;;(locations (puzzleinput))



(defn clamped [a b x]
    (or
     (<= a x b)
     (<= b x a)))

(defn blocks [start end p]
    (if (or (= p start)
            (= p end)) false
    (let [
          [s1 s2] start
          [e1 e2] end
          [p1 p2] p
          ]
    (cond
     (not (clamped s1 e1 p1)) false
     (not (clamped s2 e2 p2)) false
     (and (= (- s1 p1) 0) 
          ( = (- p1 e1) 0)) true
     (= (- s1 p1) 0) false
     (= (- e1 p1) 0) false
     
     :else 
     (= 
      (/ (- s2 p2) (- s1 p1))
      (/ (- e2 p2) (- e1 p1))
      
      )
    
     
     ))))

;;(blocks [3 0] [1 4] [2 2])
;;(blocks [3 0] [3 0] [3 1])
(blocks [1 0] [3 3] [0 0])

(blocks [3 3] [6 1] [5 1])

(= (/ 3 4) (/ 6 8))

(defn blocker [s e all]
    (first (filter #(blocks s e %) all)))


;;(vis [1 0] [1 0] (locations (puzzleinput)))

;;(count (locations (puzzleinput)))

(defn all-vis [p all]
    (remove #(= p %) (filter 
      #(not (seq (blocker % p all)))
     
     all) )
    
    )

;;(all-vis [1 0] (locations (puzzleinput)))



(set! *print-length* 15)
(defn solve [all f] 
    (let [
  res (reduce 
 #(assoc %1 %2 (f (all-vis %2 all)))
 {}      
 all )]  res))
    
;;(solve (locations )(puzzleinput))

(let [all (locations 
        ".#..#
.....
#####
....#
...##")]
    ((solve all count) [3 4]))

    (time (apply max-key val (let 
       [all (locations (puzzleinput))
    res (solve all count)] 
     res)))



(all-vis [20 19] (locations (puzzleinput)))

(defn angle [[p1 p2]]
     (mod (+ (Math/toDegrees (Math/atan2 
      (- p2 19)
      (- p1 20))
    ) 90 ) 360))
    

(angle [1 19])

(nth (sort-by 
 #(angle %)
(all-vis [20 19] 
         (locations (puzzleinput)))) 199)
               
               

(defn angle2 [[p1x p1y] [p2x p2y]]
     (mod (+ (Math/toDegrees (Math/atan2 
      (- p2y p1y)
      (- p2x p1x))
    ) 90 ) 360))
    

(defn dist2 [[p1x p1y] [p2x p2y]]
    (let [
          dx (- p2x p1x)
          dy (- p2y p1y)]
        (+ (* dx dx)  (* dy dy))))
          
          


(defn closest [x xs]
    (first (sort-by
            #(dist2 x %) xs
            
            )
    ))



(defn vis2 [x all]
    (map 
     #(closest x %)
     (map last (group-by #(angle2 x % )
     all))))



(set! *print-length* 15)
(defn solve2 [all f] 
    (let [
  res (reduce 
 #(assoc %1 %2 (f (vis2 %2 all)))
 {}      
 all )]  res))
    
;;(solve (locations )(puzzleinput))

            

    (time (apply max-key val (let 
       [all (locations (puzzleinput))
    res (solve2 all count)] 
     res)))



            

(time (nth (sort-by 
 #(angle %)
(vis2 [20 19] 
         (locations (puzzleinput)))) 
           199))
               
               
