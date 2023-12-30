import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smile/presentation/screens/authentication/controllers/authcontroller.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  AuthController authController = Get.put(AuthController());


  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AuthController>(
        init: authController,

        builder: (AuthController controller) {
          return Container(
            decoration: const BoxDecoration(
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(right: 100),
                        height: 200,
                        child: ClipRRect(
                          child: Image.asset(
                            'assets/login.gif', fit: BoxFit.cover,),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        'Welcome to Smile Couriers',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller:controller.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(color: Colors.red),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                              ),
                              cursorColor: Colors.red,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Field Mandatory";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              controller:controller.passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(color: Colors.red),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: _toggleObscurePassword,
                                  color: Colors.red,
                                ),
                              ),
                              cursorColor: Colors.red,
                              obscureText: _obscurePassword,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Field Mandatory";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: controller.loading.value ? const Center(child: CircularProgressIndicator(),) :ElevatedButton(
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              controller.loginUser();
                            }


                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 5,
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}