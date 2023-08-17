// To parse this JSON data, do
//
//     final image = imageFromMap(jsonString);

import 'dart:convert';

ImageData imageFromMap(String str) => ImageData.fromMap(json.decode(str));

String imageToMap(ImageData data) => json.encode(data.toMap());

class ImageData {
  int created;
  List<Datum> data;

  ImageData({
    required this.created,
    required this.data,
  });

  factory ImageData.fromMap(Map<String, dynamic> json) => ImageData(
    created: json["created"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "created": created,
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class Datum {
  String url;

  Datum({
    required this.url,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    url: json["url"],
  );

  Map<String, dynamic> toMap() => {
    "url": url,
  };
}
