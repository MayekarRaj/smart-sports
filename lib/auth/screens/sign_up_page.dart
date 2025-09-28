import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/password_field.dart';
import 'verify_email_page.dart';
import 'role_selection_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final pass = TextEditingController();
  final confirm = TextEditingController();
  // OTP UI removed from the form; we show a dedicated Verify Email page after register

  @override
  void dispose() {
    for (final c in [firstName, lastName, email, pass, confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    // After clicking Sign Up, go to Email Verification page
    final verified = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => VerifyEmailPage(email: email.text)),
    );
    if (verified == true && mounted) {
      // Navigate to role selection after email verification
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const RoleSelectionPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: firstName,
                    hint: 'First Name',
                    validator: (v) =>
                        Validators.required(v, field: 'First name'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(
                    controller: lastName,
                    hint: 'Last Name',
                    validator: (v) =>
                        Validators.required(v, field: 'Last name'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            RoundedTextField(
              controller: email,
              hint: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: PasswordField(
                    controller: pass,
                    hint: 'Password',
                    validator: Validators.password,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PasswordField(
                    controller: confirm,
                    hint: 'Confirm Password',
                    validator: (v) => Validators.confirmPassword(v, pass.text),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Address/Contact simplified placeholders for now
            const Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RoundedTextField(
              controller: TextEditingController(),
              hint: 'Address 1',
            ),
            const SizedBox(height: 8),
            RoundedTextField(
              controller: TextEditingController(),
              hint: 'Address 2',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: TextEditingController(),
                    hint: 'City',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(
                    controller: TextEditingController(),
                    hint: 'State',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: TextEditingController(),
                    hint: 'Zip Code',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(
                    controller: TextEditingController(),
                    hint: 'Country',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Contact Details',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: TextEditingController(),
                    hint: 'Office Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(
                    controller: TextEditingController(),
                    hint: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RoundedTextField(
              controller: TextEditingController(),
              hint: 'Company Website',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _register,
                icon: const Icon(Icons.person_add),
                label: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
