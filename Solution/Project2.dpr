program Project2;

{$APPTYPE CONSOLE}

uses
  SysUtils;

const
  FILE_PATH_IN = 'TestTextFileIn.txt';
  FILE_PATH_OUT = 'TestTextFileOut.txt';

type
  TDataList = ^TDataNode;
  TList = ^TNode;
  TDataInf = Integer;

  TDataNode = record
    Inf: TDataInf;
    Next: TDataList;
  end;

  TNode = record
    LenData: Integer;
    Info: TDataList;
    Next: TList;
  end;

  TFile = TextFile;

procedure AddDataNode(var pHead: TDataList; pEl: TDataInf);
var
  p: TDataList;
begin
  if pHead = nil then
    begin
      New(pHead);
      pHead^.Inf := pEl;
      pHead^.Next := nil;
    end
  else
    begin
      p := pHead;
      while p^.Next <> nil do
        p := p^.Next;

      New(p^.next);
      p := p^.next;
      p^.Inf := pEl;
      p^.Next := nil;
    end;
end;

function SumElem(pHead: TDataList; pLen: Integer): Integer;
var
  i: Integer;
begin
  Result := pHead^.Inf;
  for i := 2 to pLen do
    begin
      pHead := pHead^.Next;
      Result := Result * pHead^.Inf;
    end;
end;

procedure AddListNode(var pHead: TList; pLen: Integer; pData: TDataList);
var
  p, q, k: TList;
begin
  if pHead = nil then
    begin
      New(pHead);
      pHead^.LenData := pLen;
      pHead^.Info := pData;
      pHead^.Next := nil;
    end
  else
    begin
      p := pHead;
      q := p;
      while (p <> nil) and (SumElem(pData, pLen) > SumElem(p^.Info, p^.LenData)) do
        begin
          q := p;
          p := p^.Next;
        end;

      New(k);
      k^.LenData := pLen;
      k^.Info := pData;
      if p = pHead then
        begin
          k^.Next := pHead;
          pHead := k;
        end
      else
        begin
          q^.Next := k;
          k^.Next := p;
        end;
    end;
end;

procedure ReadTxtFile(var pList: TList; var pFile: TFile);
var
  currenData: TDataList;
  currenLen, i: Integer;
  currenInf: TDataInf;
begin
  currenData := nil;
  pList := nil;
  while not Eof(pFile) do
    begin
      Read(pFile, currenLen);
      for i := 1 to currenLen do
        begin
          Read(pFile, currenInf);
          AddDataNode(currenData, currenInf);
        end;
      AddListNode(pList, currenLen, currenData);
    end;
end;

procedure PrintDataListToFile(pHead: TDataList; pLen: Integer; var TxtFile: TFile);
var
  i : Integer;
begin
  for i := 1 to pLen do
    begin
      Write(TxtFile, pHead^.Inf);
      write(TxtFile, ' ');
      pHead := pHead^.Next;
    end;
  Writeln(TxtFile);
end;

procedure PrintListTextFile(pList: TList; var TxtFile: TFile);
begin
  while pList <> nil do
    begin
      PrintDataListToFile(pList^.Info, pList^.LenData, TxtFile);
      pList := pList^.Next;
    end;
end;

var
  List: TList;
  FTxt: TFile;
begin
  AssignFile(FTxt, FILE_PATH_IN);
  Reset(FTxt);

  ReadTxtFile(List, FTxt);
  CloseFile(FTxt);

  AssignFile(FTxt, FILE_PATH_OUT);
  Rewrite(FTxt);

  PrintListTextFile(List, FTxt);
  CloseFile(FTxt);
end.

