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
  // 写真のドラッグによるオフセット
  double _draggedVerticalOffset = 0;
  double _draggedHorizontalOffset = 0;

  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _verticalAnimation;
  late Animation<double> _horizontalAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100))
      ..addListener(() {
        setState(() {
          _draggedVerticalOffset = _verticalAnimation.value;
          _draggedHorizontalOffset = _horizontalAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  double _getImageRatio(double min, double max, double value) {
    return (value - min) / (max - min);
  }

  @override
  Widget build(BuildContext context) {
    // 写真の幅の初期値
    final initialWidth = MediaQuery.of(context).size.width;
    // アニメーション時の写真の最小幅
    final animationMixWidth = initialWidth / 2;
    // 現在の写真の幅と高さ
    final imageWidth =
        max(initialWidth - _draggedVerticalOffset, animationMixWidth);
    // 現在の写真の縮小の比率(0~1)
    final imageRatio =
        _getImageRatio(animationMixWidth, initialWidth, imageWidth);
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(imageRatio),
      appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(imageRatio),
        elevation: imageRatio,
        toolbarOpacity: imageRatio,
        bottomOpacity: imageRatio,
      ),
      body: Listener(
        onPointerDown: (PointerDownEvent event) {
          // アニメーションは一番上までスクロールしてから始める
          if (_scrollController.position.pixels > 0) return;
          // 前回のアニメーションを停止しておく
          _animationController.stop();
        },
        onPointerMove: (PointerMoveEvent event) {
          if (_scrollController.position.pixels > 0) return;
          final delta = event.delta;
          if (_draggedVerticalOffset + delta.dy < 0) {
            // 上までドラッグできないようにする
            return;
          }
          setState(() {
            // ドラッグした量を写真の位置とサイズに反映させる
            _draggedVerticalOffset += delta.dy;
            _draggedHorizontalOffset += delta.dx;
          });
        },
        onPointerUp: (PointerUpEvent event) {
          if (imageRatio <= 0.0) {
            // 閾値を超えた状態でドラッグを終了したら前の画面に戻る
            Navigator.of(context).pop();
            return;
          }

          // 写真を元のサイズと位置に戻すアニメーション実行
          _verticalAnimation = Tween<double>(
            begin: _draggedVerticalOffset,
            end: 0.0,
          ).animate(_animationController);
          _horizontalAnimation = Tween<double>(
            begin: _draggedHorizontalOffset,
            end: 0.0,
          ).animate(_animationController);
          _animationController.forward(from: 0);
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SizedBox(
            width: double.infinity, // 写真が縮小に比例してColumnも小さくなりy軸の移動がズレるため固定する
            child: Column(
              children: [
                Transform.translate(
                  offset:
                      Offset(_draggedHorizontalOffset, _draggedVerticalOffset),
                  child: Hero(
                    tag: 'imagePath-${widget.imagePath}',
                    child: SizedBox(
                      width: imageWidth,
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: imageRatio,
                  duration: Duration.zero,
                  child: const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      "長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列長い文字列",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
