import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controller/auth_controller.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  bool _isLoading = false;

  Future<void> _onSignupPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final uid = await _authController.register(
        email: email,
        password: password,
      );

      if (!mounted) return; // ✅ Guard against async context issues
      setState(() => _isLoading = false);

      if (uid != null) {
        // Optional: send email verification
        final emailSent = await _authController.sendEmailVerification();

        if (!mounted) return; // ✅ Guard again before using context
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              emailSent
                  ? 'Registration successful! Verification email sent.'
                  : 'Registration successful!',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate safely
        if (mounted) context.go('/dashboard');
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _onSignupPressed,
                        child: const Text(
                          'Create Account',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  if (mounted) context.go('/login');
                },
                child: const Text('Already have an account? Log in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
