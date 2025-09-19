import 'package:flutter/material.dart';
import '../widgets/otp_fields.dart';
import '../widgets/dialogs.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final ctrls = List.generate(4, (_) => TextEditingController());

  @override
  void dispose() { for (final c in ctrls) { c.dispose(); } super.dispose(); }

  void _resend() async {
    await showSuccessDialog(context, 'OTP resent to ${widget.email}');
  }

  void _verify() async {
    final code = ctrls.map((c) => c.text).join();
    if (code.length != 4) {
      await showErrorDialog(context, 'Enter 4-digit OTP');
      return;
    }
    await showSuccessDialog(context, 'Email verified');
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('A verification mail has been sent to\n${widget.email}', textAlign: TextAlign.center),
                const SizedBox(height: 16),
                OtpFields(ctrls: ctrls),
                const SizedBox(height: 8),
                TextButton(onPressed: _resend, child: const Text('Resend OTP')),
                const SizedBox(height: 12),
                SizedBox(height: 52, child: ElevatedButton(onPressed: _verify, child: const Text('Verify'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
