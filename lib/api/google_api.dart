import 'package:googleapis/drive/v3.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:http/http.dart';
import 'package:watchlist/models/content.dart';

final defaultSpreadsheet = Spreadsheet.fromJson({
  'properties': {
    'title': "Watchlist",
  },
});

class GoogleAuthClient extends BaseClient {
  final Map<String, String> _headers;

  final Client _client = new Client();

  GoogleAuthClient(this._headers);

  Future<StreamedResponse> send(BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleApi {
  static DriveApi _driveApi;
  static SheetsApi _sheetsApi;
  static GoogleAuthClient _authClient;
  static String _spreadsheetId;

  static initialize(Map<String, String> authHeaders) async {
    _authClient = GoogleAuthClient(authHeaders);
    _sheetsApi = SheetsApi(_authClient);
    _driveApi = DriveApi(_authClient);
    _spreadsheetId = await getOrUploadWatchlistFile();
  }

  // Returns spreadsheet id
  static Future<String> getOrUploadWatchlistFile() async {
    final FileList list = await _driveApi.files.list(
        q: "mimeType='application/vnd.google-apps.spreadsheet' and name='Watchlist'");

    if (list.files.isNotEmpty) {
      return list.files[0].id;
    }

    return (await _sheetsApi.spreadsheets.create(defaultSpreadsheet))
        .spreadsheetId;
  }

  static Future<List<Content>> fetchWatchlist() async {
    final response = await _sheetsApi.spreadsheets.values
        .batchGet(_spreadsheetId, ranges: ["A1:F1000"]);

    final values = response.valueRanges[0].values.toList();

    return values.map((e) => Content.fromSheets(e)).toList();
  }

  static Future<List<Content>> addContent(Content content) async {
    await _sheetsApi.spreadsheets.values.append(
      ValueRange.fromJson({
        'range': 'A1:E1000',
        'values': content.toNewValues(),
      }),
      _spreadsheetId,
      'A1:E1000',
      valueInputOption: 'RAW',
    );

    return await fetchWatchlist();
  }
}
