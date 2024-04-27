import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/src/authentication/presentation/pages/phone_number_page.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_button.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes().width(context, 0.04),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        DefaultButton(
          label: "Signup",
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const PhoneNumberPage(
                    isLogin: false,
                  ),
                ));
          },
        ),
        Space().height(context, 0.05),
        DefaultButton(
          label: "Signin",
          onTap: () {
            context.goNamed("signin");
          },
        )
      ]),
    ));
  }
}
