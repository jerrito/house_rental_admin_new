import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:house_rental_admin/core/size/sizes.dart';
import 'package:house_rental_admin/core/spacing/whitspacing.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/core/widgets/show_toast.dart';
import 'package:house_rental_admin/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:house_rental_admin/src/authentication/presentation/widgets/default_button.dart';

buildProfileChangeBottomSheet(BuildContext context, String? id,
    String? phoneNumber, AuthenticationBloc authBloc) {
  return showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: ((context) {
        return Container(
            height: Sizes().height(context, 0.3),
            padding: EdgeInsets.all(Sizes().width(context, 0.04)),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.s,
              children: [
                Space().height(context, 0.02),
                const Text("Update profile"),
                Space().height(context, 0.04),
                BlocConsumer(
                    bloc: authBloc,
                    listener: (context, state) async {
                      if (state is UpLoadImageError) {
                        debugPrint(state.errorMessage);
                      }

                      if (state is UpLoadImageLoaded) {
                        Map<String, dynamic> params = {
                          "id": id ?? "",
                          "profile_URL": state.imageURL,
                        };
                        authBloc.add(UpdateUserEvent(params: params));
                      }

                      if (state is UpdateUserLoaded) {
                        context.pop("updated");
                      }

                      if (state is UpdateUserError) {
                        showToastInfo(
                          context: context,
                          label: state.errorMessage,
                          isFailed: true,
                        );
                      }
                      if (state is GetProfileError) {
                        showToastInfo(
                          context: context,
                          label: state.errorMessage,
                          isFailed: true,
                        );
                      }
                      if (state is GetProfileLoaded) {
                        Map<String, dynamic> params = {
                          "phone_number": phoneNumber ?? "",
                          "path": state.file.path,
                        };

                        authBloc.add(UpLoadImageEvent(params: params));
                      }
                    },
                    builder: (context, state) {
                      if (state is UpLoadImageLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is UpdateUserLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          DefaultButton(
                              label: "Camera",
                              onTap: () {
                                authBloc.add(
                                    GetProfileCameraEvent(params: NoParams()));
                              }),
                          Space().height(context, 0.02),
                          DefaultButton(
                              label: "Gallery",
                              onTap: () {
                                //context.pop();
                                authBloc.add(
                                    GetProfileGalleryEvent(params: NoParams()));

                                // Navigator.pop(context);
                              })
                        ],
                      );
                    }),
              ],
            ));
      }));
}
