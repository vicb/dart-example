import 'package:http/http.dart' as http;
import 'package:json/json.dart' as json;
import 'package:http_server/http_server.dart';

import 'dart:io';

class FBParser {
  final String url;

  const FBParser(this.url);

  request(name) {
    var qsUrl = "$url/$name?fields=picture.type(small),name,about";

    return http.read(qsUrl).then((content) {
      var result = json.parse(content);
      return <String, String>{
        "title": result['name'],
        "description": result['about'],
        "logo": result['picture']['data']['url']
      };
    });
  }
}


main() {
  var staticFiles = new VirtualDirectory('web')
      ..allowDirectoryListing = true
      ..followLinks = true
      ..jailRoot = false;

  http://localhost:8080/packages

//  Error 404 at '/packages/json/json.dart': Not Found

  HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080).then((server) {
    server.listen((HttpRequest request) {
      var name = request.uri.queryParameters['name'];
      if (name != null) {
        var parser = new FBParser('https://graph.facebook.com');
        parser.request(name).then((res) {
          request.response
              ..write(json.stringify(res))
              ..close();
        });
      } else {
        staticFiles.serveRequest(request);
      }
    });
  });
}


