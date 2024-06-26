// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:house_rental_admin/assets/svgs/svg_constants.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/core/strings/app_strings.dart';
import 'package:house_rental_admin/core/widgets/bottom_sheet.dart';
import 'package:house_rental_admin/core/widgets/show_toast.dart';
import 'package:house_rental_admin/locator.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental_admin/src/authentication/presentation/pages/otp_page.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_textfield.dart';
import 'package:string_validator/string_validator.dart';

class PhoneNumberPage extends StatefulWidget {
  final bool isLogin;
  final String? id, uid, oldNumberString;
  const PhoneNumberPage(
      {super.key,
      required this.isLogin,
      this.id,
      this.uid,
      this.oldNumberString});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final authBloc = locator<AuthenticationBloc>();
  final formKey = GlobalKey<FormBuilderState>();
  final phoneNumberController = TextEditingController();
  bool? isLogin;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Verify Number"),
        ),
        bottomSheet: BlocConsumer(
          bloc: authBloc,
          listener: (context, state) async {
            //TODO: come check
            if (state is GetUserLoaded) {
              print("Got yoo");
              isLogin = true;
              setState(() {});
              authBloc.add(PhoneNumberLoginEvent(
                phoneNumber: "+233${phoneNumberController.text}",
              ));
            }
            if (state is GetUserError) {
              isLogin = false;
              setState(() {});
              authBloc.add(
                PhoneNumberEvent(
                    phoneNumber: "+233${phoneNumberController.text}"),
              );
            }
            if (state is CodeSent) {
              if (isLogin == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return OTPPage(
                      otpRequest: OTPRequest(
                          isLogin: true,
                          phoneNumber: "+233${phoneNumberController.text}",
                          forceResendingToken: state.token,
                          verifyId: state.verifyId,
                          uid: widget.uid,
                          id: widget.id,
                          oldNumberString: widget.oldNumberString),
                    );
                  }),
                );
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return OTPPage(
                    otpRequest: OTPRequest(
                        isLogin: widget.isLogin,
                        phoneNumber: "+233${phoneNumberController.text}",
                        forceResendingToken: state.token,
                        verifyId: state.verifyId,
                        uid: widget.uid,
                        id: widget.id,
                        oldNumberString: widget.oldNumberString),
                  );
                }),
              );
            }
            if (state is CodeCompleted) {
              // print("verification completed ${authCredential.smsCode}");
              // print(" ${authCredential.verificationId}");
              User? user = FirebaseAuth.instance.currentUser;

              if (state.authCredential.smsCode != null) {
                try {
                  UserCredential credential =
                      await user!.linkWithCredential(state.authCredential);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'provider-already-linked') {
                    final credential = await FirebaseAuth.instance
                        .signInWithCredential(state.authCredential);
                  }
                }
              }
            }

            if (state is GenericError) {
              if (!context.mounted) return;
              showToastInfo(
                context: context,
                label: state.errorMessage,
                isFailed: true,
              );
            }
            if (state is CheckPhoneNumberChangeError) {
              authBloc.add(
                PhoneNumberEvent(
                    phoneNumber: "+233${phoneNumberController.text}"),
              );
            }
            if (state is CheckPhoneNumberLoaded) {
              if (state.isNumberChecked == true) {
                authBloc.add(
                  PhoneNumberEvent(
                      phoneNumber: "+233${phoneNumberController.text}"),
                );
              } else {
                if (!context.mounted) return;
                showToastInfo(
                  context: context,
                  label: "Entered number not equal to old number",
                  isFailed: true,
                );
              }
            }
            if (state is CheckPhoneNumberChangeError) {
              if (!context.mounted) return;
              showToastInfo(
                context: context,
                label: state.errorMessage,
                isFailed: true,
              );
            }
          },
          builder: (context, state) {
            if (state is GetUserLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is VerifyPhoneNumberLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CheckPhoneNumberChangeLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return bottomSheetButton(
                context: context,
                label: "Validate",
                onPressed: () {
                  if (formKey.currentState?.saveAndValidate() == true) {
                    if (widget.oldNumberString != null) {
                      Map<String, dynamic> params = {
                        "start_number": widget.oldNumberString,
                        "phone_number": "+233${phoneNumberController.text}"
                      };
                      authBloc.add(
                        CheckPhoneNumberEvent(params: params),
                      );
                    } else {
                      authBloc.add(GetUserEvent(params: {
                        "phone_number": "+233${phoneNumberController.text}"
                      }));
                    }
                  }
                });
          },
        ),
        body: FormBuilder(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Space().height(context, 0.030),
              const Text(
                "Enter your number to get a verification message",
                textAlign: TextAlign.start,
              ),
              Space().height(context, 0.090),
              FormBuilderField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  name: "phoneNumber",
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return fieldRequired;
                    }
                    if (!isNumeric(value!)) {
                      return "Only numbers required";
                    }
                    if (!isLength(value, 9, 9)) {
                      return 'Nine numbers required';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    if (value!.startsWith("0", 0)) {
                      phoneNumberController.text = value.substring(1);
                    }
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.oldNumberString != null
                            ? "Enter Old Phone Number"
                            : "Enter Phone Number"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                height: 35,
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(10),
                                //   border: Border.all(
                                //    // color: Colors.black
                                //   )
                                // ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      ghanaSVG,
                                      width: 30,
                                    ),
                                    Space().width(context, 0.005),
                                    const Text("+233"),
                                  ],
                                )),
                            SizedBox(
                              width: 270,
                              child: DefaultTextfield(
                                textInputType: TextInputType.number,
                                controller: phoneNumberController,
                                label: "",
                                errorText: field.errorText,
                                onChanged: (p0) => field.didChange(p0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
              Space().height(context, 0.030),
            ]),
          ),
        ));
  }
}
