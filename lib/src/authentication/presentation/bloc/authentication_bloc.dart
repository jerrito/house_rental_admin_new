import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:house_rental_admin/core/firebase/firebase_service.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/authentication/domain/entities/owner.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/add_id.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/check_phone_number.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/get_user.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/signin.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/get_cache_data.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/phone_number_login.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/signup.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/up_load_image.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/update_user.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/verify_otp.dart';
import 'package:house_rental_admin/src/authentication/domain/usecases/verify_number.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_profile_camera.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_profile_gallery.dart';
import 'package:image_picker/image_picker.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final auth.FirebaseAuth firebaseAuth;
  final Signup signup;
  final VerifyPhoneNumber verifyNumber;
  final VerifyPhoneNumberLogin verifyPhoneNumberLogin;
  final VerifyOTP verifyOTP;
  final GetCacheData getCacheData;
  final Signin signin;
  final UpdateUser updateUser;
  final FirebaseService firebaseService;
  final AddId addId;
  final UpLoadImage upLoadImage;
  final CheckPhoneNumberChange checkPhoneNumberChange;
  final GetUser getUser;
  final GetProfileCamera getProfileCamera;
  final GetProfileGallery getProfileGallery;
  AuthenticationBloc({
    required this.verifyPhoneNumberLogin,
    required this.signup,
    required this.firebaseAuth,
    required this.getProfileCamera,
    required this.getProfileGallery,
    required this.verifyNumber,
    required this.verifyOTP,
    required this.getCacheData,
    required this.signin,
    required this.firebaseService,
    required this.updateUser,
    required this.addId,
    required this.upLoadImage,
    required this.checkPhoneNumberChange,
    required this.getUser,
  }) : super(AuthenticationInitial()) {
    on<SignupEvent>((event, emit) async {
      emit(SignupLoading());

      final response = await signup.call(event.users);
      emit(
        response.fold(
          (error) => GenericError(errorMessage: error),
          (response) => SignupLoaded(reference: response),
        ),
      );
    });
    on<PhoneNumberEvent>((event, emit) async {
      emit(
        VerifyPhoneNumberLoading(),
      );

      await verifyNumber.verifyPhoneNumber(
        event.phoneNumber,
        (verificationId, resendToken) => add(
          CodeSentEvent(
            forceResendingToken: resendToken!,
            verificationId: verificationId,
          ),
        ),
        (phoneAuthCredential) => add(
          VerificationCompleteEvent(phoneAuthCredential: phoneAuthCredential),
        ),
        (p0) => add(
          PhoneNumberErrorEvent(error: p0.message!),
        ),
      );
    });

    //!Code Sent
    on<CodeSentEvent>((event, emit) async {
      emit(
        CodeSent(
            verifyId: event.verificationId, token: event.forceResendingToken),
      );
    });

    on<VerificationCompleteEvent>((event, emit) {
      emit(
        CodeCompleted(authCredential: event.phoneAuthCredential),
      );
    });
    on<PhoneNumberErrorEvent>((event, emit) {
      emit(
        GenericError(errorMessage: event.error),
      );
    });

    on<PhoneNumberLoginEvent>((event, emit) async {
      emit(
        VerifyPhoneNumberLoading(),
      );

      await verifyPhoneNumberLogin.verifyPhoneNumberLogin(
        event.phoneNumber,
        (verificationId, resendToken) => add(
          CodeSentEvent(
            forceResendingToken: resendToken!,
            verificationId: verificationId,
          ),
        ),
        (phoneAuthCredential) => add(
          VerificationCompleteEvent(phoneAuthCredential: phoneAuthCredential),
        ),
        (p0) => add(
          PhoneNumberErrorEvent(error: p0.message!),
        ),
      );
    });
    on<VerifyOTPEvent>(
      (event, emit) async {
        emit(
          VerifyOTPLoading(),
        );

        final response = await verifyOTP.call(event.params);

        emit(
          response.fold(
            (error) => VerifyOTPFailed(errorMessage: error),
            (response) => VerifyOTPLoaded(user: response),
          ),
        );

        // // ignore: unused_label
        // transformer:
        // restartable();
      },
    );

    on<GetCacheDataEvent>((event, emit) async {
      final response = await getCacheData.call(
        NoParams(),
      );

      emit(
        response.fold(
          (error) => GetCacheDataError(errorMessage: error),
          (response) => GetCacheDataLoaded(owner: response),
        ),
      );
    });

    on<SigninEvent>((event, emit) async {
      emit(SigninLoading());

      final response = await signin.call(event.users);

      emit(
        response.fold(
          (error) => SigninError(errorMessage: error),
          (response) {
            // firebaseService.updateUser(user: response.data());
            return SigninLoaded(owner: response!);
          },
        ),
      );
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(UpdateUserLoading());

      final response = await updateUser.call(event.params);

      emit(
        response.fold(
          (error) => UpdateUserError(errorMessage: error),
          (response) => UpdateUserLoaded(),
        ),
      );
    });

    on<AddIdEvent>((event, emit) async {
      final response = await addId.call(event.params);

      emit(
        response.fold(
          (error) => AddIdError(errorMessage: error),
          (response) => AddIdLoaded(),
        ),
      );
    });

    //!UPLOAD IMAGE TO CLOUD STORE
    on<UpLoadImageEvent>((event, emit) async {
      emit(UpLoadImageLoading());

      final response = await upLoadImage.call(event.params);

      emit(response.fold((error) => UpLoadImageError(errorMessage: error),
          (response) => UpLoadImageLoaded(imageURL: response)));
    });

    on<CheckPhoneNumberEvent>((event, emit) async {
      emit(
        CheckPhoneNumberChangeLoading(),
      );
      final response = await checkPhoneNumberChange.call(
        event.params,
      );
      emit(
        response.fold(
          (error) => CheckPhoneNumberChangeError(
            errorMessage: error,
          ),
          (response) => CheckPhoneNumberLoaded(
            isNumberChecked: response,
          ),
        ),
      );
    });

     on<GetUserEvent>((event, emit) async {
      emit(
        GetUserLoading(),
      );
      final response = await getUser.call(
        event.params,
      );
      emit(
        response.fold(
          (error) => GetUserError(
            errorMessage: error,
          ),
          (response) => GetUserLoaded(
            owner: response,
          ),
        ),
      );
    });

    //!GET PROFILE Camera
    on<GetProfileCameraEvent>((event, emit) async {
      final response = await getProfileCamera.call(event.params);

      emit(response.fold((error) => GetProfileError(errorMessage: error),
          (response) => GetProfileLoaded(file: response)));
    });

    //!GET PROFILE Gallery
    on<GetProfileGalleryEvent>((event, emit) async {
      final response = await getProfileGallery.call(event.params);

      emit(response.fold((error) => GetProfileError(errorMessage: error),
          (response) => GetProfileLoaded(file: response)));
    });
  }
}
