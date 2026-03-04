import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/router/app_router.gr.dart';
import 'package:flutter_forge/features/onboarding/presentation/cubit/onboarding_cubit.dart';

@RoutePage()
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, bool>(
      listener: (BuildContext context, bool completed) {
        if (completed) {
          context.router.replace(const LoginRoute());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Onboarding'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => context.read<OnboardingCubit>().completeOnboarding(),
            child: const Text('Finish Onboarding'),
          ),
        ),
      ),
    );
  }
}
