import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../../core/services/api_service.dart';
import '../../core/models/api_models.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/password_field.dart';
import '../../role_specific/common/role_router.dart';

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
  
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  // OTP UI removed from the form; we show a dedicated Verify Email page after register

  @override
  void dispose() {
    for (final c in [firstName, lastName, email, pass, confirm, phone, address, city, state, zipCode, country]) {
      c.dispose();
    }
    super.dispose();
  }

  void _register() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final request = SignUpRequest(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        email: email.text.trim(),
        password: pass.text,
        phone: phone.text.trim().isNotEmpty ? phone.text.trim() : null,
        address: address.text.trim().isNotEmpty ? address.text.trim() : null,
        city: city.text.trim().isNotEmpty ? city.text.trim() : null,
        state: state.text.trim().isNotEmpty ? state.text.trim() : null,
        zipCode: zipCode.text.trim().isNotEmpty ? zipCode.text.trim() : null,
        country: country.text.trim().isNotEmpty ? country.text.trim() : null,
      );

      final response = await _apiService.signUp(request);

      if (response.success && response.data != null) {
        // Successfully registered
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome ${response.data!.user.name}! Registration successful!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Get role from API response and navigate to appropriate dashboard
          final userRole = response.data!.user.role;
          final apiRole = _getUserRoleFromString(userRole);
          final target = RoleRouter.dashboardFor(apiRole);
          
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => target),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper method to convert API role string to UserRole enum
  UserRole _getUserRoleFromString(String? roleString) {
    if (roleString == null) return UserRole.member;
    
    switch (roleString.toLowerCase()) {
      case 'club':
        return UserRole.club;
      case 'coach':
        return UserRole.coach;
      case 'corporate':
        return UserRole.corporate;
      case 'merchandiser':
        return UserRole.merchandiser;
      case 'member':
      default:
        return UserRole.member;
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
              controller: address,
              hint: 'Address',
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RoundedTextField(
                    controller: city,
                    hint: 'City',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RoundedTextField(
                    controller: state,
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
            RoundedTextField(
              controller: phone,
              hint: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _register,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.person_add),
                label: Text(_isLoading ? 'Registering...' : 'Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
