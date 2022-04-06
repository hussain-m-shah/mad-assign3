import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  @override
  late int seconds;
  late Timer timer;
  bool isTicking = true;

  List<int> laps = [];

  @override
  void initState() {
    super.initState();
    seconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), _onTick);

    // _init();
  }

  // _init() async {
  //   final dir = await getApplicationDocumentsDirectory();

  //   // List<int> fetchedLaps = List<int>.from(await json
  //   //     .decode(await rootBundle.loadString('assets/files/laps.json')));

  //   // setState(() {
  //   //   laps = fetchedLaps;
  //   // });
  // }

  _getSortedLaps() {
    List<int> sortedLaps = [...laps];
    sortedLaps.sort(((a, b) => a > b ? -1 : 1));

    return sortedLaps
        .asMap()
        .entries
        .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Lap # ${laps.length - e.key}: ${e.value} secs",
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                ),
              ),
            ))
        .toList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset("assets/imgs/me.jpg"),
        title: Text("Muhammad Hussain Murtaza - 252030"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '$seconds ${_secondsText()}',
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Start'),
                      onPressed: isTicking ? null : _startTimer,
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Lap'),
                      onPressed: isTicking ? _newLap : null,
                    ),
                    SizedBox(width: 20),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Stop'),
                      onPressed: isTicking ? _stopTimer : null,
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.yellow),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text('Reset'),
                      onPressed: isTicking ? null : _restartTimer,
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Laps:",
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.headline5!.fontSize,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: _getSortedLaps(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _secondsText() => seconds == 1 ? 'second' : 'seconds';

  void _onTick(Timer time) {
    setState(() {
      ++seconds;
    });
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
    setState(() {
      isTicking = true;
    });
  }

  void _newLap() async {
    timer.cancel();

    // await getExternalStorageDirectory().then((Directory? dir) {
    //   if (dir != null) {
    //     File file = File('${dir.path}/assets/files/laps.json');
    //     file.writeAsStringSync(json.encode([...laps, seconds]));
    //   }
    // });
    timer = Timer.periodic(Duration(seconds: 1), _onTick);

    setState(() {
      laps = [...laps, seconds];
      seconds = 0;
      isTicking = true;
    });
  }

  void _restartTimer() {
    seconds = 0;
    timer = Timer.periodic(Duration(seconds: 1), _onTick);
    setState(() {
      isTicking = true;
    });
  }

  void _stopTimer() {
    timer.cancel();
    setState(() {
      isTicking = false;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
