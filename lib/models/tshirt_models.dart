import 'package:flutter/material.dart';

class TShirtElement {
  String? text;
  String? imagePath;
  double x;
  double y;
  double width;
  double height;
  String fontFamily;
  double fontSize;
  Color textColor;
  double rotation;
  double scale;
  bool shadowEnabled;
  bool circuitEnabled;
  String alignment;
  bool allCaps;
  bool mixedCase;
  double lineThickness;

  TShirtElement({
    this.text,
    this.imagePath,
    required this.x,
    required this.y,
    this.width = 200,
    this.height = 80,
    this.fontFamily = 'Roboto',
    this.fontSize = 46,
    this.textColor = Colors.black,
    this.rotation = 0.0,
    this.scale = 1.0,
    this.shadowEnabled = false,
    this.circuitEnabled = false,
    this.alignment = 'Center',
    this.allCaps = false,
    this.mixedCase = false,
    this.lineThickness = 4,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'imagePath': imagePath,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'textColor': (textColor.a * 255).round() << 24 | (textColor.r * 255).round() << 16 | (textColor.g * 255).round() << 8 | (textColor.b * 255).round(),
      'rotation': rotation,
      'scale': scale,
      'shadowEnabled': shadowEnabled,
      'circuitEnabled': circuitEnabled,
      'alignment': alignment,
      'allCaps': allCaps,
      'mixedCase': mixedCase,
      'lineThickness': lineThickness,
    };
  }

  static TShirtElement fromJson(Map<String, dynamic> json) {
    return TShirtElement(
      text: json['text'],
      imagePath: json['imagePath'],
      x: json['x'],
      y: json['y'],
      width: json['width'] ?? 200,
      height: json['height'] ?? 80,
      fontFamily: json['fontFamily'] ?? 'Roboto',
      fontSize: json['fontSize'] ?? 46,
      textColor: Color(json['textColor'] ?? 0xFF000000),
      rotation: json['rotation'] ?? 0.0,
      scale: json['scale'] ?? 1.0,
      shadowEnabled: json['shadowEnabled'] ?? false,
      circuitEnabled: json['circuitEnabled'] ?? false,
      alignment: json['alignment'] ?? 'Center',
      allCaps: json['allCaps'] ?? false,
      mixedCase: json['mixedCase'] ?? false,
      lineThickness: json['lineThickness'] ?? 4,
    );
  }
}

class TShirtDesign {
  List<TShirtElement> frontElements;
  List<TShirtElement> backElements;
  Color tshirtColor;
  String designName;
  DateTime createdAt;

  TShirtDesign({
    List<TShirtElement>? frontElements,
    List<TShirtElement>? backElements,
    this.tshirtColor = Colors.white,
    this.designName = 'New Design',
    DateTime? createdAt,
  })  : frontElements = frontElements ?? [],
        backElements = backElements ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'frontElements': frontElements.map((e) => e.toJson()).toList(),
      'backElements': backElements.map((e) => e.toJson()).toList(),
      'tshirtColor': (tshirtColor.a * 255).round() << 24 | (tshirtColor.r * 255).round() << 16 | (tshirtColor.g * 255).round() << 8 | (tshirtColor.b * 255).round(),
      'designName': designName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static TShirtDesign fromJson(Map<String, dynamic> json) {
    return TShirtDesign(
      frontElements: (json['frontElements'] as List?)
          ?.map((e) => TShirtElement.fromJson(e))
          .toList() ?? [],
      backElements: (json['backElements'] as List?)
          ?.map((e) => TShirtElement.fromJson(e))
          .toList() ?? [],
      tshirtColor: Color(json['tshirtColor'] ?? 0xFFFFFFFF),
      designName: json['designName'] ?? 'New Design',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}