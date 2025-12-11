import 'package:flutter/material.dart';
import '/services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtl = TextEditingController();
  final _nameCtl = TextEditingController();
  final _passCtl = TextEditingController();
  String _role = 'buyer'; // default

  final AuthService _authService = AuthService();
  bool _loading = false;
  String? _error;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final user = await _authService.registerWithEmail(
        email: _emailCtl.text.trim(),
        password: _passCtl.text,
        displayName: _nameCtl.text.trim(),
        role: _role,
      );

      if (user != null) {
        // After registration you might navigate user to verification screen
        // or directly to role-specific home:
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home'); // handle role routing in home
      }
    } on Exception catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _emailCtl.dispose();
    _nameCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtl,
                decoration: const InputDecoration(labelText: 'Full name'),
                validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _emailCtl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
              ),
              TextFormField(
                controller: _passCtl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => (v != null && v.length >= 6) ? null : 'Min 6 chars',
              ),
              const SizedBox(height: 12),
              // Role toggle
              Row(
                children: [
                  const Text('Register as: '),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Buyer'),
                    selected: _role == 'buyer',
                    onSelected: (_) => setState(() => _role = 'buyer'),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Seller'),
                    selected: _role == 'seller',
                    onSelected: (_) => setState(() => _role = 'seller'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: _loading ? null : _register,
                child: _loading ? const CircularProgressIndicator() : const Text('Create account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
