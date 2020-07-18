library pintcode;

{$mode objfpc}{$H+} {$R+}
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
  Generics.Collections,
  tcl;

type
  TStates = (stIdle, stRunning, stInputPending, stStopped);
  TIntList = specialize TQueue<Int64>;
  TMemory = specialize TDictionary<Int64,Int64>;
  TModes = (modPos = 0, modImm = 1, modRel = 2);

  TIntCode = class
  public
    PC, Base: Int64;
    State: TStates;
    Mem: TMemory;
    Inputs: TIntList;
    Outputs: TIntList;
    function SetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
    function GetState(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
    function GetOutputs(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
    function Input(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
    function GetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
    function GetReg(idx: Int64; mode: TModes): Int64;
    function GetVal(idx: Int64; mode: TModes): Int64;
  public
    constructor Create(initMem: string);
    destructor Destroy; override;
    function Run(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
  end;

var
  Number: integer;

  constructor TIntCode.Create(initMem: string);
  var
    I: integer;
    Cell: string;
  begin
    //WriteLn(Format('Constructing %p', [@Self]));
    //WriteLn('Initializing with: ' + initMem);
    PC := 0;
    Base := 0;

    Inputs := TIntList.Create;
    Outputs := TIntList.Create;
    Mem := TMemory.Create;
    I := 0;
    for Cell in initMem.Split(',') do
    begin
      Mem.AddOrSetValue(I,StrToInt(Cell));
      I += 1;
    end;
  end;

  destructor TIntCode.Destroy();
  var
    I: integer;
    Cell: string;
  begin
    FreeAndNil(Outputs);
    FreeAndNil(Inputs);
    FreeAndNil(Mem);
  end;


  function TIntCode.GetReg(idx: Int64; mode: TModes): Int64;
  begin
    Result := 0;

    case mode of
      modPos: Mem.TryGetValue(idx,Result);
      modRel: begin
        Mem.TryGetValue(idx,Result);
        Result+= Base;
        end;

      modImm: Result := idx;
      else WriteLn('Invalid mode: ', mode);
    end;
  end;

  function TIntCode.GetVal(idx: Int64; mode: TModes): Int64;
  begin
    //WriteLn('Getting val from ', GetReg(idx,mode));
    Result := 0;
    Mem.TryGetValue(GetReg(idx,mode),Result);
  end;

  function TIntCode.GetState(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
  var
    idx: integer;
    val: integer;
  begin
    if objc <> 2 then
    begin
      Tcl_WrongNumArgs(interp, 2, objv, '');
      Exit(TCL_ERROR);
    end;
    case State of
      stIdle: Tcl_SetObjResult(interp, Tcl_NewStringObj('idle', -1));
      stRunning: Tcl_SetObjResult(interp, Tcl_NewStringObj('running', -1));
      stInputPending: Tcl_SetObjResult(interp, Tcl_NewStringObj(
          'input-pending', -1));
      stStopped: Tcl_SetObjResult(interp, Tcl_NewStringObj('stopped', -1));
      //WriteLn(Format('Setting mem[%d] := %d', [idx,val]));
    end;


    Result := TCL_OK;
  end;

  function TIntCode.GetOutputs(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
  var
    item: Int64;
    l: PTcl_Obj;
  begin
    if objc <> 2 then
    begin
      Tcl_WrongNumArgs(interp, 2, objv, '');
      Exit(TCL_ERROR);
    end;
    //WriteLn('Her');
    l := Tcl_NewListObj(0, nil);
   for item in Outputs do
    begin
      //WriteLn(IntToStr(item));
      Tcl_ListObjAppendElement(interp, l, Tcl_NewStringObj(PChar(IntToStr(item)),-1));

      //WriteLn(Format('Setting mem[%d] := %d', [idx,val]));
    end;

    Tcl_SetObjResult(interp, l);
    Result := TCL_OK;
  end;

  function TIntCode.SetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
  var
    idx: integer;
    val: integer;
  begin
    if objc <> 4 then
    begin
      Tcl_WrongNumArgs(interp, 2, objv, 'index value');
      Exit(TCL_ERROR);
    end;
    Tcl_GetLongFromObj(interp, objv[2], @idx);
    Tcl_GetLongFromObj(interp, objv[3], @val);
    //WriteLn('Setting mem[', idx, ']=',val);


    Mem.AddOrSetValue(idx, val);
    Result := TCL_OK;
  end;

  function TIntCode.Input(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
  var
    val: integer;
  begin
    if objc <> 3 then
    begin
      Tcl_WrongNumArgs(interp, 2, objv, 'value');
      Exit(TCL_ERROR);
    end;
    Tcl_GetLongFromObj(interp, objv[2], @val);



    Inputs.Enqueue(val);
    Result := TCL_OK;
  end;

  function TIntCode.GetMem(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
  var
    idx: LongInt;
    val: Int64;
  begin
    if objc <> 3 then
    begin
      Tcl_WrongNumArgs(interp, 2, objv, 'index');
      Exit(TCL_ERROR);
    end;
    Tcl_GetLongFromObj(interp, objv[2], @idx);
    val := 0;
    Mem.TryGetValue(idx,val);
    Tcl_SetObjResult(interp, Tcl_NewLongObj(val));
    Result := TCL_OK;
  end;

  function TIntCode.Run(interp: PTcl_Interp; objc: cint; objv: PPTcl_Obj): cint;
  var
    inst: Int64;
    opcode: Int64;

    mode1, mode2, mode3: TModes;

  begin
    if objc <> 2 then
    begin
      Tcl_WrongNumArgs(interp, 2, objv, nil);
      Exit(TCL_ERROR);
    end;
    State := stRunning;
    //WriteLn(Format('Start running PC: %d', [PC]));
    while State = stRunning do
    begin
      Inst := 0;
      Mem.TryGetValue(PC,Inst);
      opcode := inst mod 100;
      mode1 := TModes((Inst div 100) mod 10);
      mode2 := TModes((Inst div 1000) mod 10);
      mode3 := TModes((Inst div 10000) mod 10);


      //WriteLn(Format('Got: Mem[%d] => %d(%d|%s, %d|%s, %d|%s)',
      //                     [PC,
      //                     opcode,
      //                     GetReg(PC+1,mode1),
      //                     GetEnumName(TypeInfo(TModes), Ord(mode1)),
      //                     GetReg(PC+2,mode2),
      //                     GetEnumName(TypeInfo(TModes), Ord(mode2)),
      //                     GetReg(PC+3,mode3),
      //                     GetEnumName(TypeInfo(TModes), Ord(mode3))]));
      case opcode of
        -1:
        begin
          WriteLn('Should never happen');
        end;
        1:
        begin
          Mem.AddOrSetValue(GetReg(PC + 3, mode3), GetVal(PC + 1, mode1) + GetVal(PC + 2, mode2));
          PC += 4;
        end;
        2:
        begin
          //WriteLn(GetVal(PC + 1, mode1), '*', GetVal(PC + 2, mode2), '=', GetVal(PC + 1, mode1) * GetVal(PC + 2, mode2));
           Mem.AddOrSetValue(GetReg(PC + 3, mode3), GetVal(PC + 1, mode1) * GetVal(PC + 2, mode2));
          PC += 4;
        end;
        3:
        begin
          if Inputs.Count = 0 then begin
            // WriteLn('Exhaused inputs: ');
            State := stInputPending;
          end
          else
          begin
           Mem.AddOrSetValue(GetReg(PC + 1, mode1),Inputs.Dequeue);
          PC += 2;
          end;
        end;
        4:
        begin
          Outputs.Enqueue(GetVal(PC + 1, mode1));
          PC += 2;
        end;
        5:
        begin

          if GetVal(PC + 1, mode1) <> 0 then
          begin
            PC := GetVal(PC + 2, mode2);
          end
          else
          begin
            PC += 3;

          end;

        end;
        6:
        begin

          if GetVal(PC + 1, mode1) = 0 then
          begin
            PC := GetVal(PC + 2, mode2);
          end
          else
          begin
            PC += 3;

          end;

        end;
        7:
        begin

          if GetVal(PC + 1, mode1) < GetVal(PC + 2, mode2) then
          begin
            Mem.AddOrSetValue(GetReg(PC + 3, mode3), 1);
          end
          else
          begin
            Mem.AddOrSetValue(GetReg(PC + 3, mode3) ,0);

          end;
          PC += 4;

        end;
        8:
        begin

          if GetVal(PC + 1, mode1) = GetVal(PC + 2, mode2) then
          begin
              Mem.AddOrSetValue(GetReg(PC + 3, mode3), 1);
            end
            else
            begin
              Mem.AddOrSetValue(GetReg(PC + 3, mode3),0);
            end;
          PC += 4;

        end;
        9:
        begin
          Base+= GetVal(PC + 1, mode1);
          PC += 2;

        end;
        99: State := stStopped;
        else
          Tcl_SetObjResult(interp,
          Tcl_NewStringObj(PChar(Format('Invalid opcode: %d', [opcode])), -1));
          Exit(TCL_ERROR);
      end;
    end;
    //WriteLn('State: ', State);

    Result := TCL_OK;
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
    SubCmd: string;
    Machine: TIntCode;
  begin
    Machine := TIntCode(clientData);
    if objc < 2 then
    begin
      Tcl_WrongNumArgs(interp, 1, objv, 'subcmd');
      Exit(TCL_ERROR);
    end;
    SubCmd := Tcl_GetString(objv[1]);
    case SubCmd of
      'input':
      begin
        Exit(Machine.Input(interp, objc, objv));
      end;
      'setmem':
      begin
        Exit(Machine.SetMem(interp, objc, objv));
      end;
      'mem':
      begin
        Exit(Machine.GetMem(interp, objc, objv));
      end;
      'run':
      begin
        Exit(Machine.Run(interp, objc, objv));
      end;
      'state':
      begin
        Exit(Machine.GetState(interp, objc, objv));
      end;
      'outputs':
      begin
        Exit(Machine.GetOutputs(interp, objc, objv));
      end;
      else
      begin
        Tcl_SetObjResult(interp,
          Tcl_NewStringObj(PChar('invalid subcommand ' + SubCmd), -1));
        Exit(TCL_ERROR);
      end;
    end;

    Result := TCL_OK;
  end;

  function PintCode_Cmd(clientData: ClientData; interp: PTcl_Interp;
    objc: cint; objv: PPTcl_Obj): cint; cdecl;
  var
    CmdName: PChar;
    Machine: TIntCode;
  begin
    CmdName := PChar(Format('pintcode::%d', [Number]));
    //WriteLn('cmdname:' + CmdName);
    if objc <> 2 then
    begin
      Tcl_WrongNumArgs(interp, 1, objv, 'mem');
      Exit(TCL_ERROR);
    end;
    //WriteLn('mem:' + Tcl_GetString(objv[1]));
    Machine := TIntcode.Create(Tcl_GetString(objv[1]));
    Tcl_CreateObjCommand(interp, CmdName, @Machine_Cmd, Machine, @Machine_Del_Cmd);
    Number += 1;
    Tcl_SetObjResult(interp, Tcl_NewStringObj(PChar(CmdName), -1));
    Result := TCL_OK;
  end;

  function Pintcode_Init(interp: PTcl_Interp): cint; cdecl;
  begin

    Tcl_InitStubs(interp, '8.5', 0);
    Tcl_CreateObjCommand(interp, 'PintCode', @PintCode_Cmd, nil, nil);
    Result := TCL_OK;
  end;

exports Pintcode_Init;

end.
