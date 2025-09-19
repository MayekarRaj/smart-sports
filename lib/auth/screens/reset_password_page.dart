import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../widgets/password_field.dart';
import '../widgets/dialogs.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final pass = TextEditingController();
  final confirm = TextEditingController();

  @override
  void dispose() { pass.dispose(); confirm.dispose(); super.dispose(); }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;
    await showSuccessDialog(context, 'Password changed successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PasswordField(controller: pass, hint: 'Enter New Password', validator: Validators.password),
                  const SizedBox(height: 12),
                  PasswordField(controller: confirm, hint: 'Confirm New Password', validator: (v)=>Validators.confirmPassword(v, pass.text)),
                  const SizedBox(height: 20),
                  SizedBox(height: 56, child: ElevatedButton(onPressed: _submit, child: const Text('Submit'))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
