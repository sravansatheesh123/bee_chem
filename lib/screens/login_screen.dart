import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/common_text_field.dart';
import 'personnel_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final rememberMe = ValueNotifier<bool>(false);
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    auth.loadRememberedEmail(emailCtrl, rememberMe);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    rememberMe.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();

    final success = await auth.login(
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
      rememberMe: rememberMe.value,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PersonnelListScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              SizedBox(
                height: 260,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/Frame 18338.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/Vector.png',
                          height: 70,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'BEE CHEM',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            letterSpacing: 1,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Login to your account',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 25),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CommonTextField(
                      label: '',
                      hint: 'Email address',
                      controller: emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!regex.hasMatch(v)) return 'Invalid email';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    CommonTextField(
                      label: '',
                      hint: 'Password',
                      controller: passwordCtrl,
                      obscure: !showPassword,
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() => showPassword = !showPassword);
                        },
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password required';
                        if (v.length < 6) return 'Min 6 characters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: rememberMe,
                          builder: (_, val, __) => Checkbox(
                            value: val,
                            onChanged: (v) {
                              rememberMe.value = v ?? false;
                            },
                          ),
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                        const Text(
                          'FORGOT PASSWORD?',
                          style: TextStyle(
                            color: Color(0xffFFC928),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffFFC928),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: auth.isLoading ? null : _submit,
                        child: auth.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Divider(),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Don’t have an account? "),
                        Text(
                          "REGISTER",
                          style: TextStyle(
                            color: Color(0xffFFC928),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
