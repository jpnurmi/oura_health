import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'sleep_notifier.dart';

class SleepView extends StatefulWidget {
  const SleepView({super.key});

  static Widget create() {
    return ChangeNotifierProvider(
      create: (context) => SleepNotifier(),
      child: const SleepView(),
    );
  }

  @override
  State<SleepView> createState() => _SleepViewState();
}

class _SleepViewState extends State<SleepView> {
  @override
  void initState() {
    super.initState();
    context.read<SleepNotifier>().init();
  }

  Future<void> _launchFit() async {
    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.google.android.apps.fitness',
      componentName: 'com.google.android.apps.fitness.welcome.WelcomeActivity',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK, Flag.FLAG_ACTIVITY_CLEAR_TOP],
    );
    return intent.launch();
  }

  Future<void> _launchHealth() async {
    await launchUrl(Uri.parse('x-apple-health://'));
  }

  Future<void> _download() async {
    await launchUrl(
      Uri.https('membership.ouraring.com', '/data-export'),
    );
  }

  Future<void> _import({required bool full}) async {
    final notifier = context.read<SleepNotifier>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'json', 'zip'],
    );
    final path = result?.files.singleOrNull?.path;
    if (path != null) {
      await notifier.import(path, full: full);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<SleepNotifier>();
    return Column(
      children: [
        Visibility(
          maintainSize: true,
          maintainState: true,
          maintainAnimation: true,
          visible: notifier.progress != null,
          child: LinearProgressIndicator(value: notifier.progress ?? 0),
        ),
        Expanded(
          child: FractionallySizedBox(
            widthFactor: 0.5,
            alignment: Alignment.center,
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: notifier.progress != null ? null : _download,
                  child: const Text('Download'),
                ),
                ElevatedButton(
                  onPressed: notifier.progress != null
                      ? null
                      : () => _import(full: false),
                  child: const Text('Quick Import'),
                ),
                ElevatedButton(
                  onPressed: notifier.progress != null
                      ? null
                      : () => _import(full: true),
                  child: const Text('Full Import'),
                ),
                if (Platform.isAndroid)
                  ElevatedButton(
                    onPressed: notifier.progress != null ? null : _launchFit,
                    child: const Text('Launch Fit'),
                  ),
                if (Platform.isIOS)
                  ElevatedButton(
                    onPressed: notifier.progress != null ? null : _launchHealth,
                    child: const Text('Launch Health'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
