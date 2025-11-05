import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/password_field.dart';
import 'role_selection_page.dart';
import 'verify_email_page.dart';
import '../widgets/sports_multi_select.dart';

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
  final address2 = TextEditingController();
  final city = TextEditingController();
  final state = TextEditingController();
  final zipCode = TextEditingController();
  final country = TextEditingController();
  final officePhone = TextEditingController();
  final mobilePhone = TextEditingController();
  final companyWebsite = TextEditingController();

  final List<String> _selectedSports = [];
  final List<String> _allSports = const [
    'Cricket',
    'Football',
    'Basketball',
    'Hockey',
    'Tennis',
    'Badminton',
    'Volleyball',
    'Baseball',
    'Rugby',
    'Table Tennis',
  ];

  // OTP UI removed from the form; we show a dedicated Verify Email page after register
  bool _emailVerified = false;

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
      address2,
      city,
      state,
      zipCode,
      country,
      officePhone,
      mobilePhone,
      companyWebsite,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    if (!_emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your email before registering'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

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
              // show a green check when verified
              suffix: _emailVerified
                  ? const Icon(Icons.check_circle, color: Colors.green)
                  : null,
              onChanged: (_) {
                if (_emailVerified) {
                  setState(() {
                    _emailVerified = false; // reset if user edits email
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () async {
                  final err = Validators.email(email.text);
                  if (err != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(err)),
                    );
                    return;
                  }
                  final verified = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => VerifyEmailPage(email: email.text),
                    ),
                  );
                  if (verified == true && mounted) {
                    setState(() {
                      _emailVerified = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email verified'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.mark_email_read_outlined),
                label: Text(_emailVerified ? 'Verified' : 'Verify Email'),
              ),
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
            RoundedTextField(controller: address, hint: 'Address Line 1'),
            const SizedBox(height: 8),
            RoundedTextField(controller: address2, hint: 'Address Line 2'),
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
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: officePhone,
                    hint: 'Office Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(
                    controller: mobilePhone,
                    hint: 'Mobile Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RoundedTextField(
              controller: companyWebsite,
              hint: 'Company Website',
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 12),
            const Text(
              'Sports',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final result = await showDialog<List<String>>(
                  context: context,
                  builder: (ctx) => SportsMultiSelect(
                    allSports: _allSports,
                    initialSelected: _selectedSports,
                  ),
                );
                if (result != null) setState(() => _selectedSports
                  ..clear()
                  ..addAll(result));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedSports.isNotEmpty
                      ? [
                          ..._selectedSports.take(3).map((s) => Chip(label: Text(s))),
                          if (_selectedSports.length > 3)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                '+${_selectedSports.length - 3} more',
                                style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ),
                        ]
                      : [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Select sport', style: TextStyle(color: Colors.grey)),
                          ),
                        ],
                ),
              ),
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
