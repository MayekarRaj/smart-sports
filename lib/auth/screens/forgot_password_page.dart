import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/social_row.dart';
import '../widgets/dialogs.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();

  @override
  void dispose() { email.dispose(); super.dispose(); }

  void _send() async {
    if (!formKey.currentState!.validate()) return;
    await showSuccessDialog(context, 'Reset link sent to ${email.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(key: formKey, child: RoundedTextField(controller: email, hint: 'Enter Email Address', keyboardType: TextInputType.emailAddress, validator: Validators.email)),
                const SizedBox(height: 16),
                SizedBox(height: 56, child: ElevatedButton(onPressed: _send, child: const Text('Send Reset Link'))),
                const SizedBox(height: 24),
                Row(children: const [Expanded(child: Divider()), SizedBox(width: 12), Text('Or continue with'), SizedBox(width: 12), Expanded(child: Divider())]),
                const SizedBox(height: 12),
                const SocialRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
