import 'package:flutter/widgets.dart';

class PageLayout extends StatelessWidget {
  final Widget page;
  const PageLayout({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.bottomCenter,
          fit: BoxFit.cover,
          opacity: 1,
          image: AssetImage('lib/assets/main_bg.png'),
        ),
      ),
      child: page,
    );
  }
}
