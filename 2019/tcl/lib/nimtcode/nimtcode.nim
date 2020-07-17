from tclstubs as Tcl import nil
import tables
import strformat
import strutils



type 
  State = enum
    stIdle, stRunning, stInputPending, stStopped 

  NimtCode = object
    pc: int
    base: int
    mem: array[3000,int]
    state: State

  PNimtCode = ptr NimtCode


proc newNimtCode(prog: seq[string]) : PNimtCode =
  echo "xxxxxxxx " & $prog
  var m: PNimtCode = cast[PNimtCode](alloc(sizeof NimtCode))
  m.pc = 0
  m.base = 0



  
  var idx = 0 
  for item in prog:
    echo item
    m.mem[idx] = item.parseInt
    idx.inc
    echo "::::" & $idx
  

  return m
  


proc getAddress(machine: PNimtCode, param, mode: int) : int =
  case mode:
  of 0: 
    return param
  of 2: 
    return param + machine.base
  else:
    echo "Invalid getAddress mode: " & $mode

proc getValue(machine: PNimtCode, param, mode:int) : int =
  case mode:
  of 0: 
    return machine.mem[machine.getAddress(param,mode)]
  of 1: 
    return param
  else:
    echo "Invalid getValue mode: " & $mode

  return 0

proc step(machine: PNimtCode) =
  let pc = machine.pc
  let inst = machine.mem[pc]
  let param1 = machine.mem[pc+1]
  let param2 = machine.mem[pc+2]
  let param3 = machine.mem[pc+3]
  let opcode = inst mod 100
  let mode = inst div 100
  let mode1 = mode mod 10
  let mode2 = mode div 10 mod 10
  let mode3 = mode div 100
  let val1 = machine.getValue(param1,mode1)
  let val2 = machine.getValue(param2,mode2)
  case opcode:
  of 1:
    machine.mem[machine.getAddress(param3,mode3)] = val1 + val2
    machine.pc+=4
  of 2:
    machine.mem[machine.getAddress(param3,mode3)] = val1 * val2
    machine.pc+=4
  of 99:
    machine.state = stStopped
  else:
    echo "Invalid opcode: " & $opcode
    quit(-1)

  # echo fmt"Got mem[{pc}] => {opcode}({param1}|{mode1}={val1}, {param2}|{mode2}={val2}, {param3}|{mode3})"

proc setMem(machine: PNimtCode, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc != 4:
    Tcl.WrongNumArgs(interp, 2, objv, "idx val")
    return Tcl.ERROR
  var idx = parseInt($(Tcl.GetString(objv[2])))
  var val = parseInt($(Tcl.GetString(objv[3])))
  echo $val
  machine.mem[idx] = val
  return Tcl.OK

proc getMem(machine: PNimtCode, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc != 3:
    Tcl.WrongNumArgs(interp, 2, objv, "idx")
    return Tcl.ERROR
  var idx = parseInt($(Tcl.GetString(objv[2])))
  Tcl.SetObjResult(interp,Tcl.NewIntObj(machine.mem[idx]))

  return Tcl.OK

proc run(machine: PNimtCode, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc != 2:
    Tcl.WrongNumArgs(interp, 2, objv, nil)
    return Tcl.ERROR
  echo machine.mem
  machine.state = stRunning

  while machine.state == stRunning:
    machine.step

  return Tcl.OK

proc NimtCodeInstance_Del(clientData: Tcl.TClientData) =
  var m = cast[PNimtCode](clientData)
  #echo m.repr
  dealloc(m)
  return

  

proc NimtCodeInstance_Cmd(clientData: Tcl.TClientData, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc < 2:
    Tcl.WrongNumArgs(interp, 1, objv, "subcmd")
    return Tcl.ERROR

  
  var m = cast[PNimtCode](clientData)
  # echo m.mem.repr  
  var subCmd = $Tcl.GetString(objv[1])
  case subCmd:
    of "setmem":
      return m.setMem(interp, objc, objv)
    of "mem":
      return m.getMem(interp,objc,objv)
    of "run":
      return m.run(interp, objc, objv)
    else:
      Tcl.SetObjResult(interp, Tcl.NewStringObj("invalid subcommand " & subCmd, -1))
      return Tcl.ERROR
  
  return Tcl.OK


var num = 0

proc NimtCode_Cmd(clientData: Tcl.TClientData, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  var cmdName = "nimtcode::" & $num
  
  if objc != 2:
    Tcl.WrongNumArgs(interp, 1, objv, "mem")
    return Tcl.ERROR
  
  # echo "_____" & $objc
  var progObj = Tcl.GetString(objv[1])
  echo $progObj
  var prog = split($progObj, ',')
  # echo "+++++++++++" & $prog.len
  # echo cmdName
  # echo m.repr

  var m  = newNimtCode(prog)
  # echo m.repr
  discard Tcl.CreateObjCommand(interp,  "test", NimtCodeInstance_Cmd, cast[Tcl.TClientData](m),NimtCodeInstance_Del)
  Tcl.SetObjResult(interp, Tcl.NewStringObj("test",-1))
  num.inc
  return Tcl.OK


proc Nimtcode_Init(interp: Tcl.PInterp): cint {.exportc,dynlib.} =
  discard Tcl.InitStubs(interp, "8.5",0)
  if Tcl.CreateObjCommand(interp, "NimtCode", NimtCode_Cmd, nil, nil)!=nil:
    return Tcl.OK
  else:
    return Tcl.ERROR