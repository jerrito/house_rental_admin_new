// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:house_rental_admin/assets/svgs/svg_constants.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/core/strings/app_strings.dart';
import 'package:house_rental_admin/core/theme/colors.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/core/widgets/bottom_sheet.dart';
import 'package:house_rental_admin/core/widgets/show_toast.dart';
import 'package:house_rental_admin/locator.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_textfield.dart';
import 'package:house_rental_admin/src/home/domain/entities/house.dart';
import 'package:house_rental_admin/src/home/presentation/bloc/home_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental_admin/src/home/presentation/widgets/build_select_location.dart';

class EditHomePage extends StatefulWidget {
  final HouseDetail house;
  final String id;

  const EditHomePage({
    super.key,
    required this.house,
    required this.id,
  });

  @override
  State<EditHomePage> createState() => _EditHomePageState();
}

class _EditHomePageState extends State<EditHomePage> {
  final homeBloc = locator<HomeBloc>();
  final homeBloc2 = locator<HomeBloc>();
  final authBloc = locator<AuthenticationBloc>();
  final formKey = GlobalKey<FormBuilderState>();
  String? homeNameController;
  String? amountController;
  String? bathRoomController;
  String? bedRoomController;
  String? descriptionController;

  HouseLocation? houseLocation;
  bool isImageAvailable = true;
  bool? isAvailable;
  List<String> localImages = [];
  List<String> networkImages = [];
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.house.images!.length; i++) {
      networkImages.add(widget.house.images![i]);
    }
    houseLocation = widget.house.houseLocation;
    homeNameController = widget.house.houseName;
    isAvailable = widget.house.isAvailable;
    descriptionController = widget.house.description;
    amountController = widget.house.amount.toString();
    bedRoomController = widget.house.bedRoomCount.toString();
    bathRoomController = widget.house.bathRoomCount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BlocConsumer(
        bloc: homeBloc,
        listener: (context, state) {
          if (state is UpLoadMultipleImageLoaded) {
            Map<String, dynamic> params = {
              "house_name": homeNameController,
              "description": descriptionController,
              "amount": num.parse(amountController!),
              "bed_room_count": num.parse(bedRoomController!),
              "bath_room_count": num.parse(bathRoomController!),
              "images": state.imageURL,
              "is_available": isAvailable,
              "house_details": houseLocation?.toMap(),
              "id": widget.id,
            };
            homeBloc.add(
              UpdateHouseEvent(
                params: params,
              ),
            );
          }
          if (state is UpdateHouseError) {
            showToastInfo(
              context: context,
              label: state.errorMessage,
              isFailed: true,
            );
          }
          if (state is UpdateHouseLoaded) {
            context.pop("updated");
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
          if (state is UpLoadMultipleImageLoading ||
              state is UpdateHouseLoading) {
            const Center(
              child: CircularProgressIndicator(),
            );
          }

          return bottomSheetButton(
            context: context,
            label: "Update Home",
            onPressed: () {
              if (formKey.currentState!.saveAndValidate() == true) {
                if (networkImages.isNotEmpty) {
                  Map<String, dynamic> params = {
                    "house_name": homeNameController,
                    "description": descriptionController,
                    "amount": num.parse(amountController!),
                    "bed_room_count": num.parse(bedRoomController!),
                    "bath_room_count": num.parse(bathRoomController!),
                    "house_details": houseLocation?.toMap(),
                    "is_available": isAvailable,
                    "id": widget.id,
                  };
                  homeBloc.add(
                    UpdateHouseEvent(
                      params: params,
                    ),
                  );
                } else {
                  Map<String, dynamic> params = {
                    "phone_number": widget.house.houseName,
                    "path": localImages,
                    "images": localImages.length
                  };
                  homeBloc.add(
                    UpLoadMultipleImageEvent(
                      params: params,
                    ),
                  );
                }
              }
            },
          );
        },
      ),
      appBar: AppBar(
        title: const Text("Edit Home or Room"),
      ),
      body: FormBuilder(
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
                    initialValue: homeNameController,
                    validator: (value) {
                      if ((value?.isEmpty) ?? true) {
                        return fieldRequired;
                      }
                      if (value!.length <= 1) {
                        return mustBeCharacters;
                      }
                      return null;
                    },
                    builder: (field) {
                      return DefaultTextfield(
                          initialValue: homeNameController,
                          hintText: "Enter home name",
                          label: "Home name",
                          errorText: field.errorText,
                          onChanged: (p0) {
                            field.didChange((p0!.trim()));
                            homeNameController = p0;
                          });
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width(context, 0.04)),
                child: FormBuilderField(
                    initialValue: num.parse(amountController!),
                    name: "rentAmount",
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return numberRequired;
                      }
                      if (value?.isNaN ?? true) {
                        return numberRequired;
                      }
                      if (value! <= 1) {
                        return mustBeAtleast;
                      }

                      return null;
                    },
                    onChanged: (value) {},
                    builder: (field) {
                      return DefaultTextfield(
                          initialValue: amountController,
                          textInputType: TextInputType.number,
                          hintText: "Enter rent amount",
                          label: "Rent amount",
                          errorText: field.errorText,
                          onChanged: (p0) {
                            field.didChange(num.parse(p0!));
                            amountController = p0;
                          });
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width(context, 0.04)),
                child: FormBuilderField<int>(
                    name: "bedRooms",
                    validator: (value) {
                      value = int.parse(bedRoomController!);
                      if (value.toString().isEmpty) {
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
                          initialValue: widget.house.bedRoomCount.toString(),
                          textInputType: TextInputType.number,
                          hintText: "Enter number of Bed Rooms",
                          label: "Number of Bed Rooms",
                          errorText: context.errorText,
                          onChanged: (p0) {
                            context.didChange((int.parse(p0!)));
                            bedRoomController = p0;
                          });
                    }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Sizes().width(context, 0.04)),
                child: FormBuilderField<int>(
                    initialValue: int.parse(bathRoomController!),
                    name: "bathRooms",
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return fieldRequired;
                      }
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
                    builder: (field) {
                      return DefaultTextfield(
                          initialValue: bathRoomController,
                          textInputType: TextInputType.number,
                          hintText: "Enter number of Bath Rooms",
                          label: "Number of Bath Rooms",
                          errorText: field.errorText,
                          onChanged: (p0) {
                            bathRoomController = p0;
                            field.didChange((int.parse(p0!)));
                          });
                    }),
              ),
              FormBuilderField<String>(
                  initialValue: houseLocation!.formatedAddress!,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return mustBeAtleast;
                    }
                    return null;
                  },
                  name: "location",
                  builder: (field) {
                    return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes().width(context, 0.04),
                        ),
                        child: InputDecorator(
                          decoration:
                              InputDecoration(errorText: field.errorText),
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
                                        child: Text(state.houseLocation
                                                    .formatedAddress!.length <=
                                                35
                                            ? state
                                                .houseLocation.formatedAddress!
                                            : "${state.houseLocation.formatedAddress?.substring(0, 35)}..."),
                                      ),
                                    ),
                                    Space().width(context, 0.02),
                                    GestureDetector(
                                      onTap: () async {
                                        final result =
                                            await buildSelectLocation(context);
                                        if (!mounted) return;

                                        homeBloc2.add(
                                            AddLocationEvent(params: result));
                                      },
                                      child: SvgPicture.asset(
                                        editSVG,
                                        color: housePrimaryColor,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Location"),
                                  Space().height(context, 0.003),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: Sizes().height(context, 0.05),
                                        child: Center(
                                          child: Text(widget
                                                      .house
                                                      .houseLocation!
                                                      .formatedAddress!
                                                      .length <=
                                                  35
                                              ? widget.house.houseLocation!
                                                  .formatedAddress!
                                              : "${widget.house.houseLocation?.formatedAddress?.substring(0, 35)}..."),
                                        ),
                                      ),
                                      Space().width(context, 0.02),
                                      GestureDetector(
                                        onTap: () async {
                                          final result =
                                              await buildSelectLocation(
                                                  context);
                                          if (!mounted) return;

                                          homeBloc2.add(
                                              AddLocationEvent(params: result));
                                        },
                                        child: SvgPicture.asset(
                                          editSVG,
                                          color: housePrimaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                            listener: (BuildContext context, state) {
                              if (state is AddLocationLoaded) {
                                houseLocation = state.houseLocation;
                                setState(() {});
                                field.didChange(houseLocation?.formatedAddress);
                              }
                              if (state is AddLocationError) {
                                showToastInfo(
                                  context: context,
                                  label: state.errorMessage,
                                  isFailed: true,
                                );
                              }
                            },
                          ),
                        ));
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
                        value: isAvailable ?? true,
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
                        homeBloc.add(AddMultipleImageEvent(params: NoParams()));
                      },
                      child: SvgPicture.asset(
                        editSVG,
                        color: housePrimaryColor,
                        // colorFilter: ColorFilter.mode(
                        //   color:housePrimaryColor

                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              Space().height(context, 0.02),
              FormBuilderField<List<String>>(
                  initialValue: networkImages,
                  name: "house_images",
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
                                      borderRadius: BorderRadius.circular(5),
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
                          return SizedBox(
                            width: double.infinity,
                            height: 150,
                            child: CarouselSlider.builder(
                              itemCount: networkImages.length,
                              itemBuilder: (context, index, value) {
                                final paths = networkImages[index];

                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Sizes().width(context, 0.04)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.network(
                                      paths,
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
                            networkImages.clear();
                            for (int i = 0; i < state.files.length; i++) {
                              localImages.add(state.files[i].path!);
                            }
                            field.didChange(localImages);
                          }
                        },
                      ),
                    );
                  }),
              FormBuilderField<String>(
                  initialValue: descriptionController,
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
                          initialValue: widget.house.description,
                          hintText: "Enter home description",
                          label: "Home Description",
                          errorText: field.errorText,
                          onChanged: (p0) {
                            field.didChange(p0!);
                            descriptionController = p0;
                          }),
                    );
                  }),
              Space().height(context, 0.02)
            ],
          ),
        ),
      ),
    );
  }
}
