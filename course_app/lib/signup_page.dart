import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _error;

  Future<void> _signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Passwörter stimmen nicht überein');
      return;
    }
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final user = response.user;
      if (user != null) {
        await Supabase.instance.client.from('users').upsert({
          'id': user.id,
          'email': _emailController.text,
          'full_name': _fullNameController.text,
          'phone': _phoneController.text,
        });
        setState(() => _error = null);
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } on AuthException catch (e) {
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrieren')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'E-Mail')),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Passwort'), obscureText: true),
              TextField(controller: _confirmPasswordController, decoration: const InputDecoration(labelText: 'Passwort bestätigen'), obscureText: true),
              TextField(controller: _fullNameController, decoration: const InputDecoration(labelText: 'Vollständiger Name')),
              TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Telefonnummer')),
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _signUp, child: const Text('Registrieren')),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('Bereits ein Konto? Anmelden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 