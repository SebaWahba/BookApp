import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bookapp/features/auth/presentation/providers/email_verification_notifier.dart';

class EmailVerificationView extends ConsumerStatefulWidget {
  final String email; // دي بتستقبل سواء إيميل أو رقم تليفون
  final VoidCallback? onVerified;

  const EmailVerificationView({
    super.key,
    required this.email,
    this.onVerified,
  });

  @override
  ConsumerState<EmailVerificationView> createState() => _EmailVerificationViewState();
}

class _EmailVerificationViewState extends ConsumerState<EmailVerificationView> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.email.isNotEmpty) {
        ref.read(emailVerificationProvider.notifier).resendCode(widget.email);
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get _enteredCode {
    return _controllers.map((c) => c.text).join();
  }

  void _verify() {
    final code = _enteredCode;
    if (code.length == 4) {
      ref.read(emailVerificationProvider.notifier).verifyCode(widget.email, code);
    }
  }

  void _showDemoCodeBottomSheet(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.mark_email_unread_rounded, size: 48, color: Color(0xFF6C4DDA)),
              const SizedBox(height: 12),
              const Text(
                'Random Verification Code',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Here is your randomly generated verification code to proceed:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C4DDA).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  code,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6,
                    color: Color(0xFF6C4DDA),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4DDA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Got it',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<EmailVerificationState>(emailVerificationProvider, (previous, next) {
      if (next.status == EmailVerificationStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'An error occurred'), backgroundColor: Colors.red),
        );
      } else if (next.status == EmailVerificationStatus.success) {
        if (previous?.status != EmailVerificationStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Verified successfully!'), backgroundColor: Colors.green),
          );
          
          if (widget.onVerified != null && context.mounted) {
            widget.onVerified!();
          }
        }
      } 
      else if (next.status == EmailVerificationStatus.resendSuccess && previous?.status != EmailVerificationStatus.resendSuccess) {
        _showDemoCodeBottomSheet(next.code ?? "1234");
      }
    });

    final state = ref.watch(emailVerificationProvider);
    final isEmail = widget.email.contains('@');
    // لو الإيميل فارغ لأي سبب، نعرض نص بديل تفاديًا لأي قيم وهمية
    final displayContact = widget.email.isNotEmpty ? widget.email : 'your account';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                isEmail ? 'Verification Email' : 'Phone Verification',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                isEmail
                    ? 'Please enter the code we just sent to email\n$displayContact'
                    : 'Please enter the code we just sent to phone\n$displayContact',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _focusNodes[index].hasFocus ? const Color(0xFF6C4DDA) : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {});
                        if (value.isNotEmpty && index < 3) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (_enteredCode.length == 4) {
                          _verify();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("If you didn't receive a code? ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                    onTap: state.status == EmailVerificationStatus.loading
                        ? null
                        : () {
                            if (widget.email.isNotEmpty) {
                              ref.read(emailVerificationProvider.notifier).resendCode(widget.email);
                            }
                          },
                    child: const Text(
                      'Resend',
                      style: TextStyle(
                        color: Color(0xFF6C4DDA),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C4DDA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: state.status == EmailVerificationStatus.loading ? null : _verify,
                  child: state.status == EmailVerificationStatus.loading
                      ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                      : const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}