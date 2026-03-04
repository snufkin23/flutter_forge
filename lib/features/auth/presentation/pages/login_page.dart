import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_forge/core/extensions/context_ui_extension.dart';
import 'package:flutter_forge/core/router/app_router.gr.dart';
import 'package:flutter_forge/core/widgets/widgets.dart';
import 'package:flutter_forge/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, bool>(
      listener: (BuildContext context, bool loggedIn) {
        if (loggedIn) {
          context.router.replace(const HomeRoute());
        }
      },
      child: CustomScaffold(
        showAppBar: true,
        usePadding: true,
        body: Column(
          children: <Widget>[
            CustomButton(
              onPressed: () {
                context.read<LoginCubit>().login();
              },
              label: 'Login',
            ),
            12.verticalSpace,
            CustomOutlinedButton(
              onPressed: () {
                context.showConfirmBottomSheet(
                  title: 'Confirm Bottom Sheet',
                  message: 'Are you sure to confirm Bottom Sheet',
                );
              },
              label: 'Test',
            ),
            12.verticalSpace,
            CustomTextFormField.email(
              hintText: 'Hecker',
              label: 'Hecker Man',
            ),
          ],
        ),
      ),
    );
  }
}
