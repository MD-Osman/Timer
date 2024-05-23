import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('timerBox');
  runApp(const MainHome());
}

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  bool start = false;
  int milisn = 0;
  int saniye = 0;
  int hour = 0;
  int minute = 0;
  Timer? timer;
  bool buttonActine = true;
  bool showInfoBox = false;
  String savedTime = '';
  bool drawNotEmpty = true;
  Box get timerBox => Hive.box('timerBox');
  final TextEditingController descriptionController = TextEditingController();

  // ignore: non_constant_identifier_names
  void Zaman() {
    showInfoBox = false;
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(
          () {
            if (saniye >= 60) {
              minute++;
              saniye = 0;
            } else if (saniye < 60) {
              saniye++;
            }

            if (minute >= 60) {
              hour++;
              minute = 0;
            }
          },
        );
      },
    );
  }

  void cler() {
    Hive.box('timerBox').clear();
  }

  // ignore: non_constant_identifier_names
  void ButtonFuncT() {
    setState(() {
      buttonActine = false;
    });
  }

  // ignore: non_constant_identifier_names
  void ButtonFuncF() {
    setState(() {
      buttonActine = true;
    });
  }

  // ignore: non_constant_identifier_names
  void ClearFun() {
    setState(() {
      saniye = 00;
      minute = 00;
      hour = 00;
      showInfoBox = false;
      start = false;
    });
  }

  String startstate() {
    setState(() {
      start;
    });
    return start ? "Continue" : "Start";
  }

  // ignore: non_constant_identifier_names
  void Pausefn() {
    final timeString = '$hour:$minute:$saniye';
    setState(() {
      savedTime = timeString;
      start = true;
      showInfoBox = true;
    });
  }

  // ignore: non_constant_identifier_names
  void SaveTimer() {
    final timeString = '$hour:$minute:$saniye';
    final description = descriptionController.text;
    final timerData = {
      'time': timeString,
      'description': description
    };
    timerBox.add(timerData);
    setState(() {
      drawNotEmpty = true;
      start = true;
      savedTime = timeString;
      descriptionController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Timer saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFDDDDDD),
        drawer: Drawer(
          backgroundColor: const Color(0xFFDDDDDD),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Saved Data',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: 'Alhadari',
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          cler();
                          setState(() {
                            drawNotEmpty = false;
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'Clear History',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Finland',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                itemCount: timerBox.length,
                itemBuilder: (context, index) {
                  final timerData = timerBox.getAt(index) as Map<String, dynamic>;
                  final timeString = timerData['time'] as String;
                  final description = timerData['description'] as String;
                  if (drawNotEmpty) {
                    return ListTile(
                      title: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Time: $timeString' 's'),
                            const SizedBox(height: 5),
                            Text('Description: $description'),
                          ],
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(
                  Icons.calendar_month,
                ),
                color: Colors.amber,
              );
            },
          ),
          backgroundColor: const Color(0xFF000000),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        hour.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        minute.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const Text(
                        ':',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        saniye.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Opacity(
                    opacity: buttonActine ? 1 : 0.6,
                    child: MaterialButton(
                      onPressed: () {
                        if (buttonActine) {
                          Zaman();
                          ButtonFuncT();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            startstate(),
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'Finland',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: !buttonActine ? 1 : 0.6,
                    child: MaterialButton(
                      onPressed: () {
                        Pausefn();
                        if (!buttonActine) {
                          timer?.cancel();
                          ButtonFuncF();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Pause',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Finland',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MaterialButton(
                    onPressed: () {
                      timer?.cancel();
                      ButtonFuncF();
                      ClearFun();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 3,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Finland',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: buttonActine ? 1 : 0.6,
                    child: MaterialButton(
                      onPressed: () {
                        if (buttonActine) {
                          SaveTimer();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.blue[500],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Finland',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (showInfoBox)
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Information',
                        style: TextStyle(
                          fontFamily: 'Victor',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(
                        color: Colors.black38,
                        thickness: 2,
                        indent: 25,
                        endIndent: 25,
                      ),
                      Text(
                        'Saved Time: $savedTime',
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Alhadari',
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Add description..',
                            hintText: ' \'Running Race ...\'',
                          ),
                          controller: descriptionController,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
