import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expense_tracker/widgets/expenses.dart';
import 'package:expense_tracker/theme/app_theme.dart';

const _themePrefKey = 'theme_mode';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final themeMode = _decodeThemeMode(prefs.getString(_themePrefKey));
  runApp(ExpenseTrackerApp(initialThemeMode: themeMode, prefs: prefs));
}

ThemeMode _decodeThemeMode(String? raw) {
  switch (raw) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

String _encodeThemeMode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.light:
      return 'light';
    case ThemeMode.system:
      return 'system';
  }
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({
    super.key,
    required this.initialThemeMode,
    required this.prefs,
  });

  final ThemeMode initialThemeMode;
  final SharedPreferences prefs;

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  late ThemeMode _themeMode = widget.initialThemeMode;

  void _cycleThemeMode() {
    ThemeMode next;
    if (_themeMode == ThemeMode.system) {
      next = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      next = ThemeMode.dark;
    } else {
      next = ThemeMode.system;
    }

    setState(() => _themeMode = next);
    widget.prefs.setString(_themePrefKey, _encodeThemeMode(next));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: Expenses(
        themeMode: _themeMode,
        onToggleTheme: _cycleThemeMode,
      ),
    );
  }
  }