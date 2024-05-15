import 'package:flutter/material.dart';
import 'package:flutter_sample_hero/detail_page.dart';
import 'package:flutter_sample_hero/images.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          itemCount: imagePathList.length,
          itemBuilder: (context, index) {
            final imagePath = imagePathList[index];
            return GestureDetector(
              onTap: () {
                final route = PageRouteBuilder(
                  opaque: false, // 詳細画面から戻る時に一覧画面を透けさせたいのでfalseを指定する
                  pageBuilder: (context, animation1, animation2) =>
                      DetailPage(imagePaths: imagePathList),
                  transitionDuration: const Duration(milliseconds: 300),
                );
                Navigator.of(context).push(route);
              },
              child: Hero(
                tag: 'imagePath-$imagePath',
                child: Image.asset(
                  imagePathList[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
