unit NotificationServiceUnit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Android.Service,
  AndroidApi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Os, System.Notification, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TNotificationServiceDM = class(TAndroidService)
    IdHTTPServer1: TIdHTTPServer;
    IdHTTP1: TIdHTTP;
    function AndroidServiceStartCommand(const Sender: TObject; const Intent: JIntent; Flags, StartId: Integer): Integer;
    procedure IdHTTPServer1CommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  private
    { Private declarations }
    FThread: TThread;
  public
    { Public declarations }
  end;

var
  NotificationServiceDM: TNotificationServiceDM;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  Androidapi.JNI.App, System.DateUtils;

{$R *.dfm}

function TNotificationServiceDM.AndroidServiceStartCommand(const Sender: TObject; const Intent: JIntent; Flags,
  StartId: Integer): Integer;
begin
  Result := TJService.JavaClass.START_STICKY;
end;

procedure TNotificationServiceDM.IdHTTPServer1CommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  i:integer;
  Query: String;
  HttpResponse: String;
  Response: String;
begin
  IdHTTP1 := TIdHTTP.Create;
  AResponseInfo.ContentType := 'text/html';
  AResponseInfo.ContentEncoding := 'UTF-8';
  AResponseInfo.CharSet := 'UTF-8';
  if(ARequestInfo.URI='/registerSlipReceipt') then
  begin
    Query:='http://localhost:8080/printSlipReceipt';
  end
  else if(ARequestInfo.URI = '/registerReceipt') then
  begin
    Query := 'http://localhost:8080/printReceipt';
  end
  else
  begin
    Query := 'http://localhost:8080';
  end;
  HttpResponse := IdHTTP1.Get(Query);
  Response := HttpResponse + Query;
  AResponseInfo.ContentText := Response;
  For i:=0 to ARequestInfo.Params.Count-1 do
  begin
    AResponseInfo.ContentText:=AResponseInfo.ContentText + ' ' + i.ToString + '=' + ARequestInfo.Params[i];
  end;
end;

end.
