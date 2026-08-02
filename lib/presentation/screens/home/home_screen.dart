import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/greeting_card.dart';
import 'widgets/today_progress.dart';
import 'widgets/quick_stats.dart';
import 'widgets/focus_quick_start.dart';
import 'widgets/daily_missions_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const GreetingCard(),
              const SizedBox(height: 20),
              const TodayProgress(),
              const SizedBox(height: 20),
              const QuickStats(),
              const SizedBox(height: 24),
              const FocusQuickStart(),
              const SizedBox(height: 24),
              const DailyMissionsCard(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
