import 'package:app/features/calendar/calendar_page.dart';
import 'package:app/features/history/history_page.dart';
import 'package:app/features/home/page_state_provider.dart';
import 'package:app/features/today/today_page.dart';
import 'package:app/features/train_samples/trains_samples_page.dart';
import 'package:app/shared/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (ctx, ref, child) {
          final pageState = ref.watch(pageStateProvider);
          final pageStateNotifier = ref.read(pageStateProvider.notifier);
          return Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _createBody(pageState.index),
            ),
            backgroundColor: AppColors.background,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.accent,
                        blurRadius: 10,
                        spreadRadius: 0)
                  ],
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20))),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: BottomNavigationBar(
                  backgroundColor: AppColors.accent,
                  unselectedIconTheme:
                      IconThemeData(color: AppColors.white.withOpacity(.5)),
                  currentIndex: pageState.index,
                  selectedFontSize: 16,
                  selectedIconTheme: IconThemeData(color: AppColors.white),
                  selectedItemColor: Colors.white,
                  onTap: (value) {
                    HapticFeedback.selectionClick();
                    pageStateNotifier.toPage(
                        value, PageChangeEventType.FromNavigation);
                  },
                  type: BottomNavigationBarType.shifting,
                  items: _bottomNavigationBars,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _createBody(int index) {
    Widget body;
    switch (index) {
      case 0:
        body = const TodayPage();
        break;
      case 1:
        body = const CalendarPage();
        break;
      case 2:
        body = const TrainSamplesPage();
        break;
      case 3:
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
        label: 'Сегодня',
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.today),
      ),
      BottomNavigationBarItem(
        label: 'Календарь',
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.calendar_month),
      ),
      BottomNavigationBarItem(
        label: 'Тренировки',
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.fitness_center_outlined),
      ),
      BottomNavigationBarItem(
        label: 'История',
        backgroundColor: AppColors.accent,
        icon: const Icon(Icons.history),
      ),
    ];
  }
}
