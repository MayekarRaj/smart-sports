import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/exceptions/api_exception.dart';
import '../widgets/otp_fields.dart';
import '../widgets/dialogs.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final ctrls = List.generate(4, (_) => TextEditingController());
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  bool _isResending = false;
  bool _otpSent = false;

  @override
  void initState() {
    super.initState();
    // Send OTP automatically when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendOtp();
    });
  }

  @override
  void dispose() {
    for (final c in ctrls) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!mounted) return;

    setState(() {
      _isResending = true;
    });

    try {
      final response = await _authRepository.sendOtp(widget.email);
      
      if (mounted) {
        setState(() {
          _otpSent = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send OTP: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _resend() async {
    HapticFeedback.selectionClick();
    await _sendOtp();
  }

  Future<void> _verify() async {
    final code = ctrls.map((c) => c.text).join();
    if (code.length != 4) {
      await showErrorDialog(context, 'Enter 4-digit OTP');
      return;
    }
    
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authRepository.verifyOtp(widget.email, code);
      
      if (mounted) {
        if (response.verified) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
          
          // Navigate back with success
          Navigator.of(context).pop(true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        
        // Clear OTP fields on error
        for (final ctrl in ctrls) {
          ctrl.clear();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'A verification mail has been sent to\n${widget.email}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OtpFields(ctrls: ctrls),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _isResending ? null : _resend,
                  child: _isResending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Resend OTP'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verify,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
