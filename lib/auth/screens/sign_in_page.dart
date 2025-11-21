import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/validators.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
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
  bool _emailVerified = false;
  final AuthRepository _authRepository = AuthRepository();
  bool _isCheckingEmail = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkEmailVerification() async {
    final emailText = emailCtrl.text.trim();
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

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Check email verification before allowing sign in
    if (!_emailVerified) {
      // First check if email is verified
      await _checkEmailVerification();
      
      if (!_emailVerified && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email before signing in'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 4),
          ),
        );
        return;
      }
    }

    // Use Riverpod auth provider
    await ref.read(authStateProvider.notifier).signIn(
          email: emailCtrl.text.trim(),
          password: passCtrl.text,
        );

    // Check auth state after sign in
    final authState = ref.read(authStateProvider);
    
    if (authState.isAuthenticated && authState.user != null) {
      if (mounted) {
        // Get role from API response
        final userRoleString = authState.user!.role;
        final userRole = userRoleString?.toUserRole() ?? UserRole.member;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome! Signed in as ${userRole.label}'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to role-based dashboard using role from API
        final target = RoleRouter.dashboardFor(userRole);
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
            enabled: !isLoading && !_isCheckingEmail,
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
                if (mounted && emailCtrl.text.trim() == emailValue) {
                  _checkEmailVerification();
                }
              });
            },
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
              TextButton.icon(
                onPressed: (_emailVerified || isLoading)
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
                icon: _emailVerified
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 18,
                      )
                    : const Icon(
                        Icons.email_outlined,
                        size: 18,
                      ),
                label: Text(
                  _emailVerified ? 'Email Verified' : 'Verify Email',
                  style: TextStyle(
                    color: _emailVerified ? Colors.green : null,
                  ),
                ),
              ),
            ],
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
