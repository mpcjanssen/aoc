(require '[clojure.string :as s])

        
         

(defn parse-line [line]
    (let [
            [from to] (reverse)
                     (map reverse (map #(s/split (s/trim %) #"(, | )") (s/split line #"=>")))
            to (partition 2 to)
            [compound amount] from
            [compound (reduce
                        #(assoc %1 (first %2) (/ (read-string (second %2)) (read-string amount)))
                        {}
                        to)]]))
         
          
          

(defn parse [input]
    (apply 
      hash-map 
      (mapcat parse-line 
          (s/split input #"\n"))))





          
          

(def data (parse (slurp "data/day14.txt")))
data

(data "FUEL")

(defn ore-amount [[compound amount] data]
   ;;(println (str amount ":" compound))
   (if (= compound "ORE") 
       amount
     (let [
           to (data compound)]
           ;;_ (println to)]
            
         (reduce-kv 
           #(+ %1 (ore-amount [%2 %3] data) %3)
          0
          to))))
        
      
       
        

(println (ore-amount ["FUEL" "1"] data))



(def data2 (parse "9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL"))
data2

(ore-amount ["FUEL" 1] data2)


