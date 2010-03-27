{+--------------------------------------------------------------------------+
 | Unit:        mwFixedRecSort
 | Created:     12.97 - 9.98
 | Author:      Martin Waldenburg
 | Copyright    1997, all rights reserved.
 | Description: A buffered sorter for an unlimmited amount of records with a fixed
 |              length using a three-way merge for memory and a buffered
 |              multi-way merge  for files.
 |              The multi-way merge is the same as in mSor.
 | Version:     1.6
 | Status       FreeWare
 | It's provided as is, without a warranty of any kind.
 | You use it at your own risc.
 | E-Mail me at Martin.Waldenburg@t-online.de
 +--------------------------------------------------------------------------+}

{$mode Delphi}{$H+}

unit mwFixedRecSort;

interface

uses
  //Windows,
  SysUtils,
  Classes;

type
  TmSorCompare=function(Item1, Item2: Pointer): Integer;

  TMergeCompare=function(Item1, Item2: Pointer): Integer;
  PMergeArray=^TMergeArray;
  TMergeArray=array[0..0]of Pointer;

{ TSub3Array defines the boundaries of a SubArray and determines if
  the SubArray is full or not.
  The MergeSort Algorithm is easier readable with this class.}
  TSub3Array=class(TObject)
  private
    FMax: LongInt;
  protected
  public
    FLeft: LongInt; { - Initialized to 0. }
    FRight: LongInt; { - Initialized to 0. }
    Full: Boolean;
    constructor Create(MaxValue: LongInt);
    destructor Destroy; override;
    procedure Init(LeftEnd, RightEnd: LongInt);
    procedure Next;
  end; { TSub3Array }

{ TM3Array class }
  TM3Array=class(TObject)
  private
    FLeftArray, FMidArray, FRightArray: TSub3Array;
    FM3Array, TempArray, SwapArray: PMergeArray;
    FCount: Integer;
    fCapacity: Integer;
    procedure SetCapacity(NewCapacity: Integer);
    procedure Expand;
  protected
    function Get(Index: Integer): Pointer;
    procedure Put(Index: Integer; Item: Pointer);
    procedure Merge(SorCompare: TMergeCompare);
  public
    destructor Destroy; override;
    function Add(Item: Pointer): Integer;
    procedure Clear;
    function Last: Pointer;
    procedure MergeSort(SorCompare: TMergeCompare);
    procedure QuickSort(SorCompare: TMergeCompare);
    property Count: Integer read FCount write FCount;
    property Items[Index: Integer]: Pointer read Get write Put; default;
    property M3Array: PMergeArray read FM3Array;
    property Capacity: Integer read fCapacity write SetCapacity;
  published
  end; { TM3Array }

  TmSorIO=class(TObject)
  private
    IOStream: TFileStream;
    fFilledSize: Longint;
    fBufferSize: LongInt;
    fBufferPos: LongInt;
    fBuffer: Pointer;
    fNeedFill: Boolean;
    fEof: Boolean;
    fFileEof: Boolean;
    FRecCount: Cardinal;
    fSize: Longint;
    fFilePos: LongInt;
    fDataLen: Longint;
    procedure AllocBuffer(NewValue: Longint);
  protected
  public
    constructor create(Stream: TFileStream; DataLen, BuffSize: Integer);
    destructor destroy; override;
    procedure FillBuffer;
    function ReadData: Pointer;
    procedure WriteData(Var NewData);
    procedure FlushBuffer;
    property Eof: Boolean read fEof;
    property RecCount: Cardinal read FRecCount;
    property Size: Longint read fSize;
    property DataLen: Longint read fDataLen;
    property FilePos: Longint read fFilePos;
  published
  end; { TmSorIO }

Type
  TmMergePart=class(TObject)
  private
    fPartStream: TFileStream;
    PartFilePos: LongInt;
    RecsToRead: LongInt;
    RecsReaded: LongInt;
    fBufferSize: LongInt;
    fBufferPos: LongInt;
    fBuffer: Pointer;
    fNeedFill: Boolean;
    fEof: Boolean;
    FRecCount: Cardinal;
    fDataLen: Longint;
    fData: Pointer;
    fNumber: Integer;
    procedure AllocBuffer(NewValue: Longint);
    procedure FillBuffer;
  protected
  public
    constructor create(Stream: TFileStream; FilePos, DataLen, Count, aNumber:
      LongInt);
    destructor destroy; override;
    procedure next;
    procedure Init;
    property Eof: Boolean read fEof;
    property Data: Pointer read fData;
    property Number: Integer read fNumber;
  published
  end; { TmMergePart }

type
  TFixRecSort=class(TObject)
  private
    FParts: TList;
    ReadStream: TFileStream;
    MergeStream: TFileStream;
    WriteStream: TFileStream;
    Reader: TmSorIo;
    Writer: TmSorIo;
    FRecordLen: Integer;
    SorList: TM3Array;
    SorFileName: String;
    TempFileName: String;
    fStable: Boolean;
    procedure InitMerge;
    procedure Merge;
    procedure LooserSort;
    procedure CalculateBuffers;
  protected
  public
    constructor Create(RecLen: Integer);
    destructor Destroy; override;
    procedure Start(InFile, OutFile: String; Compare: TmSorCompare);
    property Stable: Boolean read fStable write fStable;
  end; { TFixRecSort }

var
  SorCompare: TmSorCompare;
  ReadBuffSize: LongInt;
  WriteBuffSize: LongInt;
  PartBuffSize: LongInt;

implementation
//uses Unit1;

constructor TSub3Array.Create(MaxValue: LongInt);
begin
  FLeft:=0;
  FRight:=0;
  Full:=False;
  FMax:=MaxValue;
end; { Create }

procedure TSub3Array.Init(LeftEnd, RightEnd: LongInt); { public }
begin
  FLeft:=LeftEnd;
  FRight:=RightEnd;
  if FLeft>FMax then Full:=False else
  begin
    Full:=True;
    if FRight>FMax then FRight:=FMax;
  end;
end; { Init }

procedure TSub3Array.Next;
begin
  inc(FLeft);
  if FLeft>FRight then Full:=False;
end; { Next }

destructor TSub3Array.Destroy;
begin
  inherited Destroy;
end; { Destroy }

{ TM3Array }
destructor TM3Array.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function TM3Array.Add(Item: Pointer): Integer;
begin
  Result:=FCount;
  if Result=FCapacity then Expand;
  FM3Array[Result]:=Item;
  Inc(FCount);
end;

procedure TM3Array.Expand;
begin
  SetCapacity(FCapacity+8192);
end;

procedure TM3Array.SetCapacity(NewCapacity: Integer);
begin
  FCapacity:=NewCapacity;
  ReallocMem(FM3Array, FCapacity*4);
end;

procedure TM3Array.Clear;
begin
  FCount:=0;
  ReallocMem(TempArray, 0);
  ReallocMem(FM3Array, 0);
  FCapacity:=0;
end;

function TM3Array.Get(Index: Integer): Pointer;
begin
  Result:=FM3Array[Index];
end;

function TM3Array.Last: Pointer;
begin
  Result:=Get(FCount-1);
end;

procedure TM3Array.Put(Index: Integer; Item: Pointer);
begin
  FM3Array[Index]:=Item;
end;

{ Based on a non-recursive QuickSort from the SWAG-Archive.
  ( TV Sorting Unit by Brad Williams ) }
procedure TM3Array.QuickSort(SorCompare: TMergeCompare);
var
  Left, Right, SubArray, SubLeft, SubRight: LongInt;
  Temp, Pivot: Pointer;
  Stack: array[1..32]of record First, Last: LongInt;
  end;
begin
  SubArray:=1;
  Stack[SubArray].First:=0;
  Stack[SubArray].Last:=Count-1;
  repeat
    Left:=Stack[SubArray].First;
    Right:=Stack[SubArray].Last;
    Dec(SubArray);
    repeat
      SubLeft:=Left;
      SubRight:=Right;
      Pivot:=FM3Array[(Left+Right)shr 1];
      repeat
        while SorCompare(FM3Array[SubLeft], Pivot)<0 do Inc(SubLeft);
        while SorCompare(FM3Array[SubRight], Pivot)>0 do Dec(SubRight);
        IF SubLeft<=SubRight then
        begin
          Temp:=FM3Array[SubLeft];
          FM3Array[SubLeft]:=FM3Array[SubRight];
          FM3Array[SubRight]:=Temp;
          Inc(SubLeft);
          Dec(SubRight);
        end;
      until SubLeft>SubRight;
      IF SubLeft<Right then
      begin
        Inc(SubArray);
        Stack[SubArray].First:=SubLeft;
        Stack[SubArray].Last:=Right;
      end;
      Right:=SubRight;
    until Left>=Right;
  until SubArray=0;
end; { QuickSort }

{This is a three way merge routine.
 Unfortunately the " Merge " routine needs additional memory}
procedure TM3Array.Merge(SorCompare: TMergeCompare);
var
  TempPos: integer;
begin
  TempPos:=FLeftArray.FLeft;
  while(FLeftArray.Full)and(FMidArray.Full)and(FRightArray.Full)do{Main Loop}
  begin
    if SorCompare(FM3Array[FLeftArray.FLeft], FM3Array[FMidArray.FLeft])<=0 then
    begin
      if SorCompare(FM3Array[FLeftArray.FLeft], FM3Array[FRightArray.FLeft])<=0
        then
      begin
        TempArray[TempPos]:=FM3Array[FLeftArray.FLeft];
        FLeftArray.Next;
      end
      else
      begin
        TempArray[TempPos]:=FM3Array[FRightArray.FLeft];
        FRightArray.Next;
      end;
    end
    else
    begin
      if SorCompare(FM3Array[FMidArray.FLeft], FM3Array[FRightArray.FLeft])<=0
        then
      begin
        TempArray[TempPos]:=FM3Array[FMidArray.FLeft];
        FMidArray.Next;
      end
      else
      begin
        TempArray[TempPos]:=FM3Array[FRightArray.FLeft];
        FRightArray.Next;
      end;
    end;
    inc(TempPos);
  end;

  while(FLeftArray.Full)and(FMidArray.Full)do
  begin
    if SorCompare(FM3Array[FLeftArray.FLeft], FM3Array[FMidArray.FLeft])<=0 then
    begin
      TempArray[TempPos]:=FM3Array[FLeftArray.FLeft];
      FLeftArray.Next;
    end
    else
    begin
      TempArray[TempPos]:=FM3Array[FMidArray.FLeft];
      FMidArray.Next;
    end;
    inc(TempPos);
  end;

  while(FMidArray.Full)and(FRightArray.Full)do
  begin
    if SorCompare(FM3Array[FMidArray.FLeft], FM3Array[FRightArray.FLeft])<=0 then
    begin
      TempArray[TempPos]:=FM3Array[FMidArray.FLeft];
      FMidArray.Next;
    end
    else
    begin
      TempArray[TempPos]:=FM3Array[FRightArray.FLeft];
      FRightArray.Next;
    end;
    inc(TempPos);
  end;

  while(FLeftArray.Full)and(FRightArray.Full)do
  begin
    if SorCompare(FM3Array[FLeftArray.FLeft], FM3Array[FRightArray.FLeft])<=0
      then
    begin
      TempArray[TempPos]:=FM3Array[FLeftArray.FLeft];
      FLeftArray.Next;
    end
    else
    begin
      TempArray[TempPos]:=FM3Array[FRightArray.FLeft];
      FRightArray.Next;
    end;
    inc(TempPos);
  end;

  while FLeftArray.Full do{ Copy Rest of First Sub3Array }
  begin
    TempArray[TempPos]:=FM3Array[FLeftArray.FLeft];
    inc(TempPos); FLeftArray.Next;
  end;

  while FMidArray.Full do{ Copy Rest of Second Sub3Array }
  begin
    TempArray[TempPos]:=FM3Array[FMidArray.FLeft];
    inc(TempPos); FMidArray.Next;
  end;

  while FRightArray.Full do{ Copy Rest of Third Sub3Array }
  begin
    TempArray[TempPos]:=FM3Array[FRightArray.FLeft];
    inc(TempPos); FRightArray.Next;
  end;

end; { Merge }

{Non-recursive Mergesort.
 Very fast, if enough memory available.
 The number of comparisions used is nearly optimal, about 3/4 of QuickSort.
 If comparision plays a very more important role than exchangement,
 it outperforms QuickSort in any case.
 ( Large keys in pointer arrays, for example text with few short lines. )
 From all Algoritms with O(N lg N) it's the only stable, meaning it lefts
 equal keys in the order of input. This may be important in some cases. }
procedure TM3Array.MergeSort(SorCompare: TMergeCompare);
var
  a, b, c, N, todo: LongInt;
begin
  ReallocMem(TempArray, FCount*4);
  FLeftArray:=TSub3Array.Create(FCount-1);
  FMidArray:=TSub3Array.Create(FCount-1);
  FRightArray:=TSub3Array.Create(FCount-1);
  N:=1;
  repeat
    todo:=0;
    repeat
      a:=todo;
      b:=a+N;
      c:=b+N;
      todo:=C+N;
      FLeftArray.Init(a, b-1);
      FMidArray.Init(b, c-1);
      FRightArray.Init(c, todo-1);
      Merge(SorCompare);
    until todo>=Fcount;
    SwapArray:=FM3Array; {Alternating use of the arrays.}
    FM3Array:=TempArray;
    TempArray:=SwapArray;
    N:=N+N+N;
  until N>=Fcount;
  FLeftArray.Free;
  FMidArray.Free;
  FRightArray.Free;
  ReallocMem(TempArray, 0);
end; { MergeSort }

function StableCompare(P1, P2: Pointer): Integer;
begin
  Result:=SorCompare(TmMergePart(P1).Data, TmMergePart(P2).Data);
  if Result=0 then
  begin
    if TmMergePart(P1).Number<TmMergePart(P2).Number then Result:=-1;
    if TmMergePart(P1).Number>TmMergePart(P2).Number then Result:=1;
  end;
end; { StableCompare }

constructor TmSorIO.create(Stream: TFileStream; DataLen, BuffSize: Integer);
begin
  IOStream:=Stream;
  FSize:=IOStream.Size;
  FDataLen:=DataLen;
  fBufferSize:=BuffSize;
  FRecCount:=BuffSize Div DataLen;
  fBufferSize:=DataLen*FRecCount;
  fNeedFill:=True;
  fEof:=False;
  fFileEof:=False;
  AllocBuffer(fBufferSize);
  fBufferPos:=0;
end; { create }

destructor TmSorIO.destroy;
begin
  ReallocMem(fBuffer, 0);
  inherited destroy;
end; { destroy }

procedure TmSorIO.AllocBuffer(NewValue: Longint);
begin
  fFilledSize:=NewValue;
  ReallocMem(fBuffer, NewValue);
end; { SetBufferSize }

procedure TmSorIO.FillBuffer;
var
  Readed: LongInt;
begin
  Readed:=IOStream.Read(FBuffer^, fBufferSize);
  fFilePos:=fFilePos+Readed;
  if fFilePos=fSize then fFileEof:=True else fFileEof:=False;
  fBufferPos:=0;
  fFilledSize:=Readed;
  fNeedFill:=False;
end; { FillBuffer }

function TmSorIO.ReadData: Pointer;
begin
  fEof:=False;
  if fNeedFill then FillBuffer;
  Result:=Pointer(Integer(fBuffer)+fBufferPos);
  inc(fBufferPos, fDataLen);
  if fBufferPos>=fFilledSize then
  begin
    fNeedFill:=True;
    if FFileEof then FEof:=True;
  end;
end; { ReadData }

procedure TmSorIO.WriteData(Var NewData);
var
  Pos: LongInt;
begin
  if(fBufferPos>=0)and(Pointer(NewData)<>nil)then
  begin
    Pos:=fBufferPos+fDataLen;
    if Pos>0 then
    begin
      if Pos>=FBufferSize then
      begin
        FlushBuffer;
      end;
      Move(NewData, Pointer(LongInt(fBuffer)+fBufferPos)^, fDataLen);
      inc(fBufferPos, fDataLen);
      inc(fFilePos, fDataLen);
    end;
  end;
end; { WriteData }

procedure TmSorIO.FlushBuffer;
begin
  IOStream.Write(fBuffer^, fBufferPos);
  fBufferPos:=0;
end; { FlushBuffer }

constructor TmMergePart.create(Stream: TFileStream; FilePos, DataLen, Count,
  aNumber: LongInt);
begin
  fPartStream:=Stream;
  PartFilePos:=FilePos;
  RecsToRead:=Count;
  RecsReaded:=0;
  FNumber:=aNumber;
  FDataLen:=DataLen;
  FRecCount:=PartBuffSize div DataLen;
  fBufferSize:=DataLen*FRecCount;
  fNeedFill:=True;
  fEof:=False;
  fBufferPos:=0;
end; { create }

destructor TmMergePart.destroy;
begin
  ReallocMem(fBuffer, 0);
  inherited destroy;
end; { destroy }

procedure TmMergePart.AllocBuffer(NewValue: Longint);
begin
  ReallocMem(fBuffer, NewValue);
end; { SetBufferSize }

procedure TmMergePart.FillBuffer;
var
  Readed: LongInt;
begin
  FPartStream.Position:=PartFilePos;
  Readed:=FPartStream.Read(FBuffer^, fBufferSize);
  PartFilePos:=PartFilePos+Readed;
  if Readed=0 then FEof:=True;
  fBufferPos:=0;
  fNeedFill:=False;
end; { FillBuffer }

procedure TmMergePart.Init;
begin
  AllocBuffer(fBufferSize);
  next;
end; { Init }

procedure TmMergePart.next;
begin
  fEof:=False;
  if fNeedFill then FillBuffer;
  fData:=Pointer(Integer(fBuffer)+fBufferPos);
  inc(fBufferPos, fDataLen);
  inc(RecsReaded);
  if fBufferPos>=fBufferSize then fNeedFill:=True;
  if RecsReaded=RecsToRead then FEof:=True;
end; { Read }

constructor TFixRecSort.Create(RecLen: Integer);
begin
  inherited Create;
  FRecordLen:=RecLen;
end; { Create }

destructor TFixRecSort.Destroy;
begin
  inherited Destroy;
end; { Destroy }

procedure TFixRecSort.InitMerge;
var
  I: Integer;
begin
  I:=0;
  while I<FParts.Count do
  begin
    TmMergePart(FParts[I]).Init;
    inc(I);
  end;
  if FParts.Count>1 then FParts.Sort(StableCompare);
end; { InitMerge }

{ Similar to the Tree of Looser, but not as effective}
procedure TFixRecSort.LooserSort;
var
  First, Last, I: Integer;
  Larger: ByteBool;
begin
  if FParts.Count>1 then
  begin
    First:=1;
    Last:=FParts.Count-1;
    while First<=Last do
    begin
      I:=(First+Last)shr 1;
      Case StableCompare(FParts[0], FParts[I])<=0 of
        True:
          begin
            Last:=I-1;
            Larger:=False;
          end;
        False:
          begin
            First:=I+1;
            Larger:=True;
          end;
      end;
    end;
    if I>0 then
      Case Larger of
        True: FParts.Move(0, I);
        False: FParts.Move(0, I-1);
      end;
  end;
end; { LooserSort }

{Quick and dirty multi merge routine}
procedure TFixRecSort.Merge;
begin
  WriteStream:=TFileStream.Create(SorFileName, fmOpenWrite);
  Writer:=TmSorIO.create(WriteStream, FRecordLen, WriteBuffSize);
  while FParts.Count>0 do
  begin
    Writer.WriteData(TmMergePart(FParts[0]).Data^);
    if TmMergePart(FParts[0]).Eof then
    begin
      TmMergePart(FParts[0]).Free;
      FParts.Delete(0);
      if FParts.Count=0 then
      begin
        FParts.Free;
        break;
      end;
    end else
    begin
      TmMergePart(FParts[0]).Next;
      LooserSort;
    end;
  end;
  Writer.FlushBuffer;
  Writer.Free;
  MergeStream.Free;
  WriteStream.Free;
end; { Merge }

procedure TFixRecSort.CalculateBuffers;
var
  Size, PCount, Adjust: LongInt;
  RLen: String;
begin
  Size:=ReadStream.Size;
  if Size mod FRecordLen<>0 then
  begin
    RLen:=IntToStr(FRecordLen);
    raise exception.Create('File can`t be divided through '+RLen);
  end;
  if Size<=40000000 then
  begin
    ReadBuffSize:=Size div 12;
    if ReadBuffSize<325000 then ReadBuffSize:=325000;
    WriteBuffSize:=ReadBuffSize div 5;
  end else;
  if(Size>40000000)and(Size<=100000000)then
  begin
    ReadBuffSize:=Size div 17;
    if ReadBuffSize<4000000 then ReadBuffSize:=4000000;
    WriteBuffSize:=ReadBuffSize div 5;
  end else;
  if(Size>100000000)and(Size<=600000000)then
  begin
    ReadBuffSize:=Size div 25;
    if ReadBuffSize<10000000 then ReadBuffSize:=10000000;
    WriteBuffSize:=ReadBuffSize div 5;
  end else;
  if(Size>600000000)and(Size<=2000000000)then
  begin
    ReadBuffSize:=20000000;
    WriteBuffSize:=ReadBuffSize div 5;
  end;
  Adjust:= ReadBuffSize div fRecordLen;
  ReadBuffSize:= AdJust * fRecordLen;
  PCount:=(Size div ReadBuffSize)+1;
  PartBuffSize:=ReadBuffSize div PCount;
end; { CalculateBuffers }

procedure TFixRecSort.Start(InFile, OutFile: String; Compare: TmSorCompare);
var
  aFile, bFile: File;
  K, Readed: Integer;
  WriterPos, SorCount, PartNumber: LongInt;
begin
  TempFileName:=ExtractFilePath(Outfile)+PathDelim+'SorTemp.mkw';
  SorFileName:=OutFile;
  AssignFile(aFile, TempFileName);
  Rewrite(aFile);
  CloseFile(aFile);
  AssignFile(bFile, SorFileName);
  Rewrite(bFile);
  CloseFile(bFile);
  PartNumber:=1;
  SorCompare:=Compare;
  SorList:=TM3Array.Create;
  FParts:=TList.Create;
  ReadStream:=TFileStream.Create(InFile, fmOpenRead);
  CalculateBuffers;
  MergeStream:=TFileStream.Create(TempFileName, fmOpenReadWrite);
  Reader:=TmSorIO.create(ReadStream, FRecordLen, ReadBuffSize);
  Writer:=TmSorIO.create(MergeStream, FRecordLen, WriteBuffSize);
  while not Reader.Eof do
  begin
    Readed:=0;
    SorList.Clear;
    while(not Reader.Eof)and(Readed<ReadBuffSize)do
    begin
      SorList.Add(Reader.ReadData);
      inc(Readed, FRecordLen);
    end;
    Case Stable of
      True: SorList.MergeSort(Compare);
      False: SorList.QuickSort(Compare);
    end;
    SorCount:=SorList.Count;
    WriterPos:=Writer.FilePos;
    For K:=0 to SorList.Count-1 do Writer.WriteData(SorList[K]^);
    FParts.Add(TmMergePart.create(MergeStream, WriterPos, FRecordLen, SorCount,
      PartNumber));
    inc(PartNumber);
  end;
  Reader.Free;
  Writer.FlushBuffer;
  Writer.Free;
  ReadStream.Free;
  if FParts.Count>1 then
  begin
    InitMerge;
    Merge;
    DeleteFile(TempFileName);
  end else
  begin
    MergeStream.Free;
    DeleteFile(SorFileName);
    RenameFile(TempFileName, SorFileName);
  end;
  SorList.Free;
end; { Start }

end.

