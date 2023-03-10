import 'package:flutter/material.dart';

class Test2 {
  final int id;
  final String title, description;

  Test2({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Test2.fromJson(Map<String, dynamic> json) {
    /// json => Send POST
    return Test2(
      id: json['id'] as int,
      title: json['first_name'] as String,
      description: json['last_name'] as String,
    );
  }
  //
  //
}
