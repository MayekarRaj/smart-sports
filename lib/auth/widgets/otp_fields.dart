import 'package:flutter/material.dart';

class OtpFields extends StatelessWidget {
  final List<TextEditingController> ctrls;
  const OtpFields({super.key, required this.ctrls});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Container(
          width: 56,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: ctrls[i],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(counterText: ''),
            onChanged: (v) {
              if (v.isNotEmpty && i < 3) FocusScope.of(context).nextFocus();
            },
          ),
        );
      }),
    );
  }
}
