import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.option,
    required this.color,
    this.icon,
  });
  final String option;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            option,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          if (icon != null)
            Icon(
              icon,
              color: Colors.white,
            )
        ],
      ),
    );
    // return Card(
    //   color: color,
    //   child: ListTile(
    //     title: Text(
    //       option,
    //       textAlign: TextAlign.center,
    //       style: TextStyle(fontSize: 22.0),
    //     ),
    //   ),
    // );
  }
}
