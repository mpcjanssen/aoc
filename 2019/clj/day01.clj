(defn data [] (-> (slurp "data/day01.txt")
            dsdadsda
                  (clojure.string/split-lines)))

(defn fuel-mass [mass]
 (- (quot mass 3) 2))

(fuel-mass 14)

(reduce +
        (map  
         #(->
              %
              (read-string)
              (fuel-mass))
         (data)))

(defn total-fuel-mass 
    ([mass] (total-fuel-mass 0 mass))
    ([curr extra] 
               (let [delta (fuel-mass extra)] 
                   (if (< delta 1) curr
                   (recur (+ curr delta ) delta )
         ))))
    

(total-fuel-mass 100756)

(reduce 
 + 
 (map
         #(-> 
                   % 
                   (read-string)
                   (total-fuel-mass))
              (data)))

(data)
