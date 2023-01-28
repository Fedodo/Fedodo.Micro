import 'package:flutter/material.dart';

import 'navigation.dart';

void main() {
  runApp(const FedidoMicro());
}

class FedidoMicro extends StatelessWidget {
  const FedidoMicro({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fedodo Micro',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const Navigation(title: 'Fedodo Micro'),
    );
  }
}