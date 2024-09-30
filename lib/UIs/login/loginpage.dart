import 'package:flutter/material.dart';
import 'package:owlearn/UIs/login/registerpage.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';
import 'package:owlearn/handlers/login/splashhandler.dart';

class TextFormLogin extends StatefulWidget {
  @override
  _TextFormLogin createState() => _TextFormLogin();
}

class _TextFormLogin extends State<TextFormLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthHandler _authHandler = FirebaseAuthHandler();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // buat makan, jangan diganggu
  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String? result = await _authHandler.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result == null) {
        // Login perfecto
        _showSnackbar(context, "Login berhasil!");
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashHandler()));
      } else {
        // chuakz
        _showSnackbar(context, result);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Selamat Datang di Aplikasi OwLearn Diskusi!', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 20.0,),
                const Text('Silakan Login atau Daftar Terlebih Dahulu!', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 10,),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong!';
                    }
                    // Regex sederhana untuk validasi format email
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Masukkan format email yang valid!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: _login,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 20.0,),
                const Text('Tidak memiliki akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Registrasi()
                      )
                    );
                  }, child: const Text('Daftar sekarang!')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}