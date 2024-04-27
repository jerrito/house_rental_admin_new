// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:house_rental_admin/assets/images/image_constants.dart';
import 'package:house_rental_admin/assets/svgs/svg_constants.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/core/strings/app_strings.dart';
import 'package:house_rental_admin/core/theme/colors.dart';
import 'package:house_rental_admin/core/widgets/bottom_sheet.dart';
import 'package:house_rental_admin/core/widgets/show_toast.dart';
import 'package:house_rental_admin/locator.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/build_house_document_change.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/build_profile_change.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:house_rental_admin/src/home/presentation/bloc/home_bloc.dart';
import 'package:house_rental_admin/src/home/presentation/pages/home_page.dart';

class DocumentSubmissionPage extends StatefulWidget {
  final Owner owner;
  const DocumentSubmissionPage({
    Key? key,
    required this.owner,
  }) : super(key: key);

  @override
  State<DocumentSubmissionPage> createState() => _DocumentSubmissionPageState();
}

class _DocumentSubmissionPageState extends State<DocumentSubmissionPage> {
  final authBloc = locator<AuthenticationBloc>();
  final homeBloc = locator<HomeBloc>();
  final formKey = GlobalKey<FormBuilderState>();
  final auth = FirebaseAuth.instance;
  String? profileURL;
  String? houseDocumentURL;
  final houseGPSAddressController = TextEditingController();
  final townOrCityController = TextEditingController();
  final roleController = TextEditingController();
  final houseDocumentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Submission"),
      ),
      bottomSheet: BlocConsumer(
        bloc: authBloc,
        listener: (context, state) {
          if (state is GenericError) {
            showToastInfo(
                  context: context,
                  label:state.errorMessage,
                  isFailed: true,
                );

          }

          if (state is SignupLoaded) {
            showToastInfo(
                  context: context,
                  label:"Successfully created account",
                  isFailed: true,
                );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return HomePage(
                  uid: widget.owner.uid,
                  isLogin: false,
                  phoneNumber: widget.owner.phoneNumber,
                );
              }),
            );
            //  GoRouter.of(context).pushReplacementNamed("homePage");
          }

          if (state is UpLoadImageError) {
            showToastInfo(
                  context: context,
                  label:state.errorMessage,
                  isFailed: true,
                );

          }

          if (state is UpLoadImageLoaded) {
            final users = {
              "house_GPS_address": houseGPSAddressController.text,
              "town_or_city": townOrCityController.text,
              "role": roleController.text,
              "phone_number": widget.owner.phoneNumber,
              "uid": widget.owner.uid,
              "first_name": widget.owner.firstName,
              "last_name": widget.owner.lastName,
              "email": widget.owner.email,
              "password": widget.owner.password,
              "profile_URL": state.imageURL,
              "house_document": houseDocumentURL,
            };

            authBloc.add(
              SignupEvent(users: users),
            );
          }
        },
        builder: (context, state) {
          if (state is SignupLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UpLoadImageLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return bottomSheetButton(
            context: context,
            label: "Validate",
            onPressed: () {
              if (formKey.currentState?.saveAndValidate() == true) {
                Map<String, dynamic> params = {
                  "phone_number": widget.owner.phoneNumber,
                  "path": profileURL,
                };
                authBloc.add(UpLoadImageEvent(params: params));
              }
            },
          );
        },
      ),
      body: FormBuilder(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Sizes().height(context, 0.02)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderField<String>(
                    name: "profileURL",
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return fieldRequired;
                      }

                      return null;
                    },
                    builder: (field) {
                      return InputDecorator(
                        decoration: InputDecoration(errorText: field.errorText),
                        child: BlocConsumer(
                            bloc: homeBloc,
                            listener: (context, state) {
                              if (state is GetProfileError) {
                                debugPrint(state.errorMessage);
                              }
                              if (state is GetProfileLoaded) {
                                debugPrint(state.file.path);
                                profileURL = state.file.path;
                                setState(() {});
                                field.didChange(profileURL);
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Add Profile Picture"),
                                  Space().height(context, 0.01),
                                  SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundColor: searchTextColor3,
                                            backgroundImage: profileURL != null
                                                ? Image.file(File(profileURL!))
                                                    .image
                                                : Image.asset(user1Image,
                                                        width: 100, height: 100)
                                                    .image,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: GestureDetector(
                                              onTap: () {
                                                buildProfileChangeBottomSheet(
                                                  context,
                                                  homeBloc,
                                                  authBloc,
                                                );
                                              },
                                              child: SvgPicture.asset(editSVG,
                                                  color: housePrimaryColor)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      );
                    }),

                Space().height(context, 0.04),

                //GPS Address
                FormBuilderField<String>(
                    name: "GPSAddress",
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return fieldRequired;
                      }
                      if (value!.length <= 5) {
                        return mustBeCharacters;
                      }
                      return null;
                    },
                    onChanged: (value) {},
                    builder: (context) {
                      return DefaultTextfield(
                        controller: houseGPSAddressController,
                        label: "GPS Address",
                        hintText: "Enter your GPS Address",
                        errorText: context.errorText,
                        onChanged: (p0) => context.didChange(p0),
                      );
                    }),

                //town or city
                FormBuilderField<String>(
                    name: "townOrCity",
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return fieldRequired;
                      }

                      if (value!.length <= 1) {
                        return mustBeCharacters;
                      }
                      return null;
                    },
                    builder: (field) {
                      return DefaultTextfield(
                        controller: townOrCityController,
                        label: "Town or City",
                        hintText: "Enter your Town or City",
                        errorText: field.errorText,
                        onChanged: (p0) => field.didChange(p0),
                      );
                    }),

                //house document
                FormBuilderField<String>(
                    name: "houseDocument",
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return fieldRequired;
                      }

                      return null;
                    },
                    builder: (field) {
                      return InputDecorator(
                        decoration: InputDecoration(errorText: field.errorText),
                        child: BlocConsumer(
                            bloc: homeBloc,
                            listener: (context, state) {
                              if (state is HouseDocumentError) {
                                debugPrint(state.errorMessage);
                              }
                              if (state is HouseDocumentLoaded) {
                                debugPrint(state.file.path);
                                houseDocumentURL = state.file.path;
                                setState(() {});
                                field.didChange(houseDocumentURL);
                              }
                            },
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Add House Document",
                                  ),
                                  Space().height(context, 0.01),
                                  SizedBox(
                                    width: 180,
                                    height: 150,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Container(
                                              width: 180,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: searchTextColor3,
                                              ),
                                              child: houseDocumentURL == null
                                                  ? SvgPicture.asset(cameraSVG)
                                                  : Image.file(
                                                      File(
                                                        houseDocumentURL!,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: GestureDetector(
                                              onTap: () {
                                                
                                                buildHouseDocumentChangeBottomSheet(
                                                  context,
                                                  homeBloc,
                                                  authBloc,
                                                );
                                               
                                              },
                                              child: SvgPicture.asset(editSVG,
                                                  color: housePrimaryColor)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      );
                    }),

                Space().height(context, 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
