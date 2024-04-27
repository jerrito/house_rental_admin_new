import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:house_rental_admin/core/usecase/usecase.dart';
import 'package:house_rental_admin/src/home/domain/entities/house.dart';
import 'package:house_rental_admin/src/home/domain/entities/place_search.dart';
import 'package:house_rental_admin/src/home/domain/usecases/add_house.dart';
import 'package:house_rental_admin/src/home/domain/usecases/add_location.dart';
import 'package:house_rental_admin/src/home/domain/usecases/add_multiple_image.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_all_houses.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_place_by_latlng.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_profile_camera.dart';
import 'package:house_rental_admin/src/home/domain/usecases/get_profile_gallery.dart';
import 'package:house_rental_admin/src/home/domain/usecases/place_search.dart';
import 'package:house_rental_admin/src/home/domain/usecases/send_fcm_message.dart';
import 'package:house_rental_admin/src/home/domain/usecases/update_house.dart';
import 'package:house_rental_admin/src/home/domain/usecases/upload_multiple_images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetProfileCamera getProfileCamera;
  final GetProfileGallery getProfileGallery;
  final AddMultipleImage addMultipleImage;
  final GetAllHouses getAllHouses;
  final AddHouse addHouse;
  final UploadMultipleImages uploadMultipleImages;
  final UpdateHouse updateHouse;
  final SearchPlace placeSearch;
  final GetPlaceByLatLng getPlaceByLatLng;
  final AddLocation addLocation;
  final SendFCMMessage sendFCMMessage;

  HomeBloc({
    required this.getAllHouses,
    required this.addMultipleImage,
    required this.getProfileCamera,
    required this.getProfileGallery,
    required this.addHouse,
    required this.uploadMultipleImages,
    required this.updateHouse,
    required this.placeSearch,
    required this.getPlaceByLatLng,
    required this.addLocation,
    required this.sendFCMMessage,
  }) : super(HomeInitState()) {
    //!GET HOUSE DOCUMENT Camera
    on<GetHouseDocumentCameraEvent>((event, emit) async {
      final response = await getProfileCamera.call(event.params);
      emit(
        response.fold(
          (error) => HouseDocumentError(errorMessage: error),
          (response) => HouseDocumentLoaded(file: response),
        ),
      );
    });

    //!GET HOUSE DOCUMENT GALLERY
    on<GetHouseDocumentGalleryEvent>((event, emit) async {
      final response = await getProfileGallery.call(event.params);
      emit(
        response.fold(
          (error) => HouseDocumentError(errorMessage: error),
          (response) => HouseDocumentLoaded(file: response),
        ),
      );
    });

    //!ADD MULTIPLE IMAGES
    on<AddMultipleImageEvent>((event, emit) async {
      final response = await addMultipleImage.call(event.params);

      emit(
        response.fold(
          (error) => AddMultipleImageError(errorMessage: error),
          (response) => AddMultipleImageLoaded(files: response),
        ),
      );
    });

    //!ADD HOME DOCUMENT
    on<AddHomeEvent>((event, emit) async {
      emit(AddHomeLoading());

      final response = await addHouse.call(event.params);

      emit(
        response.fold(
          (error) => AddHomeError(errorMessage: error),
          (response) => AddHomeLoaded(houses: response),
        ),
      );
    });

    //!GET ALL HOUSES
    on<GetAllHousesEvent>((event, emit) async {
      emit(GetAllHousesLoading());
      final response = await getAllHouses.call(event.params);

      emit(
        response.fold(
          (error) => GetAllHouseError(errorMessage: error),
          (response) => GetAllHousesLoaded(houses: response),
        ),
      );
    });

    //!UPLOAD MULTIPLE IMAGES TO CLOUD
    on<UpLoadMultipleImageEvent>((event, emit) async {
      emit(UpLoadMultipleImageLoading());
      final response = await uploadMultipleImages.call(
        event.params,
      );

      emit(
        response.fold(
          (error) => UpLoadMultipleImageError(errorMessage: error),
          (response) => UpLoadMultipleImageLoaded(
            imageURL: response,
          ),
        ),
      );
    });

    on<UpdateHouseEvent>((event, emit) async {
      emit(UpdateHouseLoading());
      final response = await updateHouse.call(event.params);

      emit(
        response.fold(
          (error) => UpdateHouseError(errorMessage: error),
          (response) => UpdateHouseLoaded(),
        ),
      );
    });

    on<PlaceSearchEvent>((event, emit) async {
      emit(PlaceSearchLoading());
      final response = await placeSearch.call(event.params);

      emit(
        response.fold(
          (error) => PlaceSearchError(errorMessage: error),
          (response) => PlaceSearchLoaded(placeSearch: response),
        ),
      );
      // ignore: unused_label
      transformer:
      restartable();
    });

    on<GetPlaceByLatLngEvent>((event, emit) async {
      emit(GetPlaceByLatLngLoading());
      final response = await getPlaceByLatLng.call(event.params);

      emit(
        response.fold(
          (error) => GetPlaceByLatLngError(errorMessage: error),
          (response) => GetPlaceByLatLngLoaded(placeSearch: response),
        ),
      );
    });
    //! ADD LOCATION
    on<AddLocationEvent>((event, emit) async {
      final response = await addLocation.call(event.params);

      emit(response.fold((error) => AddLocationError(errorMessage: error),
          (response) => AddLocationLoaded(houseLocation: response)));
    });

    on<SendFCMMessageEvent>(
      ((event, emit) async {
        emit(SendFCMMessagesLoading());
        final response = await sendFCMMessage.call(event.params);

        emit(
          response.fold(
            (l) => SendFCMMessageError(errorMessage: l),
            (r) => SendFCMMessageLoaded(),
          ),
        );
      }),
    );
  }
}
