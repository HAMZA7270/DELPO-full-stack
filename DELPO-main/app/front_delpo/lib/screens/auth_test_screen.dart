import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  String _message = '';
  bool _isLogin = true; // Toggle between login and register

  @override
  void initState() {
    super.initState();
    // Set default values for testing
    _emailController.text = 'test@example.com';
    _passwordController.text = 'password123';
    _nameController.text = 'Test User';
  }

  Future<void> _authenticate() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      Map<String, dynamic> response;
      
      if (_isLogin) {
        response = await AuthService.login(
          _emailController.text,
          _passwordController.text,
        );
        setState(() {
          _message = 'Login successful! Token: ${AuthService.authToken?.substring(0, 20)}...';
        });
      } else {
        response = await AuthService.register(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          passwordConfirmation: _passwordController.text,
        );
        setState(() {
          _message = 'Registration successful! Token: ${AuthService.authToken?.substring(0, 20)}...';
        });
      }
      
      print('Auth response: $response');
      
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login Test' : 'Register Test'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Toggle between login and register
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isLogin = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLogin ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('Login', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isLogin = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isLogin ? Colors.orange : Colors.grey,
                    ),
                    child: const Text('Register', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Show name field only for registration
            if (!_isLogin) ...[
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _authenticate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isLogin ? 'LOGIN' : 'REGISTER',
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
            
            const SizedBox(height: 20),
            
            // Auth status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auth Status: ${AuthService.isAuthenticated() ? 'Authenticated' : 'Not Authenticated'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (AuthService.authToken != null)
                    Text('Token: ${AuthService.authToken!.substring(0, 50)}...'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Message area
            if (_message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _message.contains('Error') ? Colors.red[100] : Colors.green[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('Error') ? Colors.red[800] : Colors.green[800],
                  ),
                ),
              ),
              
            const Spacer(),
            
            // Logout button
            if (AuthService.isAuthenticated())
              ElevatedButton(
                onPressed: () {
                  AuthService.logout();
                  setState(() {
                    _message = 'Logged out successfully';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('LOGOUT', style: TextStyle(color: Colors.white)),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
