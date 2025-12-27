import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthController _authController = AuthController();

  bool _isLoading = false;
  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final success = await _authController.login(
        email: email,
        password: password,
      );

      if (!mounted) return; // ✅ Guard here
      setState(() => _isLoading = false);

      // Store local context reference for SnackBar/navigation
      final localContext = context;

      if (success) {
        await _authController.currentUser?.reload();
        final user = _authController.currentUser;

        if (user != null && !user.emailVerified) {
          ScaffoldMessenger.of(localContext).showSnackBar(
            const SnackBar(
              content: Text('Please verify your email before logging in.'),
              backgroundColor: Colors.orange,
            ),
          );
          context.go('/verify-email');
          return;
        }

        // Verified → navigate to dashboard
        context.go('/dashboard');
      } else {
        ScaffoldMessenger.of(localContext).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
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
      appBar: AppBar(title: const Text('Login')),
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
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
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
                        onPressed: _onLoginPressed,
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  if (mounted) context.go('/signup');
                },
                child: const Text('Don\'t have an account? Sign up'),
              ),
              TextButton(
                onPressed: () {
                  if (mounted) context.go('/forgot-password');
                },
                child: const Text('Forgot password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
