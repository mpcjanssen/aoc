(ns day06
   (:require [clojure.string :as str]
              [clojure.set :as s]))



(defn data []
    (-> (slurp "data/day06.txt")
        (str/split-lines)))
(take 5 (data))


(def testdata (str/split-lines "COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L"))
testdata

(defn addorbit [orbits spec]
          (let [{l 0 r 1} (str/split spec #"\)")]
              (assoc orbits r l)))
    

(defn orbits [input]
    (assoc (reduce addorbit {} input) "COM" nil))


(orbits testdata)


(defn path [pt id ]
    (take-while  identity (iterate 
    #(pt %) id)))


    

(path pt "K")

(def pt (process testdata))
(reduce + (map #(dec (count (path pt (first %)))) pt))



(def pt (process (data)))
(reduce + (map #(dec (count (path pt (first %)))) pt))



(-(count (filter #(= 1 (last %)) (frequencies (into (path pt "YOU") (path pt "SAN"))))) 2)

