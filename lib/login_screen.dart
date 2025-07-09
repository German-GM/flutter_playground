import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'webview_screen.dart';
import 'file_viewer_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final emailController =
      TextEditingController(text: 'admin@agustindeiturbide.com');
  final passwordController = TextEditingController(text: 'Iturbide2025');
  String? error;

  Future<void> _login(apiURL) async {
    final url = Uri.parse(
        'http://192.168.1.242:4000/api/create_token'); // Ajusta tu ruta de login

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text.trim(),
        'password': passwordController.text.trim(),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'] ?? data['token'];

      if (token != null) {
        // Navegar a WebView con el token
        Navigator.push(
          context,
          MaterialPageRoute(
            // builder: (_) => WebViewScreen(
            //   // apiUrl:
            //   //     "http://192.168.1.242:4000/api/seaweedfs/5,01a9e45a18", // imagen
            //   apiUrl:
            //       "http://192.168.1.242:4000/api/seaweedfs/4,02d1c43ddd", // pdf
            //   bearerToken: token,
            // ),
            builder: (_) => FileViewerScreen(
              // apiUrl:
              //     "http://192.168.1.242:4000/api/seaweedfs/5,01a9e45a18", // imagen
              apiUrl: apiURL, // pdf
              bearerToken: token,
            ),
          ),
        );
      } else {
        setState(() {
          error = "Token no encontrado en la respuesta.";
        });
      }
    } else {
      setState(() {
        error = "Error de login: ${response.statusCode}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _login(
                  "http://192.168.1.242:4000/api/seaweedfs/5,01a9e45a18"),
              child: const Text("Iniciar sesión y traer imagen"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _login(
                  "http://192.168.1.242:4000/api/seaweedfs/4,02d1c43ddd"),
              child: const Text("Iniciar sesión y traer pdf"),
            ),
            if (error != null) ...[
              const SizedBox(height: 10),
              Text(error!, style: const TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}
