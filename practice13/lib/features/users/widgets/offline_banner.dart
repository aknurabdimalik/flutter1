import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.amber.shade100,
      padding: const EdgeInsets.all(8),
      child: const Row(
        children: [
          Icon(Icons.wifi_off),
          SizedBox(width: 8),
          Expanded(child: Text('Offline — showing saved data')),
        ],
      ),
    );
  }
}