import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _channel = const MethodChannel("com.michaelhitzker.vikings-watch");
  String? _title;

  @override
  void initState() {
    super.initState();

    _channel.setMethodCallHandler((call) async {
      final methodName = call.method;
      final args = call.arguments;

      if (methodName != "updateTextFromWatch") {
        return;
      }

      final text = args["text"];
      setState(() {
        _title = text;
      });
    });
  }

  void _updateText(String text) {
    setState(() {
      _title = text;
    });
    _sendNewTextToAppleWatch(text);
  }

  void _sendNewTextToAppleWatch(String text) {
    _channel.invokeMethod("forwardToAppleWatch", {
      "method": "updateTextFromFlutter",
      "data": {
        "text": text,
      },
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(_title ?? "Nothing communicated yet"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _updateText("Skal!📱"),
                  child: const Text(
                    "🍻",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () => _updateText("Hej!📱"),
                  child: const Text(
                    "👋",
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
