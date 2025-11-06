import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/validators.dart';
import '../../core/providers/auth_provider.dart';
import '../widgets/rounded_text_field.dart';
import '../widgets/password_field.dart';
import '../widgets/social_row.dart';
import 'forgot_password_page.dart';
import '../../role_specific/common/role_router.dart';
import 'verify_email_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  UserRole role = UserRole.member;
  bool _emailVerified = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify your email before signing in'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Use Riverpod auth provider
    await ref.read(authStateProvider.notifier).signIn(
          email: emailCtrl.text.trim(),
          password: passCtrl.text,
        );

    // Check auth state after sign in
    final authState = ref.read(authStateProvider);
    
    if (authState.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome! Signed in as ${role.label}'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to role-based dashboard
        final target = RoleRouter.dashboardFor(role);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => target),
        );
      }
    } else if (authState.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.error ?? 'Sign in failed'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final isLoading = authState.isLoading;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RoundedTextField(
            controller: emailCtrl,
            hint: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: (v) => Validators.email(v),
            enabled: !isLoading,
          ),
          const SizedBox(height: 12),
          PasswordField(
            controller: passCtrl,
            hint: 'Password',
            validator: (v) => Validators.password(v),
            enabled: !isLoading,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: isLoading
                    ? null
                    : () => Navigator.pushNamed(context, '/forgot'),
                child: const Text('Forgot Password?'),
              ),
              TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final verified = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerifyEmailPage(
                              email: emailCtrl.text.trim(),
                            ),
                          ),
                        );
                        if (verified == true && mounted) {
                          setState(() => _emailVerified = true);
                        }
                      },
                child: const Text('Verify Email'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<UserRole>(
            value: role,
            decoration: InputDecoration(
              labelText: 'Role',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: UserRole.values.map((r) {
              return DropdownMenuItem(
                value: r,
                child: Text(r.label),
              );
            }).toList(),
            onChanged: isLoading
                ? null
                : (v) {
                    if (v != null) setState(() => role = v);
                  },
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : _onSignIn,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: Text(isLoading ? 'Signing in...' : 'Sign In'),
            ),
          ),
          const SizedBox(height: 16),
          const SocialRow(),
        ],
      ),
    );
  }
}
