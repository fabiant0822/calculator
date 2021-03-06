unit U_Calc1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Btn7: TButton;
    Btn6: TButton;
    Btn5: TButton;
    Btn4: TButton;
    Btn3: TButton;
    Btn2: TButton;
    Btn1: TButton;
    Btn0: TButton;
    Btn8: TButton;
    Btn9: TButton;
    BtnPlus: TButton;
    BtnMinus: TButton;
    BtnMult: TButton;
    BtnDiv: TButton;
    BtnEq: TButton;
    Result: TEdit;
    BtnClear: TButton;
    BtnDot: TButton;
    BtnBin: TButton;
    BtnDec: TButton;
    Result2: TEdit;
    Label1: TLabel;
    procedure Btn0Click(Sender: TObject);
    procedure BtnDotClick(Sender: TObject);
    procedure BtnPlusClick(Sender: TObject);
    procedure BtnMinusClick(Sender: TObject);
    procedure BtnMultClick(Sender: TObject);
    procedure BtnDivClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BtnEqClick(Sender: TObject);
    procedure BtnBinClick(Sender: TObject);
    procedure BtnDecClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    r:double;
    w:string;
    dotentered:Boolean;
    startnew:Boolean;
    lastop, nextToLastOp :char;
    Procedure AddDigit(c:char);
    Procedure HandleOp(c:char);
    procedure Reset;
    function DecToBinStr(N: Integer): string;
  end;

var
  Form1: TForm1;
  Negative: Boolean;

implementation

{$R *.DFM}

Procedure TForm1.Reset;
  begin
    w:='';
    dotentered:=false;
    r:=0.0;
    result.text:='';
    startnew:=false;
    lastop:=' ';
    result2.text:='';
  end;

Procedure TForm1.AddDigit(c:char);
Begin
  If startnew then reset;
  result.text:=result.text+c;
  w:=w+c;
end;

Procedure TForm1.HandleOp(c:char);
var
  x:double;
Begin
  If startnew then reset;
  If length(w)>0 then
  Begin
    x:=strtofloat(w);
    If lastop<>' ' then
    Begin
      case lastop of
        '+': r:=r+x;
        '-': r:=r-x;
        '*': r:=r*x;
        '/': r:=r/x;
      end;
    end
    else r:= x;
    w:='';
    dotentered:=false;
    nextToLastOp := lastop;
    lastop:=c;
    If (c in ['*','/']) and (NextToLastOp in ['+','-'])
    then Result.text:='('+Result.text+')';
    Result.text:=Result.text+c;
  end
  else beep;
end;

procedure TForm1.Btn0Click(Sender: TObject);
begin
  If sender is TButton
  then If TButton(Sender).name[4] in ['0'..'9']
       then  AddDigit(TButton(sender).name[4])
       else beep;
end;

procedure TForm1.BtnDotClick(Sender: TObject);
begin
  If startnew then reset;
  If not dotentered then  begin AddDigit('.'); dotentered:=true; end
  else beep;
end;

procedure TForm1.BtnPlusClick(Sender: TObject);
begin Handleop('+'); end;

procedure TForm1.BtnBinClick(Sender: TObject);
begin
 result2.text:= DecToBinStr(StrToInt(Result.Text));
end;

procedure TForm1.BtnMinusClick(Sender: TObject);
begin  Handleop('-'); end;

procedure TForm1.BtnMultClick(Sender: TObject);
begin  Handleop('*'); end;

procedure TForm1.BtnDivClick(Sender: TObject);
begin  Handleop('/'); end;

procedure TForm1.BtnClearClick(Sender: TObject);
begin  reset;  end;

procedure TForm1.FormActivate(Sender: TObject);
begin  reset;  end;

procedure TForm1.BtnEqClick(Sender: TObject);
begin
  Handleop('=');
  result.text:=result.text+floattostr(r);
  startnew:=true;
end;

function TForm1.DecToBinStr(N: Integer): string;
var
 S: string;
 i: Integer;
begin
 if N<0 then
Negative:=True;
 N:=Abs(N);
 for i:=1 to SizeOf(N)*8 do
 begin
if N<0 then
 S:=S+'1'
else
 S:=S+'0';
N:=N shl 1;
 end;
 Delete(S, 1, Pos('1', S)-1);
 if Negative then
S:='-'+S;
 Result:=S;
end;

function Pow(i, k: Integer): Integer;
var
 j, Count: Integer;
begin
 if k>0 then j:=2
else j:=1;
 for Count:=1 to k-1 do
j:=j*2;
 Result:=j;
end;

function BinToDec(Str: string): Integer;
var
 Len, Res, i: Integer;
 Error: Boolean;
begin
 Error:=False;
 Len:=Length(Str);
 Res:=0;
 for i:=1 to Len do
if (Str[i]='0')or(Str[i]='1') then
 Res:=Res+Pow(2, Len-i)*StrToInt(Str[i])
else
begin
 MessageDlg('Nem bin�ris sz�m', mtInformation, [mbOK], 0);
 Error:=True;
 Break;
end;
 if Error=True then Result:=0
else Result:=Res;
end;

procedure TForm1.BtnDecClick(Sender: TObject);
begin
  if Result.text ='' then
 begin
 ShowMessage('�res mez�');
Result.text :='';
Result2.text:='';
Result.SetFocus;
end
 else
Result2.text:= IntToStr(BinToDec(Result.Text))
end;

end.
