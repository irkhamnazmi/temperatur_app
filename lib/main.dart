import 'dart:async';

import 'package:flutter/material.dart';
import 'package:temperatur_app/mobile_design_widget.dart';
import 'package:temperatur_app/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Temp',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Monitoring Suhu Tubuh'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? temp;
  String? status;
  Color? colorStatus;

  @override
  void initState() {
    getInit();

    super.initState();
  }

  getInit() async {
    for (var i = 1; i < 4; i++) {
      await Future.delayed(const Duration(seconds: 2))
          .then((value) => getTemp(i));
    }
  }

  getTemp(var i) {
    switch (i) {
      case 1:
        setState(() {
          temp = '33';
          status = 'Normal';
          colorStatus = cardColor1;
        });

        break;
      case 2:
        setState(() {
          temp = '36.5';
          status = 'Dalam Pantauan';
          colorStatus = cardColor2;
        });
        break;
      case 3:
        setState(() {
          temp = '40';
          status = 'Segera ambil tindakan';
          colorStatus = cardColor3;
        });
        break;
      default:
        setState(() {
          temp = '33';
          status = 'Normal';
          colorStatus = cardColor1;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MobileDesignWidget(
      child: Scaffold(
          backgroundColor: backgroundColor,
          body: Container(
            margin:
                const EdgeInsets.only(top: 39, right: 7, left: 7, bottom: 31),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Monitoring Suhu Tubuh',
                    style: primaryTextStyle.copyWith(
                        fontWeight: semiBold, fontSize: large),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(large),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: backgroundColor2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Temperature',
                        style: primaryTextStyle.copyWith(
                          fontSize: extralarge,
                        ),
                      ),
                      const SizedBox(
                        height: 34,
                      ),
                      Text(
                        '${temp ?? '33'}  °C',
                        style: primaryTextStyle.copyWith(
                          fontSize: 50,
                          fontWeight: bold,
                        ),
                      ),
                      const SizedBox(
                        height: 34,
                      ),
                      Container(
                        width: double.infinity,
                        height: 63,
                        decoration:
                            BoxDecoration(color: colorStatus ?? cardColor1),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 21),
                  child: Text(
                    'Keterangan : ${status ?? 'Normal'}',
                  ),
                )
              ],
            ),
          )),
    );
  }
}
