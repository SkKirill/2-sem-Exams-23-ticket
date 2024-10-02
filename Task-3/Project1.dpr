program Project1;

{$APPTYPE CONSOLE}

var
  x: Integer;
  m: (one, two, three, four, five);

procedure F(x: Integer);
begin
  x := Sqr(x);
end;

begin
  m := four;
  x := Ord(m);
  F(x);
  Writeln(x);
  Readln;
end.
 