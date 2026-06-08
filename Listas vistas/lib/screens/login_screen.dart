import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? errorEmail;
  String? errorPassword;

  bool obscurePassword = true;

  final AuthService _auth = AuthService();

  void validar() {
    setState(() {
      errorEmail = null;
      errorPassword = null;

      String email = emailController.text.trim();
      String password = passwordController.text;

      if (!email.contains("@")) {
        errorEmail = "El email debe contener @";
      }

      if (password.length < 8) {
        errorPassword = "Mínimo 8 caracteres";
      } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
        errorPassword = "Falta mayúscula";
      } else if (!RegExp(r'[a-z]').hasMatch(password)) {
        errorPassword = "Falta minúscula";
      } else if (!RegExp(r'[0-9]').hasMatch(password)) {
        errorPassword = "Falta número";
      } else if (!RegExp(r'[!@#\$%\^&\*(),.?":{}|<>]').hasMatch(password)) {
        errorPassword = "Falta símbolo";
      }

      if (errorEmail == null && errorPassword == null) {
        final ok = _auth.validate(email, password);
        if (ok) {
          context.go('/home', extra: email);
        } else {
          errorPassword = 'Usuario o contraseña incorrectos';
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // EMAIL
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: errorEmail,
                ),
              ),

              const SizedBox(height: 15),

              // PASSWORD
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: errorPassword,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: validar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Ingresar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
