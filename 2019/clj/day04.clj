(ns day04 (:require [clojure.string :as str]))

(def input "231832-767346")

 (def guards (str/split input #"-"))
(def start (read-string (first guards)))
(def end (read-string (second guards)))



(def cands (for [cand (range start (inc end)) 
    :let [digits (map read-string (str/split (str cand) #""))]
                 :when (and (apply <= digits) (not (apply < digits)))] digits ))


(first cands)



(count cands)

(count  (for [c cands :when (some #{2} (vals (frequencies c)))] c))



