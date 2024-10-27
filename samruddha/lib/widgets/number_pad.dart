import 'package:flutter/material.dart';

class NumberPad extends StatelessWidget {
  final Function(String) onNumberSelected;
  final VoidCallback onBackspace;

  NumberPad({required this.onNumberSelected, required this.onBackspace, required Color textColor, required Color backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      children: List.generate(12, (index) {
        if (index == 9) {
          return Container();
        } else if (index == 10) {
          return NumberButton(
            number: '0',
            onPressed: () => onNumberSelected('0'),
          );
        } else if (index == 11) {
          return IconButton(
            icon: Icon(Icons.backspace),
            onPressed: onBackspace,
          );
        } else {
          return NumberButton(
            number: (index + 1).toString(),
            onPressed: () => onNumberSelected((index + 1).toString()),
          );
        }
      }),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final VoidCallback onPressed;

  NumberButton({required this.number, required this.onPressed});

  

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        number,
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}