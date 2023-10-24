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
        child: ListView.separated(
          itemCount: imagePathList.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final imagePath = imagePathList[index];
            return GestureDetector(
              onTap: () {
                final route = PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (context, animation1, animation2) =>
                      DetailPage(imagePath: imagePath),
                  transitionDuration: const Duration(milliseconds: 300),
                );
                Navigator.of(context).push(route);
              },
              child: SizedBox(
                width: 100,
                height: 200,
                child: Hero(
                  tag: 'imagePath-$imagePath',
                  child: Image.asset(imagePathList[index]),
                ),
              ),
            );
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
