import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/password_field.dart';
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
  final phone = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final zipCode = TextEditingController();
  final country = TextEditingController();

  // OTP UI removed from the form; we show a dedicated Verify Email page after register

  @override
  void dispose() {
    for (final c in [
      firstName,
      lastName,
      email,
      pass,
      confirm,
      phone,
      address,
      city,
      state,
      zipCode,
      country,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;

    // Navigate directly to role selection page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
    );
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
            RoundedTextField(controller: address, hint: 'Address'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(controller: city, hint: 'City'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(controller: state, hint: 'State'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: zipCode,
                    hint: 'Zip Code',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(controller: country, hint: 'Country'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Contact Details',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RoundedTextField(
              controller: phone,
              hint: 'Phone Number',
              keyboardType: TextInputType.phone,
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
