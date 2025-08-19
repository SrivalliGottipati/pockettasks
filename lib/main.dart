import 'package:flutter/material.dart';
import 'state/tasks_controller.dart';
import 'screens/home_screen.dart';

void main() {
	runApp(const PocketTasksApp());
}

class PocketTasksApp extends StatefulWidget {
	const PocketTasksApp({super.key});

	@override
	State<PocketTasksApp> createState() => _PocketTasksAppState();
}

class _PocketTasksAppState extends State<PocketTasksApp> {
	late final TasksController controller = TasksController();

  @override
  Widget build(BuildContext context) {
		final baseLight = ThemeData(
			colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A4CFF)),
			useMaterial3: true,
		);
		final baseDark = ThemeData.dark(useMaterial3: true).copyWith(
			colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB084FF), brightness: Brightness.dark),
		);
    return MaterialApp(
			title: 'PocketTasks',
			debugShowCheckedModeBanner: false,
			theme: baseLight,
			darkTheme: baseDark,
			home: AnimatedBuilder(
				animation: controller,
				builder: (context, _) => HomeScreen(controller: controller),
			),
		);
	}
}
