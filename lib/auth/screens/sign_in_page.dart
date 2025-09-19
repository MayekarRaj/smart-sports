import 'package:flutter/material.dart';
import '../../core/utils/validators.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/social_row.dart';
import 'forgot_password_page.dart';
import '../../role_specific/common/role_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  UserRole role = UserRole.member;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  void _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    // Mock role-based routing after sign in
    final target = RoleRouter.dashboardFor(role);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => target));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundedTextField(
            controller: emailCtrl,
            hint: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          const SizedBox(height: 12),
          PasswordField(controller: passCtrl, hint: 'Password', validator: Validators.password),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ForgotPasswordPage())),
              child: const Text('Forgot Password?'),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Role: '),
              const SizedBox(width: 12),
              DropdownButton<UserRole>(
                value: role,
                onChanged: (v) => setState(()=> role = v ?? UserRole.member),
                items: UserRole.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))).toList(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _onSignIn,
              icon: const Icon(Icons.login),
              label: const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 24),
          Row(children: const [Expanded(child: Divider()), SizedBox(width: 12), Text('Or continue with'), SizedBox(width: 12), Expanded(child: Divider())]),
          const SizedBox(height: 12),
          const SocialRow(),
        ],
      ),
    );
  }
}
