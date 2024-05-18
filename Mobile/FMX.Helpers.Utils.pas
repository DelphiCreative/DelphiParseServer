unit FMX.Helpers.Utils;

interface

uses
  FMX.Forms, FMX.Objects,   FMX.TabControl, FMX.StdCtrls, FMX.Ani, FMX.Types,System.UITypes, FMX.Gestures,
  System.Generics.Collections, System.StrUtils, System.SysUtils;

type
  TObjectListFrameHelper = class helper for TObjectList<TFrame>
    function Filter(const AFilterText: string): Boolean;
  end;

type
  TTabControlHelper = class helper for TTabControl
  private
    procedure AnimationFinish(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure PreviousClick(Sender: TObject);
    procedure LayoutGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
  public
    procedure Slide(ADuration: Real = 7);
  end;

implementation

var
  GestureManager : TGestureManager;

function TObjectListFrameHelper.Filter(const AFilterText: String): Boolean;
var I :Integer;
begin
   Result := False;

   for I := 0 to Self.Count - 1 do begin
      if Trim(AFilterText) <> '' then begin
         TFrame(Self[I]).Visible := ContainsStr(AnsiLowerCase(TFrame(Self[I]).TagString),AnsiLowerCase(AFilterText));
         if TFrame(Self[I]).Visible then
            Result := True;
      end
      else begin
         TFrame(Self[I]).Visible := True;
         Result := True;
      end;
   end;
end;

procedure TTabControlHelper.AnimationFinish(Sender: TObject);
begin
  if TabCount > 1 then
  begin
    if TabIndex < TabCount - 1 then
      Next
    else
      GotoVisibleTab(0, TTabTransition.Slide, TTabTransitionDirection.Reversed);
  end;
  TFloatAnimation(Sender).Start;
end;

procedure TTabControlHelper.PreviousClick(Sender: TObject);
begin
  if TabIndex > 0 then
    Previous
  else
    GotoVisibleTab(TabCount - 1, TTabTransition.Slide, TTabTransitionDirection.Reversed);
end;

procedure TTabControlHelper.NextClick(Sender: TObject);
begin
  if TabIndex < TabCount - 1 then
    Next
  else
    GotoVisibleTab(0);
end;

procedure TTabControlHelper.LayoutGesture(Sender: TObject; const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if EventInfo.GestureID = sgiLeft then
    NextClick(Sender)
  else if EventInfo.GestureID = sgiRight then
    PreviousClick(Sender);
end;

procedure TTabControlHelper.Slide(ADuration: Real);
var
  btnNext, btnPrevious: TSpeedButton;
  Animation: TFloatAnimation;
begin
  BeginUpdate;
  //TabPosition := TTabPosition.None;
  HitTest := True;

  GestureManager := TGestureManager.Create(Self);
  GestureManager.Sensitivity := 10;
  Touch.GestureManager := GestureManager;
  Touch.StandardGestures := [TStandardGesture.sgLeft, TStandardGesture.sgRight];
  OnGesture := LayoutGesture;

  btnNext := TSpeedButton.Create(Self);
  AddObject(btnNext);
  btnNext.BringToFront;
  btnNext.Text := '>';
  btnNext.Size.Height := 25;
  btnNext.Size.Width := 25;
  btnNext.Position.X := Width - 30;
  btnNext.Position.Y := (Height / 2) - 15;
  btnNext.OnClick := NextClick;

  btnPrevious := TSpeedButton.Create(Self);
  AddObject(btnPrevious);
  btnPrevious.BringToFront;
  btnPrevious.Text := '<';
  btnPrevious.Size.Height := 25;
  btnPrevious.Size.Width := 25;
  btnPrevious.Position.X := 5;
  btnPrevious.Position.Y := (Height / 2) - 15;
  btnPrevious.OnClick := PreviousClick;

  Animation := TFloatAnimation.Create(Self);
  AddObject(Animation);
  Animation.Duration := ADuration;
  Animation.PropertyName := 'Opacity';
  Animation.StartValue := 1;
  Animation.StopValue := 1;
  Animation.OnFinish := AnimationFinish;
  Animation.Start;

  EndUpdate;
end;

end.
