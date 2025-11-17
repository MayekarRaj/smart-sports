import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/validators.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/models/api_models.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/repositories/auth_repository.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/city_search_field.dart';
import '../widgets/phone_code_dropdown.dart';
import 'role_selection_page.dart';
import 'verify_email_page.dart';
import '../widgets/sports_multi_select.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
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
  String? _officePhoneCode;
  String? _mobilePhoneCode;

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
  final AuthRepository _authRepository = AuthRepository();
  bool _isCheckingEmail = false;

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

  Future<void> _checkEmailVerification() async {
    final emailText = email.text.trim();
    if (emailText.isEmpty || Validators.email(emailText) != null) {
      return;
    }

    if (!mounted) return;

    setState(() {
      _isCheckingEmail = true;
    });

    try {
      final response = await _authRepository.checkEmailVerification(emailText);
      if (mounted) {
        setState(() {
          _emailVerified = response.verified;
        });
      }
    } on ApiException catch (e) {
      // Email not found or not verified - that's okay, user needs to verify
      if (mounted) {
        setState(() {
          _emailVerified = false;
        });
      }
    } catch (e) {
      // Error checking - assume not verified
      if (mounted) {
        setState(() {
          _emailVerified = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingEmail = false;
        });
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Check email verification before allowing sign up
    if (!_emailVerified) {
      // First check if email is verified
      await _checkEmailVerification();
      
      if (!_emailVerified && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email before signing up'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        return;
      }
    }
    
    // Validate sports selection
    if (_selectedSports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one sport'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Create sign-up request
    final request = SignUpRequest(
      firstName: firstName.text.trim(),
      lastName: lastName.text.trim(),
      email: email.text.trim(),
      password: pass.text,
      sportsNames: _selectedSports,
      zipCode: zipCode.text.trim().isNotEmpty ? zipCode.text.trim() : null,
      city: city.text.trim().isNotEmpty ? city.text.trim() : null,
      state: state.text.trim().isNotEmpty ? state.text.trim() : null,
      country: country.text.trim().isNotEmpty ? country.text.trim() : null,
      addressLine1: address.text.trim().isNotEmpty ? address.text.trim() : null,
      addressLine2: address2.text.trim().isNotEmpty ? address2.text.trim() : null,
      officePhoneExt: _officePhoneCode,
      officePhone: officePhone.text.trim().isNotEmpty ? officePhone.text.trim() : null,
      mobilePhoneExt: _mobilePhoneCode,
      mobilePhone: mobilePhone.text.trim().isNotEmpty ? mobilePhone.text.trim() : null,
      companyWebsite: companyWebsite.text.trim().isNotEmpty ? companyWebsite.text.trim() : null,
    );

    // Use Riverpod auth provider
    // The state change will be handled by ref.listen in the build method
    await ref.read(authStateProvider.notifier).signUp(request);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;
    
    // Listen to auth state changes in build method (for navigation)
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.isAuthenticated && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to role selection page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
        );
      } else if (next.hasError && mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error ?? 'Registration failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    });
    
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
              enabled: !_isCheckingEmail,
              // show a green check when verified, loading indicator when checking
              suffix: _isCheckingEmail
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : _emailVerified
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
              onChanged: (value) {
                if (_emailVerified) {
                  setState(() {
                    _emailVerified = false; // reset if user edits email
                  });
                }
                // Check email verification when email changes (debounced)
                final emailValue = value.trim();
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (mounted && email.text.trim() == emailValue) {
                    _checkEmailVerification();
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _emailVerified
                    ? null
                    : () async {
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
                icon: _emailVerified
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      )
                    : const Icon(
                        Icons.mark_email_read_outlined,
                        size: 18,
                      ),
                label: Text(
                  _emailVerified ? 'Email Verified' : 'Verify Email',
                  style: TextStyle(
                    color: _emailVerified ? Colors.green : null,
                  ),
                ),
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
                  child: CitySearchField(
                    cityController: city,
                    stateController: state,
                    countryController: country,
                    label: 'City',
                    hint: 'Enter city name',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(
                    controller: state,
                    hint: 'State',
                    enabled: true,
                    readOnly: true, // Read-only, auto-filled from city
                  ),
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
                  child: RoundedTextField(
                    controller: country,
                    hint: 'Country',
                    enabled: true,
                    readOnly: true, // Read-only, auto-filled from city
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
                SizedBox(
                  width: 120,
                  child: PhoneCodeDropdown(
                    value: _officePhoneCode,
                    onChanged: (value) {
                      setState(() {
                        _officePhoneCode = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RoundedTextField(
                    controller: officePhone,
                    hint: 'Office Number',
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 120,
                  child: PhoneCodeDropdown(
                    value: _mobilePhoneCode,
                    onChanged: (value) {
                      setState(() {
                        _mobilePhoneCode = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
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
                onPressed: isLoading ? null : _register,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.person_add),
                label: Text(isLoading ? 'Registering...' : 'Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
