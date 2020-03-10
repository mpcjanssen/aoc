open Bigarray

let w = Array2.create char c_layout 30 30 
w.{1,2} <- 'c'