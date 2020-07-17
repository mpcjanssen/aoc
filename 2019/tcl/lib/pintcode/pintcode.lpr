{%RunFlags MESSAGES+}
library pintcode.lpr;

{$mode objfpc}{$H+}
{$packrecords C}


{ Strings are UTF8 by default }
{$codepage utf8}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  ctypes,
  typinfo,
  Generics.Collections,
  tcl;

type
  TStates = (stIdle, stRunning, stInputPending, stStopped);
  TModes = (modPos = 0, modImm = 1, modRel = 2);
  TMemory =  specialize TDictionary<Integer,Integer>;
  TIntCode = object
  public
    PC, Base: integer;
    Mem: TMemory;
    State: TStates;
    function SetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
    function GetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
    function GetAddress(param: Integer; mode: TModes): integer;
    function GetValue(param: Integer; mode: TModes): integer;
  public
    constructor Init(initMem: String);
    destructor Done();
    function Run(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
  end;
  PIntCode = ^TIntCode;

var
  Number: Integer;

  constructor TIntCode.Init(initMem: String);
  var
    I: Integer;
    Cell: String;
  begin
    //WriteLn(Format('Constructing %p', [@Self]));
    //WriteLn('Initializing with: ' + initMem);
    PC:=0;
    Base:=0;
    I:=0;
    Mem := TMemory.Create;
    for Cell in initMem.Split(',') do begin
      Mem.AddOrSetValue(I, StrToInt(Cell));
      I +=  1;
    end;
  end;
  destructor TIntCode.Done();
  begin
        FreeAndNil(Mem);
       // WriteLn('Destroy');
  end;

  function TIntCode.GetValue(param: Integer; mode : TModes): integer;
  begin
    Result:=0;
    case mode of
         modPos, modRel: begin
           Result := Mem[GetAddress(param,mode)];
         end;
         modImm: Result := param;
    end;
  end;

  function TIntCode.GetAddress(param: Integer; mode : TModes): integer;
  begin
    Result := 0;
    case mode of
         modPos: Exit(param);
         modRel: Exit(param + base);
         else begin
           Write('Unknown address type: ');
           WriteLn(mode);
         end;
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

       Mem[idx]:=val;
       //Mem.TryGetData(idx,val);
       //WriteLn(Format('%d', [val]));
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
       val:=Mem[idx];
       Tcl_SetObjResult(interp,Tcl_NewIntObj(val));
       Result:=TCL_OK;
  end;

  function TIntCode.Run(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint ;
  var
     inst: Integer;
    opcode: Integer;
    param1, param2,param3: Integer;
    val1, val2: Integer;
    mode1,mode2,mode3: TModes;
    mode: Integer;
  begin
       if objc <> 2 then
       begin
            Tcl_WrongNumArgs(interp, 2 , objv, Nil);
            Exit(TCL_ERROR);
       end;
       State:=stRunning;
       While State = stRunning do begin
             Inst:=Mem[PC];
             Param1:=Mem[PC+1];
             Param2:=Mem[PC+2];



             opcode:= inst mod 100;
             mode:= inst div 100;
             mode1:= TModes(mode mod 10);
             mode2:= TModes((mode div 10) mod 10);
             mode3:= TModes(mode div 100);
             val1 := GetValue(param1,mode1);
             val2 := GetValue(param2,mode2);

             //WriteLn(Format('Got: Mem[%d] => %d(%d|%s=%d, %d|%s=%d, %d|%s)',
             //                     [PC,
             //                     opcode,
             //                     Param1,
             //                     GetEnumName(TypeInfo(TModes), Ord(mode1)),
             //                     val1,
             //                     Param2,
             //                     GetEnumName(TypeInfo(TModes), Ord(mode2)),
             //                     val2,
             //                     Param3,
             //                     GetEnumName(TypeInfo(TModes), Ord(mode3))]));
             Case opcode of
              -1 : begin
                   WriteLn('Should never happen');
              end;
              1 : begin
                    Param3:=Mem[PC+3];
                   Mem[GetAddress(param3,mode3)]:=val1 + val2;
                   PC+=4;
              end;
              2 : begin
                    Param3:=Mem[PC+3];
                   Mem[GetAddress(param3,mode3)]:=val1 * val2;
                   PC+=4;
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
    Machine: PIntCode;

  begin
    //WriteLn('Disposing of machine');
    Machine := PIntCode(clientData);

    Dispose(Machine,Done)

  end;

  function Machine_Cmd(clientData: ClientData; interp: PTcl_Interp;
    objc: cint; objv: PPTcl_Obj): cint; cdecl;
  var
    SubCmd:  String;
    Machine: TIntCode;
  begin
    //WriteLn(Format('Evaluating command for: %p',[clientData]));
    Machine := TIntCode(clientData^);
    if objc < 2 then
    begin
      Tcl_WrongNumArgs(interp, 1 , objv, 'subcmd');
      Exit(TCL_ERROR);
    end;
    SubCmd := Tcl_GetString(objv[1]);
    case SubCmd of
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
    Machine: PIntCode;
    Mem: TMemory;
  begin
    CmdName := PChar(Format('pintcode::%d',[Number]));
    //WriteLn('cmdname:' + CmdName);
    if objc <> 2 then
    begin
      Tcl_WrongNumArgs(interp, 1, objv, 'mem');
      Exit(TCL_ERROR);
    end;
    Machine:=New(PIntCode,Init(Tcl_GetString(objv[1])));
    //WriteLn(Format('Create command for: %p',[@Machine]));
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




