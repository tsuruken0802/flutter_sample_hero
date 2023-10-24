import 'dart:math';

import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final String imagePath;

  const DetailPage({
    super.key,
    required this.imagePath,
  });

  @override
  State createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  final double _currentTopOffset = 0;
  final double _currentLeftOffset = 0;
  double _draggedTopOffset = 0;
  double _draggedLeftOffset = 0;

  late ScrollController scrollController;
  late AnimationController _controller;
  late Animation<double> _topAnimation;
  late Animation<double> _leftAnimation;

  bool enableScroll = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(() {
        setState(() {
          _draggedTopOffset = _topAnimation.value;
          _draggedLeftOffset = _leftAnimation.value;
        });
      });

    scrollController.addListener(() {
      if (scrollController.position.pixels <= 0) {
        setState(() {
          enableScroll = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  double calculateRatio(double min, double max, double value) {
    return (value - min) / (max - min);
  }

  @override
  Widget build(BuildContext context) {
    const minWidth = 200.0;
    final initialWidth = MediaQuery.of(context).size.width;
    final width = max(initialWidth - _draggedTopOffset, minWidth);
    final ratio = calculateRatio(minWidth, initialWidth, width);

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(ratio),
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(ratio),
        elevation: 0,
      ),
      body: Listener(
        onPointerDown: (PointerDownEvent event) {
          if (scrollController.position.pixels > 0) return;
          // アニメーションを停止
          _controller.stop();
        },
        onPointerMove: (PointerMoveEvent event) {
          if (scrollController.position.pixels > 0) return;
          final delta = event.delta;
          // 指が画面上を移動したときの処理
          print(event.delta.dy > 0);
          final vert = event.delta.dy > 0 ? "上" : "下";
          final hori = event.delta.dx > 0 ? "右" : "左";
          print("ver: $vert hori: $hori");

          if (_draggedTopOffset + delta.dy < 0) {
            print("上にアニメーションしようとしている");
            return;
          }
          setState(() {
            _draggedTopOffset += delta.dy;
            _draggedLeftOffset += delta.dx;
          });
        },
        onPointerUp: (PointerUpEvent event) {
          if (ratio <= 0.0) {
            Navigator.of(context).pop();
            return;
          }

          _topAnimation = Tween<double>(
            begin: _draggedTopOffset,
            end: _currentTopOffset,
          ).animate(_controller);

          _leftAnimation = Tween<double>(
            begin: _draggedLeftOffset,
            end: _currentLeftOffset,
          ).animate(_controller);

          _controller.forward(from: 0);

          setState(() {
            enableScroll = true;
          });
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(_draggedLeftOffset, _draggedTopOffset),
                child: Hero(
                  tag: 'imagePath-${widget.imagePath}',
                  child: SizedBox(
                    width: width,
                    height: width,
                    child: Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 1000,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}