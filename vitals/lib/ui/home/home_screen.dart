import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bev_counter/extensions/shared_preferences_extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _channel = const MethodChannel("com.michaelhitzker.vitals");
  SharedPreferences? _sp;

  int get _beerAmount {
    return _sp?.beerCount ?? 0;
  }

  int get _coffeeAmount {
    return _sp?.coffeeCount ?? 0;
  }

  set _beerAmount(int newValue) {
    _sp?.beerCount = newValue;
  }

  set _coffeeAmount(int newValue) {
    _sp?.coffeeCount = newValue;
  }

  @override
  void initState() {
    super.initState();
    _initSharedPrefs();

    _channel.setMethodCallHandler((call) async {
      final methodName = call.method;
      switch (methodName) {
        case "increaseBeerFromWatch":
          _increaseBeer();
          return;
        case "increaseCoffeeFromWatch":
          _increaseCoffee();
          return;
        case "sendCounterToWatch":
          _sendCounterToAppleWatch();
          return;
        default:
          return;
      }
    });
  }

  Future<void> _initSharedPrefs() async {
    _sp = await SharedPreferences.getInstance();
    setState(() {});
  }

  void _increaseBeer() {
    _beerAmount += 1;
    _sendCounterToAppleWatch();
    setState(() {});
  }

  void _increaseCoffee() {
    _coffeeAmount += 1;
    _sendCounterToAppleWatch();
    setState(() {});
  }

  void _sendCounterToAppleWatch() {
    _channel.invokeMethod("forwardToAppleWatch", {
      "method": "updateCounterFromFlutter",
      "data": {
        "coffee": _coffeeAmount,
        "beer": _beerAmount,
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
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _counter(_beerAmount, "🍻"),
                    const SizedBox(
                      width: 30,
                    ),
                    _counter(_coffeeAmount, "☕️"),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button("🍻", onPressed: _increaseBeer),
                const SizedBox(
                  width: 30,
                ),
                _button("☕️", onPressed: _increaseCoffee),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _button(String emoji, {VoidCallback? onPressed}) {
    return TextButton(
      onPressed: onPressed,
      onLongPress: () {
        _sp?.clear();
        setState(() {});
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(1),
        backgroundColor: MaterialStateProperty.all(
          const Color(
            0xFFFFFFFF,
          ),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _counter(int value, String emoji) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$value",
          style: const TextStyle(
            fontSize: 50,
          ),
        ),
        Text(
          emoji,
          style: const TextStyle(
            fontSize: 30,
          ),
        )
      ],
    );
  }
}
