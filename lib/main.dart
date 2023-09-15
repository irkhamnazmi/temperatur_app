import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:temperatur_app/temp_model.dart';
import 'package:temperatur_app/theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  String? temp;
  String? status;
  Color? colorStatus;
  late DatabaseReference dbRef;
  TempModel? tempModel;
  bool? isLoading;

  @override
  void initState() {
    isLoading = true;
    fetch();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      fetch();
    }
  }

  fetch() async {
    dbRef = FirebaseDatabase.instance.ref().child('sensorsuhu');
    // final DataSnapshot snapShot = await dbRef.get();
    dbRef.onValue.listen((DatabaseEvent event) {
      Map<String, dynamic> data = jsonDecode(jsonEncode(event.snapshot.value));
      tempModel = TempModel.fromJson(data);
      Future.delayed(const Duration(milliseconds: 500)).then((val) {
        getTemp(tempModel!.temperature!);
        isLoading = false;
      });
    });
  }

  getTemp(String value) {
    print(value);
    switch (double.parse(value)) {
      case <= 37.5:
        setState(() {
          status = 'Normal';
          colorStatus = cardColor1;
          temp = value.contains('.')
              ? double.parse(value).toString()
              : int.parse(value).toString();
        });

        break;
      case >= 37.6 && <= 38.5:
        setState(() {
          status = 'Dalam Pantauan';
          colorStatus = cardColor2;
          temp = value.contains('.')
              ? double.parse(value).toString()
              : int.parse(value).toString();
        });
        break;
      case >= 38.6:
        setState(() {
          status = 'Segera ambil tindakan';
          colorStatus = cardColor3;
          temp = value.contains('.')
              ? double.parse(value).toString()
              : int.parse(value).toString();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Container(
          margin: EdgeInsets.only(
              top: 39, right: defaultMargin, left: defaultMargin, bottom: 31),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'SENSOR SUHU BADAN',
                  style: primaryTextStyle.copyWith(
                      fontWeight: bold, fontSize: extralarge),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(defaultMargin),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), color: cardColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SUHU',
                      style: primaryTextStyle.copyWith(
                          fontSize: extralarge, fontWeight: bold),
                    ),
                    SizedBox(
                      height: small,
                    ),
                    Text(
                      isLoading == false ? '$temp°C' : '...',
                      style: primaryTextStyle.copyWith(
                          fontSize: 60, fontWeight: bold, color: colorStatus),
                    ),
                    SizedBox(
                      height: small,
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(
                    horizontal: defaultMargin * 2, vertical: defaultMargin),
                height: 63,
                decoration: BoxDecoration(
                    color: colorStatus,
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                height: extralarge * 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS :',
                    style: primaryTextStyle.copyWith(
                        fontSize: large, fontWeight: bold),
                  ),
                  SizedBox(
                    height: extraSmall,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 21),
                    decoration: BoxDecoration(
                      color: statusColor,
                    ),
                    child: Text(
                      isLoading == false ? status!.toUpperCase() : '...',
                      style: primaryTextStyle.copyWith(fontWeight: semiBold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
