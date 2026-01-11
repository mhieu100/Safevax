import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'msg_arrow_painter.dart';
import 'msg_box.dart';

class ReceiveMsgBox extends MsgBox {
  final String message;

  const ReceiveMsgBox(
      {super.key, required this.message, required super.animationController});

  @override
  Widget buildWidgets(BuildContext context) {
    final messageTextGroup = Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            'https://reqres.in/img/faces/2-image.jpg',
            width: 46,
            height: 46,
            fit: BoxFit.fill,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Image(
                image: AssetImage('assets/images/icon_success.png'),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
          const SizedBox(width: 10),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: CustomPaint(painter: MsgArrowPainter(Colors.white)),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 10, top: 10, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const SizedBox(height: 30),
          messageTextGroup,
        ],
      ),
    );
  }
}
