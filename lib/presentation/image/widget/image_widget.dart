import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      data,
      fit: BoxFit.cover,
      loadingBuilder:
          (BuildContext ctx, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: LoadingAnimationWidget.hexagonDots(
                size: 50, color: Colors.deepPurple),
          );
        }
      },
    );
  }
}
