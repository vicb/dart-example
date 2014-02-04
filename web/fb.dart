import 'package:json/json.dart' as json;
import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('facebook-info')
class FbElement extends PolymerElement {
  @observable String name;
  @observable String title;
  @observable String description;
  @observable String logoUrl;

  FbElement.created() : super.created();

  void fetch(Event e, var detail, Node target) {
    HttpRequest.getString('http://localhost:8080/?name=$name').then((resp) {
      var info = json.parse(resp);
      title = info['title'];
      description = info['description'];
      logoUrl = info['logo'];
    });
  }
}