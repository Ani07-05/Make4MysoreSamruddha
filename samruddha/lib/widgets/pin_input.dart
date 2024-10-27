import 'package:flutter/material.dart';
import 'number_pad.dart';
import '../localization/app_localizations.dart';

class PinInput extends StatefulWidget {
  final Function(String) onPinEntered;
  final Color textColor;
  final Color backgroundColor;

  PinInput({
    required this.onPinEntered,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black,
  });

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  String _pin = '';

  void _onNumberPressed(String number) {
    setState(() {
      if (_pin.length < 4) {
        _pin += number;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _onSubmit() {
    if (_pin.length == 4) {
      widget.onPinEntered(_pin); // Calls onPinEntered with the entered PIN
      setState(() {
        _pin = ''; // Reset PIN display after submission
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Container(
              width: 20,
              height: 20,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < _pin.length ? widget.textColor : Colors.grey,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        NumberPad(
          onNumberSelected: _onNumberPressed,
          onBackspace: _onBackspace,
          textColor: widget.textColor,
          backgroundColor: widget.backgroundColor,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _pin.length == 4 ? _onSubmit : null,
          style: ElevatedButton.styleFrom(
            foregroundColor: widget.backgroundColor,
            backgroundColor: widget.textColor,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          child: Text(
            AppLocalizations.of(context)?.translate('submit') ?? 'Submit',
            style: TextStyle(color: widget.backgroundColor),
          ),
        ),
      ],
    );
  }
}
