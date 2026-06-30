import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  String shortcut = 'no action set';

  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        shortcut = shortcutType;
      });
    });

    quickActions
        .setShortcutItems(<ShortcutItem>[
          const ShortcutItem(
            type: "“I’m feeling lucky",
            localizedTitle: "“I’m feeling lucky",
            icon: 'ic_launcher',
          ),
        ])
        .then((void _) {
          setState(() {
            if (shortcut == 'no action set') {
              shortcut = 'actions ready';
            }
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(shortcut)),
      body: const Center(
        child: Text(
          'On home screen, long press the app icon to '
          'get Action one or Action two options. Tapping on that action should  '
          'set the toolbar title.',
        ),
      ),
    );
  }
}
