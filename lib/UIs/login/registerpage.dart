import 'package:flutter/material.dart';
import 'package:owlearn/UIs/login/loginpage.dart';
import 'package:owlearn/handlers/authenticator/firebaseauthhandler.dart';
import 'package:owlearn/handlers/login/splashhandler.dart';

class Registrasi extends StatefulWidget {
  @override
  _Registrasi createState() => _Registrasi();
}

class _Registrasi extends State<Registrasi> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthHandler _authHandler = FirebaseAuthHandler();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      // Comot data langsung masukin ke firebase
      String? result = await _authHandler.signUp(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (result == null) {
        _showSnackbar(context, "Pendaftaran berhasil!");
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashHandler()));
      } else {
        // Yang bener dong ngasih datanya lol
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
            // Yang simpel aja deh
            key: _formKey,
            child: Column(
              children: [
                const Text('Selamat Mendaftar dan Selamat Bergabung di OwLearn Diskusi!', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Username'),
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong!';
                    }
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
                    if (value.length < 6) {
                      return 'Password harus lebih dari 6 karakter!';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: _signUp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue, // Warna tombol
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  )
                ),
                const SizedBox(height: 20.0,),
                const Text('Sudah memiliki akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => TextFormLogin()
                      )
                    );
                  }, child: const Text('Login sekarang!')
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}