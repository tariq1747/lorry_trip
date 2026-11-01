import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeAndroid extends StatefulWidget {
  const NativeAndroid({super.key});

  @override
  State<NativeAndroid> createState() => _NativeAndroidState();
}

class _NativeAndroidState extends State<NativeAndroid> {
  MethodChannel _methodChannel = const MethodChannel(
    'com.example.lorry_trip/native',
  );
  @override
  void initState() {
    _methodChannel.invokeMethod('native_android_method').catchError((err) {
      print('Error invoking native method: $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Android')),
      body: const Center(child: Text('This is the Native Android page.')),
    );
  }
}
