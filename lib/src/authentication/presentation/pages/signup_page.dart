// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/core/strings/app_strings.dart';
import 'package:house_rental_admin/core/widgets/bottom_sheet.dart';
import 'package:house_rental_admin/locator.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental_admin/src/authentication/presentation/pages/document_page.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:string_validator/string_validator.dart';

class SignupPage extends StatefulWidget {
  final String phoneNumber, uid;
  const SignupPage({
    Key? key,
    required this.phoneNumber,
    required this.uid,
  }) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final authBloc = locator<AuthenticationBloc>();
  final formKey = GlobalKey<FormBuilderState>();
  final auth = FirebaseAuth.instance;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Signup"),
        ),
        bottomSheet: bottomSheetButton(
          context: context,
          label: "Signup",
          onPressed: () {
            if(formKey.currentState!.saveAndValidate()==true){

            var bites = utf8.encode(passwordController.text);
            var password = sha512.convert(bites);
            final owner = Owner(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              email: emailController.text,
              phoneNumber: widget.phoneNumber,
              id: "",
              password: password.toString(),
              uid: widget.uid,
              profileURL: "",
              houseDocument: "",
              houseGPSAddress: "",
              townORCity: "",
              role:"",


            );

         Navigator.push(context,MaterialPageRoute(
      builder: (BuildContext context) =>  DocumentSubmissionPage(
              owner: owner,
            )));
           
            }
          },
          
        ),
        body:  FormBuilder(
          key: formKey,
          child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Sizes().height(context, 0.02)),
                    child: Column(
                      children: [
                        //firstName
                        FormBuilderField<String>(
                            name: "First Name",
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return fieldRequired;
                              }
                              if (value!.length <= 1) {
                                return mustBeCharacters;
                              }
                              return null;
                            },
                            builder: (context) {
                              return DefaultTextfield(
                                controller: firstNameController,
                                label: "First Name",
                                hintText: "Enter your first name",
                                errorText: context.errorText,
                                onChanged: (p0) => context.didChange(p0),
                              );
                            }),
          
                        //last Name
                        FormBuilderField<String>(
                            name: "Last Name",
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return fieldRequired;
                              }
                              if (value!.length <= 1) {
                                return mustBeCharacters;
                              }
                              return null;
                            },
                            builder: (context) {
                              return DefaultTextfield(
                                controller: lastNameController,
                                label: "Last Name",
                                hintText: "Enter your last name",
                                errorText: context.errorText,
                                onChanged: (p0) => context.didChange(p0),
                              );
                            }),
          
                        //email
                        FormBuilderField<String>(
                            name: "Email",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return fieldRequired;
                              }
                              if (!isEmail(value!)) {
                                return "Must be an email";
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            builder: (context) {
                              return DefaultTextfield(
                                controller: emailController,
                                label: "Email",
                                hintText: "Enter your email",
                                errorText: context.errorText,
                                onChanged: (p0) => context.didChange(p0),
                              );
                            }),
          
                        //email
                        FormBuilderField<String>(
                            name: "password",
                            validator: (value) {
                              if (value?.isEmpty ?? true) {
                                return fieldRequired;
                              }
          
                              if (!isLength(value!, 8)) {
                                return 'must be at least 8 characters';
                              }
          
                              return null;
                            },
                            builder: (context) {
                              return DefaultTextfield(
                                controller: passwordController,
                                label: "Password",
                                hintText: "Enter your password",
                                errorText: context.errorText,
                                onChanged: (p0) => context.didChange(p0),
                              );
                            }),
          
                        Space().height(context, 0.02),
                      ],
                    ),
                  ),
              ),
        ));
           
  }
}
