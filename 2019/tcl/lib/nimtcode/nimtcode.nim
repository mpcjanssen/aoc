from tclstubs as Tcl import nil
import tables
import strformat
import strutils



type 
  State = enum
    stIdle, stRunning, stInputPending, stStopped 

  NimtCode = ref object of RootObj
    pc: int
    base: int
    mem: TableRef[int,int]
    state: State


proc newNimtCode(mem: TableRef[int,int]) : NimtCode =
  return NimtCode(pc: 0, mem: mem, state: stIdle, base: 0)


proc getAddress(machine: NimtCode, param, mode: int) : int =
  case mode:
  of 0: 
    return param
  of 2: 
    return param + machine.base
  else:
    echo "Invalid getAddress mode: " & $mode

proc getValue(machine: NimtCode, param, mode:int) : int =
  case mode:
  of 0: 
    return machine.mem.getOrDefault(machine.getAddress(param,mode),0)
  of 1: 
    return param
  else:
    echo "Invalid getValue mode: " & $mode

  return 0

proc step(machine: NimtCode) =
  let pc = machine.pc
  let inst = machine.mem.getOrDefault(pc,0)
  # echo "~~~~~~~~~~~~" & $pc
  let param1 = machine.mem.getOrDefault(pc+1,0)
  let param2 = machine.mem.getOrDefault(pc+2,0)
  let param3 = machine.mem.getOrDefault(pc+3,0)
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

proc setMem(machine: NimtCode, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc != 4:
    Tcl.WrongNumArgs(interp, 2, objv, "idx val")
    return Tcl.ERROR
  var idx = parseInt($(Tcl.GetString(objv[2])))
  var val = parseInt($(Tcl.GetString(objv[3])))
  machine.mem[idx] = val
  return Tcl.OK

proc getMem(machine: NimtCode, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc != 3:
    Tcl.WrongNumArgs(interp, 2, objv, "idx")
    return Tcl.ERROR
  var idx = parseInt($(Tcl.GetString(objv[2])))
  Tcl.SetObjResult(interp,Tcl.NewIntObj(machine.mem.getOrDefault(idx,0)))

  return Tcl.OK

proc run(machine: NimtCode, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc != 2:
    Tcl.WrongNumArgs(interp, 2, objv, nil)
    return Tcl.ERROR
  # echo machine.mem
  machine.state = stRunning
  while machine.state == stRunning:
    machine.step

  return Tcl.OK

proc NimtCodeInstance_Del(clientData: Tcl.TClientData) =
  var m = cast[ptr NimtCode](clientData)[]
  echo m.repr
  GC_unref(m)

  

proc NimtCodeInstance_Cmd(clientData: Tcl.TClientData, interp: Tcl.PInterp, objc: cint, objv: Tcl.PPObj): cint =
  if objc < 2:
    Tcl.WrongNumArgs(interp, 1, objv, "subcmd")
    return Tcl.ERROR
  

  var m = cast[ptr NimtCode](clientData)
  # echo m.mem
  # echo m.repr
  var subCmd = $Tcl.GetString(objv[1])
  case subCmd:
    of "setmem":
      return m[].setMem(interp, objc, objv)
    of "mem":
      return m[].getMem(interp,objc,objv)
    of "run":
      return m[].run(interp, objc, objv)
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

  var prog = split($progObj, ',')
  # echo "+++++++++++" & $prog.len
  # echo cmdName
  # echo m.repr
  var mem = newTable[int,int]()
  for idx in 0..prog.len-1:
    mem[idx] = prog[idx].parseInt
  var m  = newNimtCode(mem)
  GC_ref(m)
  


  discard Tcl.CreateObjCommand(interp,  "test", NimtCodeInstance_Cmd, cast[Tcl.TClientData] (addr m),NimtCodeInstance_Del)
  Tcl.SetObjResult(interp, Tcl.NewStringObj("test",-1))
  num.inc
  return Tcl.OK


proc Nimtcode_Init(interp: Tcl.PInterp): cint {.exportc,dynlib.} =
  discard Tcl.InitStubs(interp, "8.5",0)
  if Tcl.CreateObjCommand(interp, "NimtCode", NimtCode_Cmd, nil, nil)!=nil:
    return Tcl.OK
  else:
    return Tcl.ERROR