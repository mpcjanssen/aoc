import strformat
import tables

type 
  State = enum
    stIdle, stRunning, stInputPending, stStopped 

  NimtCode = ref object of RootObj
    pc: int
    mem: TableRef[int,int]
    state: State


var m = NimtCode(pc:0, mem: newTable[int,int](), state: stRunning)

while true:
    echo fmt"{m.state}"