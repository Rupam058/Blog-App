import 'package:flutter/material.dart';

class Mobile extends StatelessWidget {
  final Widget child;

  const Mobile({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: child,
      ),
    );
  }
}
