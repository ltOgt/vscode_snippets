import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;

http.Response? _response;
dom.Document? _html;

_response = await http.get(Uri.https("google.com", "", {'q': _query.obj.text}));

if (_response!.statusCode == 200) {
  _html = parser.parse(_response!.body);
}
