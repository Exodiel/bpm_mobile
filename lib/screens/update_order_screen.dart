import 'package:flutter/material.dart';

class UpdateOrderScreen extends StatefulWidget {
  const UpdateOrderScreen({Key? key}) : super(key: key);

  @override
  _UpdateOrderScreenState createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden'),
      ),
      body: Container(),
    );
  }
}
