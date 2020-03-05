(def input "<x=3, y=15, z=8>
<x=5, y=-1, z=-2>
<x=-10, y=8, z=2>
<x=8, y=4, z=-5>")

(defrecord Moon [p v])

(def moons 
    [
      {:p [3 15 8] :v [0 0 0]}      
      {:p [5 -1 -2] :v [0 0 0]}      
      {:p [-10 8 2] :v [0 0 0]}      
      {:p [8 4 -5] :v [0 0 0]}                
            
    ])

(def rmoons 
    [
      (Moon. [3 15 8] [0 0 0])     
      (Moon. [5 -1 -2]  [0 0 0])  
      (Moon. [-10 8 2]  [0 0 0])    
      (Moon. [8 4 -5]  [0 0 0])                
            
    ])


(def testinput "<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
")

(def testmoons 
    [
      {:p [-1 0 2] :v [0 0 0]}      
      {:p [2 -10 -7] :v [0 0 0]}      
      {:p [4 -8 8] :v [0 0 0]}      
      {:p [3 5 -1] :v [0 0 0]}                
            
    ])

(def test2 "<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
")

(def test2moons 
    [
      {:p [-8 -10 0] :v [0 0 0]}      
      {:p [5 5 10] :v [0 0 0]}      
      {:p [2 -7 3] :v [0 0 0]}      
      {:p [9 -8 -3] :v [0 0 0]}                
            
    ])


(defn dv-ax [[c1 c2]]
    (cond
        (< c1 c2) 1
        (= c1 c2) 0
        (> c1 c2) -1))


(defn dv [p1 p2]
    (map
     #(dv-ax %)
    
    (map vector p1 p2 )
    ))


(dv [6 2 5] [6 3 2])


(defn addp [p1 p2]
    (mapv #(+ (first %) (last %)) (map vector p1 p2)
    ))

(map + [1 1 5] [-1 3 2])



(defn newv [moon all] 
    (let 
        [
         dvs (mapv #(dv (:p moon) (:p %)) all)
         ]
        (reduce  #(mapv + %1 %2 ) (:v moon) dvs)
))

(defn dograv [all]
    (mapv #(assoc % :v (newv % all)) all)
         )
         
(defn dopos [all]
    (mapv 
     #(assoc % :p (addp (:p %) (:v %)) )
     all
    ))

(defn step [all]

(dopos (dograv all)))
    

(defn step2 [[n all]]

[(inc n) (dopos (dograv all))])
    

(first (drop 1000 (iterate step rmoons)))




(defn energy [p]
    (reduce #(+ %1 (Math/abs %2)) 0 p))


(apply + (map #(*
        (energy (first %))
       (energy (last %))
                ) (map vals
(first (drop 1000 (iterate step moons)))
 )))

(defn get-axis [m n]
    ;;(println m)
    (let [
          pa ((:p m) n)
          va ((:v m) n)
          
          ]
        [pa va]
        )
    )
(defn full-axis [all n]
    (map #(get-axis % n) all))

(set! *print-length* 20)

(defn find-period [all n c axes]
    (let [axs (full-axis  all n)
          idx (axes axs)
          ;;_ (println axes)
          ;;_ (println ax)
    
          ]
    (if idx
        (do (println axs)
            (- c idx))
        (recur (step all) n (inc c) (assoc axes axs c)))
    ))

(defn periods [all] 
    (for [n (range 3)]
    
(find-period all n 0 {}) ))
        

(defn periods2 [all]
    (for [n (range 3)
        :let [xinit (full-axis all n)]]
  (first (first (filter
    #(= xinit (full-axis  (last %) n))
    (drop 1 (iterate step2 [0 all])))
    ))))



(def prime-numbers
  ((fn f [x]
     (cons x
       (lazy-seq
         (f (first
              (drop-while
                (fn [n]
                  (some #(zero? (mod n %))
                    (take-while #(<= (* % %) n) prime-numbers)))
                (iterate inc (inc x))))))))
   2))

(defn factorize [n]
  ((fn f [n [h & r :as ps]]
     (cond (< n 2) '()
       (zero? (mod n h)) (cons h (lazy-seq (f (quot n h) ps)))
       :else (recur n r)))
   n prime-numbers))

(def ps (time (doall (periods2 rmoons))))


(set! *warn-on-reflection* true)
(time (doall (periods2 rmoons)))



(defn smallest-period [ps] 
      (apply * 1N (mapcat 
   #(repeat (last %) (first %))

(apply merge-with max

(map (comp frequencies factorize) ps)))))

        
   (smallest-period ps)

(time (dotimes [n 100000] (full-axis rmoons 0)))


