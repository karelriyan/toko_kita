import 'package:flutter/material.dart';
import 'package:tokokita/service/app_store.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                const SizedBox(height: 20),
                _tombolLogin(),
                const SizedBox(height: 10),
                _menuRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================
  // TEXTBOX EMAIL
  // ============================
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Email harus diisi";
        }
        return null;
      },
    );
  }

  // ============================
  // TEXTBOX PASSWORD
  // ============================
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        if (value.length < 6) {
          return "Password harus minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // ============================
  // TOMBOL LOGIN
  // ============================
  Widget _tombolLogin() {
    return ElevatedButton(
      child: _isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Login'),
      onPressed: _isLoading ? null : _handleLogin,
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AppStore.instance
          .login(_emailTextboxController.text, _passwordTextboxController.text);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProdukPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ============================
  // MENU KE REGISTRASI
  // ============================
  Widget _menuRegistrasi() {
    return Container(
      child: GestureDetector(
        child: const Text(
          "Belum punya akun? Register",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
