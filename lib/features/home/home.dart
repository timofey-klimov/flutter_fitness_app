import 'package:app/features/history/history_page.dart';
import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _createBody(currentPage),
      ),
      backgroundColor: AppColors.background,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: AppColors.accent, blurRadius: 10, spreadRadius: 0)
            ],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: AppColors.accent,
            unselectedIconTheme:
                IconThemeData(color: AppColors.white.withOpacity(.5)),
            currentIndex: currentPage,
            selectedFontSize: 16,
            selectedIconTheme: IconThemeData(color: AppColors.white),
            selectedItemColor: Colors.white,
            onTap: (value) {
              HapticFeedback.selectionClick();
              setState(() {
                currentPage = value;
              });
            },
            type: BottomNavigationBarType.shifting,
            items: _bottomNavigationBars,
          ),
        ),
      ),
    ));
  }

  Widget _createBody(int index) {
    Widget body;
    switch (index) {
      case 0:
        body = const HistoryPage();
        break;
      case 1:
        body = const HistoryPage();
        break;
      default:
        throw Error();
    }

    return body;
  }

  List<BottomNavigationBarItem> get _bottomNavigationBars {
    return <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        label: 'История',
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.history),
      ),
      BottomNavigationBarItem(
        label: 'Прогресс',
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.graphic_eq_rounded),
      ),
    ];
  }
}
