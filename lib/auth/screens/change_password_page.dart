import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../widgets/password_field.dart';
import '../widgets/dialogs.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});
  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final formKey = GlobalKey<FormState>();
  final oldP = TextEditingController();
  final newP = TextEditingController();
  final confirm = TextEditingController();

  @override
  void dispose() { oldP.dispose(); newP.dispose(); confirm.dispose(); super.dispose(); }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;
    if (newP.text != confirm.text) {
      return showErrorDialog(context, 'Password and Confirm Password Do not Match');
    }
    await showSuccessDialog(context, 'Password changed successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
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
                  PasswordField(controller: oldP, hint: 'Change Password', validator: Validators.password),
                  const SizedBox(height: 12),
                  PasswordField(controller: newP, hint: 'New Password', validator: Validators.password),
                  const SizedBox(height: 12),
                  PasswordField(controller: confirm, hint: 'Confirm New Password', validator: (v)=>Validators.confirmPassword(v, newP.text)),
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
