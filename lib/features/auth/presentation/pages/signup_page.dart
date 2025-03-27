import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blog_app/core/common/widgets/loader.dart';
import 'package:flutter_blog_app/core/theme/app_palette.dart';
import 'package:flutter_blog_app/core/utils/show_snackbar.dart';
import 'package:flutter_blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_blog_app/features/blog/presentation/pages/blog_page.dart';

import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const SignUpPage());

  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
          if (state is AuthFailure) {
            return showSnackbar(context, state.message);
          }
          else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                (route) => false,
              );
            }
        }, builder: (context, state) {
          if (state is AuthLoading) {
            return const Loader();
          }
          return Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AuthField(
                      hinText: "Name",
                      textEditingController: nameController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      hinText: "Email",
                      textEditingController: emailController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      hinText: "Password",
                      isObsecureText: true,
                      textEditingController: passwordController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthGradientButton(
                      buttonText: "Sign Up",
                      ontap: () {
                        if (formKey.currentState!.validate()) {
                          log("sent successfully");
                          context.read<AuthBloc>().add(
                                AuthSignUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    name: nameController.text.trim()),
                              );
                        } else {}
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, LoginPage.route());
                      },
                      child: RichText(
                        text: TextSpan(
                            text: "Already  have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: "Sign In",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppPallete.gradient2,
                                      fontWeight: FontWeight.bold,
                                    ),
                              )
                            ]),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
