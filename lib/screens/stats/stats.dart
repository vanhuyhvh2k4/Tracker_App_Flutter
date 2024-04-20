import 'package:flutter/material.dart';
import 'package:tracker_app/screens/stats/chart.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10),
      child: Column(
        children: [
          const Text(
            "Transactions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(12, 20, 12, 12),
              child: MyChart(),
            ),
          )
        ],
      ),
    ));
  }
}
