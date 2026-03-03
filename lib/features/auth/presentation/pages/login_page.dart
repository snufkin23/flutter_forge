import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/router/app_router.gr.dart';
import 'package:flutter_forge/features/auth/presentation/cubit/login_cubit.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, bool>(
      listener: (context, loggedIn) {
        if (loggedIn) {
          context.router.replace(const HomeRoute());
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              context.read<LoginCubit>().login();
            },
            child: const Text('Login'),
          ),
        ),
      ),
    );
  }
}
