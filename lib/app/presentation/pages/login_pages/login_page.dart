import 'package:flutter/material.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/presentation/route.dart';
import 'package:fov_fall2024_headchef_tablet_app/app/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthRepository authRepository = AuthRepository();
  bool _rememberMe = false;

  void _login() async {
    String securityCode = _employeeCodeController.text;
    String password = _passwordController.text;
    Map<String, dynamic>? userData =
        await authRepository.login(securityCode, password);
    if (userData['success'] == true) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successfully.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Headchef code',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              TextField(
                controller: _employeeCodeController,
                decoration: InputDecoration(
                  labelText: 'Input your code',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (value) {
                          setState(() {
                            _rememberMe = value!;
                          });
                        },
                      ),
                      Text('Remember Me'),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
