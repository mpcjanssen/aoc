{%RunFlags MESSAGES+}
library pintcode.lpr;

{$mode objfpc}{$H+}
{$packrecords C}
{$TYPEDADDRESS ON}


{ Strings are UTF8 by default }
{$codepage utf8}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  ctypes,
  typinfo,
  gqueue,
  tcl;

type
  TStates = (stIdle, stRunning, stInputPending, stStopped);
  TIntList = specialize TQueue<Integer>;
  TModes = (modPos = 0, modImm = 1, modRel = 2);
  TIntCode = class
  public
    PC, Base: integer;
    State: TStates;
    Mem: array[0..1000] of integer;
    Inputs: TIntList;
    Outputs: TIntList;
    function SetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
    function Input(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
    function GetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
    function GetReg(idx: Integer; mode: TModes): integer;
  public
    constructor Create(initMem: String);
    function Run(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
  end;
  PIntCode = ^TIntCode;

var
  Number: Integer;

  constructor TIntCode.Create(initMem: String);
  var
    I: Integer;
    Cell: String;
  begin
    //WriteLn(Format('Constructing %p', [@Self]));
    //WriteLn('Initializing with: ' + initMem);
    PC:=0;
    Base:=0;
    I:=0;
    Inputs:=TIntList.create;
    Outputs:=TIntList.create;
    for Cell in initMem.Split(',') do begin
      Mem[I] := StrToInt(Cell);
      I +=  1;
    end;
  end;


  function TIntCode.GetReg(idx: Integer; mode : TModes): integer;
  begin
    Result:=0;
    case mode of
         modPos: begin
           Result := Mem[Mem[idx]];
         end;
         modRel: begin
                 Result:= Mem[Mem[idx + base]]
         end;
         modImm: Result := Mem[idx];
    end;
  end;



  function TIntCode.SetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
  var
    idx: Integer;
    val: Integer;
  begin
       if objc <> 4 then
       begin
            Tcl_WrongNumArgs(interp, 2 , objv, 'index value');
            Exit(TCL_ERROR);
       end;
       Tcl_GetLongFromObj(interp, objv[2], @idx);
       Tcl_GetLongFromObj(interp, objv[3], @val);
       //WriteLn(Format('Setting mem[%d] := %d', [idx,val]));


       Mem[idx] := val;
       Result:=TCL_OK;
  end;
    function TIntCode.Input(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
  var
    val: Integer;
  begin
       if objc <> 3 then
       begin
            Tcl_WrongNumArgs(interp, 2 , objv, 'value');
            Exit(TCL_ERROR);
       end;
       Tcl_GetLongFromObj(interp, objv[2], @val);
       //WriteLn(Format('Setting mem[%d] := %d', [idx,val]));


       Inputs.Push(val);
       Result:=TCL_OK;
  end;

  function TIntCode.GetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
  var
    idx: Integer;
    val: Integer;
  begin
       if objc <> 3 then
       begin
            Tcl_WrongNumArgs(interp, 2 , objv, 'index');
            Exit(TCL_ERROR);
       end;
       Tcl_GetLongFromObj(interp, objv[2], @idx);
       val := Mem[idx];
       Tcl_SetObjResult(interp,Tcl_NewIntObj(val));
       Result:=TCL_OK;
  end;

  function TIntCode.Run(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
  var
     inst: Integer;
    opcode: Integer;

    mode1,mode2,mode3: TModes;
    mode: Integer;

  begin
       if objc <> 2 then
       begin
            Tcl_WrongNumArgs(interp, 2 , objv, Nil);
            Exit(TCL_ERROR);
       end;
       State:=stRunning;
       //WriteLn(Format('Start running PC: %d', [PC]));
       While State = stRunning do begin
             Inst:=Mem[PC];
             opcode:= inst mod 100;
             mode:= inst div 100;
             mode1:= TModes(mode mod 10);
             mode2:= TModes((mode div 10) mod 10);
             mode3:= TModes(mode div 100);


             //WriteLn(Format('Got: Mem[%d] => %d(%d|%s, %d|%s, %d|%s)',
             //                     [PC,
             //                     opcode,
             //                     GetReg(PC+1,mode1),
             //                     GetEnumName(TypeInfo(TModes), Ord(mode1)),
             //                     GetReg(PC+2,mode2),
             //                     GetEnumName(TypeInfo(TModes), Ord(mode2)),
             //                     GetReg(PC+3,mode3),
             //                     GetEnumName(TypeInfo(TModes), Ord(mode3))]));
             Case opcode of
              -1 : begin
                   WriteLn('Should never happen');
              end;
              1 : begin
                   Mem[GetReg(PC+3,modImm)]:=GetReg(PC+1,mode1) + GetReg(PC+2,mode2);
                   PC+=4;
              end;
              2 : begin
                   Mem[GetReg(PC+3,modImm)]:=GetReg(PC+1,mode1) * GetReg(PC+2,mode2);
                   PC+=4;
              end;
              3 : begin

                    Mem[GetReg(PC+1,modImm)]:=Inputs.Front;
                   Inputs.Pop();
                   PC+=2;
              end;
              4 : begin

                   Outputs.push(GetReg(PC+1,mode1));
                   PC+=2;
              end;
              99 : State := stStopped;
         else
           Tcl_SetObjResult(interp, Tcl_NewStringObj(PChar(Format('Invalid opcode: %d', [opcode])),-1));
           Exit(TCL_ERROR);
    end;
       end;

       Result:=TCL_OK;
  end;



  procedure Machine_Del_Cmd(clientData: ClientData); cdecl;
  var
    Machine: TIntCode;

  begin
    //WriteLn('Disposing of machine');
    Machine := TIntCode(clientData);

    FreeAndNil(Machine);

  end;

  function Machine_Cmd(clientData: ClientData; interp: PTcl_Interp;
    objc: cint; objv: PPTcl_Obj): cint; cdecl;
  var
    SubCmd:  String;
    Machine: TIntCode;
  begin
    Machine := TIntCode(clientData);
    if objc < 2 then
    begin
      Tcl_WrongNumArgs(interp, 1 , objv, 'subcmd');
      Exit(TCL_ERROR);
    end;
    SubCmd := Tcl_GetString(objv[1]);
    case SubCmd of
         'input':
            begin
               Exit(Machine.Input(interp,objc,objv));
            end;
         'setmem':
            begin
               Exit(Machine.SetMem(interp,objc,objv));
            end;
         'mem':
            begin
               Exit(Machine.GetMem(interp,objc,objv));
            end;
         'run':
            begin
               Exit(Machine.Run(interp,objc,objv));
            end;
         else
           begin
             Tcl_SetObjResult(interp,
             Tcl_NewStringObj(PChar('invalid subcommand ' + SubCmd),-1));
             Exit(TCL_ERROR);
           end;
    end;

    Result := TCL_OK;
  end;

  function PintCode_Cmd(clientData: ClientData; interp: PTcl_Interp;
    objc: cint; objv: PPTcl_Obj): cint; cdecl;
  var
    CmdName:  PChar;
    Machine: TIntCode;
  begin
    CmdName := PChar(Format('pintcode::%d',[Number]));
    //WriteLn('cmdname:' + CmdName);
    if objc <> 2 then
    begin
      Tcl_WrongNumArgs(interp, 1, objv, 'mem');
      Exit(TCL_ERROR);
    end;
    //WriteLn('mem:' + Tcl_GetString(objv[1]));
    Machine:=TIntcode.Create(Tcl_GetString(objv[1]));
    Tcl_CreateObjCommand(interp, CmdName, @Machine_Cmd,  Machine, @Machine_Del_Cmd) ;
    Number += 1;
    Tcl_SetObjResult(interp, Tcl_NewStringObj(PChar(CmdName),-1));
    Result := TCL_OK;
  end;

  function Pintcode_Init(interp: PTcl_Interp): cint; cdecl;
  begin

    Tcl_InitStubs(interp, '8.5', 0);
    Tcl_CreateObjCommand(interp, 'PintCode', @PintCode_Cmd, Nil, Nil);
    Result := TCL_OK;
  end;

exports Pintcode_Init;

end.




