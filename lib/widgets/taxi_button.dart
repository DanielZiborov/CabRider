import 'package:flutter/material.dart';

class TaxiButton extends StatelessWidget {

  final String title;
  final Color color;
  final void Function()? onPressed;

  const TaxiButton({
    super.key,
    required this.title, 
    required this.color, 
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        backgroundColor: WidgetStatePropertyAll(color),
        foregroundColor: const WidgetStatePropertyAll(Colors.white),
      ),
      child: SizedBox(
        height: 50,
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'brand-bold',
            ),
          ),
        ),
      ),
    );
  }
}
