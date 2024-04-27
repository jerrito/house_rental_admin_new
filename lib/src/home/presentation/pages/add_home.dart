// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter_switch/flutter_switch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:house_rental_admin/assets/svgs/svg_constants.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/core/strings/app_strings.dart';
import 'package:house_rental_admin/core/theme/colors.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/core/widgets/bottom_sheet.dart';
import 'package:house_rental_admin/core/widgets/show_toast.dart';
import 'package:house_rental_admin/locator.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_button.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_textfield.dart';
import 'package:house_rental_admin/src/home/domain/entities/house.dart';
import 'package:house_rental_admin/src/home/presentation/bloc/home_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental_admin/src/home/presentation/widgets/build_select_location.dart';
import 'package:oktoast/oktoast.dart';

class AddHomePage extends StatefulWidget {
  const AddHomePage({
    super.key,
  });

  @override
  State<AddHomePage> createState() => _AddHomePageState();
}

class _AddHomePageState extends State<AddHomePage> {
  final homeBloc = locator<HomeBloc>();
  final homeBloc2 = locator<HomeBloc>();
  final homeBloc3 = locator<HomeBloc>();
  final authBloc = locator<AuthenticationBloc>();
  final formKey = GlobalKey<FormBuilderState>();
  final homeNameController = TextEditingController();
  final amountController = TextEditingController();
  final bathRoomController = TextEditingController();
  final bedRoomController = TextEditingController();
  final descriptionController = TextEditingController();
  Owner? owner;
  bool isAvailable = true;
  bool isImageAvailable = true;
  List<String>? images = [];
  HouseLocation? houseLocation;

  @override
  void initState() {
    authBloc.add(const GetCacheDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: BlocConsumer(
          bloc: homeBloc,
          listener: (context, state) {
            if (state is UpLoadMultipleImageLoaded) {
              Map<String, dynamic> params = {
                "house_name": homeNameController.text,
                "description": descriptionController.text,
                "amount": num.parse(amountController.text),
                "bed_room_count": num.parse(bedRoomController.text),
                "bath_room_count": num.parse(bathRoomController.text),
                "images": state.imageURL,
                "owner": owner?.toMap(),
                "phone_number": owner?.phoneNumber,
                "house_details": houseLocation?.toMap(),
                "category": "house",
                "is_available": isAvailable,
              };
              homeBloc.add(
                AddHomeEvent(params: params),
              );
            }

            if (state is AddHomeLoaded) {
              final Map<String, dynamic> params = {
                "title": "New House added",
                "body": "New house in Abokobi",
                "id": state.houses?.id,
              };
              homeBloc.add(SendFCMMessageEvent(params: params));
            }

            if (state is SendFCMMessageLoaded) {
              context.goNamed("homePage");
            }
            if (state is SendFCMMessageError) {
              showToastInfo(
                context: context,
                label: state.errorMessage,
                isFailed: true,
              );
            }

            if (state is AddHomeError) {
              showToastInfo(
                context: context,
                label: state.errorMessage,
                isFailed: true,
              );
            }

            if (state is UpLoadMultipleImageError) {
              showToastInfo(
                context: context,
                label: state.errorMessage,
                isFailed: true,
              );
            }
          },
          builder: (context, state) {
            if (state is AddHomeLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UpLoadMultipleImageLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return bottomSheetButton(
              context: context,
              label: "Add Home",
              onPressed: () {
                if (formKey.currentState!.saveAndValidate() == true) {
                  Map<String, dynamic> params = {
                    "phone_number": owner?.phoneNumber,
                    "path": images,
                    "images": images?.length
                  };
                  homeBloc.add(
                    UpLoadMultipleImageEvent(
                      params: params,
                    ),
                  );
                }
              },
            );
          },
        ),
        appBar: AppBar(
          
          title: const Text("Add Home or Room"),
         leading: 
          BlocConsumer(
            bloc:homeBloc,
            listener: (context, state) {
            
            if (state is SendFCMMessageLoaded) {
              context.goNamed("homePage");
            }
            if (state is SendFCMMessageError) {
              showToastInfo(
                context: context,
                label: state.errorMessage,
                isFailed: true,
              );
            }
          }, builder: (context, state) {
            if (state is SendFCMMessagesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return GestureDetector(
              onTap:() async {
                    final Map<String, dynamic> params = {
                      "title": "New House added",
                      "body": "New house in Abokobi",
                      "id": "state.houses?.id",
                    };
                    homeBloc.add(SendFCMMessageEvent(params: params));
                  },
              child:const Icon(
                  (Icons.send)),
            );
          })
        ),
        body: BlocListener(
            bloc: authBloc,
            listener: (context, state) {
              if (state is GetCacheDataLoaded) {
                owner = state.owner;
                setState(() {});
              }
            },
            child: FormBuilder(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.04)),
                      child: FormBuilderField<String>(
                          name: "homeName",
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
                              controller: homeNameController,
                              hintText: "Enter home name",
                              label: "Home name",
                              errorText: context.errorText,
                              onChanged: (p0) => context.didChange(p0),
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.04)),
                      child: FormBuilderField<num>(
                          name: "rentAmount",
                          validator: (value) {
                            if (value == null || value.toString().isEmpty) {
                              return numberRequired;
                            }
                            if (value.isNaN) {
                              return numberRequired;
                            }
                            if (value <= 1) {
                              return mustBeAtleast;
                            }

                            return null;
                          },
                          builder: (context) {
                            return DefaultTextfield(
                                textInputType: TextInputType.number,
                                controller: amountController,
                                hintText: "Enter rent amount",
                                label: "Rent amount",
                                errorText: context.errorText,
                                onChanged: (p0) => context.didChange(
                                      (num.parse(p0!)),
                                    ));
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.04)),
                      child: FormBuilderField<int>(
                          name: "bedRooms",
                          validator: (value) {
                            if (value == null || value.toString().isEmpty) {
                              return numberRequired;
                            }
                            if (value.isNaN) {
                              return numberRequired;
                            }
                            if (value <= 0) {
                              return mustBeAtleast;
                            }
                            if (value >= 13) {
                              return mustBeAtmost;
                            }
                            return null;
                          },
                          builder: (context) {
                            return DefaultTextfield(
                              textInputType: TextInputType.number,
                              controller: bedRoomController,
                              hintText: "Enter number of Bed Rooms",
                              label: "Number of Bed Rooms",
                              errorText: context.errorText,
                              onChanged: (p0) => context.didChange(
                                (int.parse(p0!)),
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.04)),
                      child: FormBuilderField<int>(
                          name: "bathRooms",
                          validator: (value) {
                            if (value?.isNaN ?? true) {
                              return numberRequired;
                            }
                            if (value! <= 0) {
                              return mustBeAtleast;
                            }
                            if (value >= 13) {
                              return mustBeAtmost;
                            }
                            return null;
                          },
                          builder: (context) {
                            return DefaultTextfield(
                              textInputType: TextInputType.number,
                              controller: bathRoomController,
                              hintText: "Enter number of Bath Rooms",
                              label: "Number of Bath Rooms",
                              errorText: context.errorText,
                              onChanged: (p0) => context.didChange(
                                (int.parse(p0!)),
                              ),
                            );
                          }),
                    ),
                    FormBuilderField<String>(
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Location  required";
                          }
                          if (value!.length <= 1) {
                            return mustBeCharacters;
                          }
                          return null;
                        },
                        name: "location",
                        builder: (field) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizes().width(context, 0.04),
                            ),
                            child: BlocConsumer(
                              bloc: homeBloc2,
                              builder: (context, state) {
                                if (state is AddLocationLoaded) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        height: Sizes().height(context, 0.05),
                                        child: Center(
                                          child: Text(state
                                                      .houseLocation
                                                      .formatedAddress!
                                                      .length <=
                                                  35
                                              ? state.houseLocation
                                                  .formatedAddress!
                                              : "${state.houseLocation.formatedAddress?.substring(0, 35)}..."),
                                        ),
                                      ),
                                      Space().width(context, 0.02),
                                      GestureDetector(
                                        onTap: () async {
                                          final result =
                                              await buildSelectLocation(
                                                  context);
                                          if (mounted) {
                                            homeBloc2.add(AddLocationEvent(
                                                params: result));
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          editSVG,
                                          color: housePrimaryColor,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return InputDecorator(
                                  decoration: InputDecoration(
                                      enabledBorder: const UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white)),
                                      errorText: field.errorText),
                                  child: DefaultButton(
                                    label: "Add Location",
                                    onTap: () async {
                                      final result =
                                          await buildSelectLocation(context);

                                      homeBloc2.add(
                                          AddLocationEvent(params: result));
                                    },
                                  ),
                                );
                              },
                              listener: (BuildContext context, state) {
                                if (state is AddLocationLoaded) {
                                  houseLocation = state.houseLocation;
                                  setState(() {});
                                  field.didChange(
                                      houseLocation?.formatedAddress ?? "");
                                }
                                if (state is AddLocationError) {
                                  OKToast(child: Text(state.errorMessage));
                                }
                              },
                            ),
                          );
                        }),
                    Space().height(context, 0.02),

                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Sizes().width(context, 0.04)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Is Available for rent"),
                            FlutterSwitch(
                              width: 70.0,
                              height: 50.0,
                              valueFontSize: 10.0,
                              activeColor: Colors.blueAccent,
                              toggleSize: 30.0,
                              value: isAvailable,
                              borderRadius: 20.0,
                              padding: 8.0,
                              activeText: "Yes",
                              inactiveText: "No",
                              showOnOff: true,
                              onToggle: (val) {
                                setState(() {
                                  isAvailable = val;
                                });
                              },
                            ),
                          ],
                        )),
                    Space().height(context, 0.02),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.04)),
                      child: Row(
                        children: [
                          const Text("House Image(s)"),
                          Space().width(context, 0.03),
                          GestureDetector(
                            onTap: () {
                              homeBloc3.add(
                                AddMultipleImageEvent(
                                  params: NoParams(),
                                ),
                              );
                            },
                            child: SvgPicture.asset(
                              editSVG,
                              color: housePrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Space().height(context, 0.005),
                    FormBuilderField<List<String>>(
                        name: "house_images",
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return fieldRequired;
                          }

                          return null;
                        },
                        builder: (field) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                errorText: field.errorText),
                            child: BlocConsumer(
                              bloc: homeBloc3,
                              builder: (context, state) {
                                if (state is AddMultipleImageLoaded) {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 150,
                                    child: CarouselSlider.builder(
                                      itemCount: state.files.length,
                                      itemBuilder: (context, index, value) {
                                        final paths = state.files[index].path;

                                        return Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Sizes().width(context, 0.04)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(
                                              File(paths ?? ""),
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 150,
                                            ),
                                          ),
                                        );
                                      },
                                      options: CarouselOptions(
                                        height: 150,
                                        reverse: true,
                                      ),
                                    ),
                                  );
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes().width(context, 0.04)),
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Sizes().width(context, 0.08)),
                                      width: 180,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: searchTextColor3,
                                      ),
                                      child: GestureDetector(
                                          onTap: () {
                                            homeBloc3.add(AddMultipleImageEvent(
                                                params: NoParams()));
                                          },
                                          child: SvgPicture.asset(cameraSVG))),
                                );
                              },
                              listener: (BuildContext context, state) {
                                if (state is AddMultipleImageError) {
                                  showToastInfo(
                                    context: context,
                                    label: state.errorMessage,
                                    isFailed: true,
                                  );
                                }
                                if (state is AddMultipleImageLoaded) {
                                  for (int i = 0; i < state.files.length; i++) {
                                    images?.add(state.files[i].path!);
                                  }
                                  field.didChange(images);
                                }
                              },
                            ),
                          );
                        }),
                    FormBuilderField<String>(
                        name: "homeDescription",
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
                          return Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizes().width(context, 0.04)),
                            child: DefaultTextArea(
                              //focusNode: FocusNode(),
                              //height: 100,
                              controller: descriptionController,
                              hintText: "Enter home description",
                              label: "Home Description",
                              errorText: field.errorText,
                              onTapOutSide: (value) {},
                              onChanged: (p0) => field.didChange(p0),
                            ),
                          );
                        }),

                    Space().height(context, 0.04),
                    const DefaultButton(
                      label: "",
                    )
                  ],
                ),
              ),
            )));
  }
}
