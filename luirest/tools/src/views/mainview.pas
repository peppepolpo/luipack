unit MainView;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, VTJSON, RESTAPI,
  VirtualTrees, fpjson, EndPointView;

type

  { TMainForm }

  TMainForm = class(TForm)
    LoadCollectionButton: TButton;
    EndPointListView: TVirtualJSONListView;
    Label1: TLabel;
    BaseURLLabel: TLabel;
    OpenDialog1: TOpenDialog;
    procedure EndPointListViewFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure EndPointListViewFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
    procedure EndPointListViewGetText(Sender: TCustomVirtualJSONDataView; Node: PVirtualNode;
      NodeData: TJSONData; Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure LoadCollectionButtonClick(Sender: TObject);
  private
    FAPI: TRESTAPI;
    FEndPointView: TEndPointFrame;
    procedure UpdateAPIViews;
  public
    constructor Create(TheOwner: TComponent); override;
  end;

var
  MainForm: TMainForm;

implementation

uses
  LuiJSONHelpers;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.LoadCollectionButtonClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FAPI.LoadFromFile(OpenDialog1.FileName);
    UpdateAPIViews;
  end;
end;

procedure TMainForm.EndPointListViewGetText(Sender: TCustomVirtualJSONDataView; Node: PVirtualNode;
  NodeData: TJSONData; Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
begin
  CellText := NodeData.GetPath('request.url', '');
  CellText := Copy(CellText, Length(FAPI.BaseURL) + 1, Length(CellText));
end;

procedure TMainForm.EndPointListViewFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex);
var
  EndPointData: TJSONObject;
begin
  if EndPointListView.GetData(Node, EndPointData) then
    FEndPointView.SetEndPoint(EndPointData);
end;

procedure TMainForm.EndPointListViewFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex; var Allowed: Boolean);
begin
  //todo: implement guard against changes in current endpoint
end;

procedure TMainForm.UpdateAPIViews;
begin
  BaseURLLabel.Caption := FAPI.BaseURL;
  EndPointListView.Data := FAPI.EndPointListData;
  EndPointListView.LoadData;
end;

constructor TMainForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FAPI := TRESTAPI.Create(Self);
  FEndPointView := TEndPointFrame.Create(Self);
  FEndPointView.Parent := Self;
  FEndPointView.Align := alRight;
  FEndPointView.Visible := True;
end;

end.
