part of 'home_bloc.dart';

class HomeState {}

class HomeInitState extends HomeState {}



class HouseDocumentLoaded extends HomeState {
  final XFile file;
  HouseDocumentLoaded({required this.file});
}

class HouseDocumentError extends HomeState {
  final String errorMessage;
  HouseDocumentError({required this.errorMessage});
}

class AddMultipleImageLoaded extends HomeState {
  final List<PlatformFile> files;

  AddMultipleImageLoaded({required this.files});
}

class AddMultipleImageLoading extends HomeState {}

class AddMultipleImageError extends HomeState {
  final String errorMessage;

  AddMultipleImageError({required this.errorMessage});
}

class AddHomeLoaded extends HomeState {
  final DocumentReference<Map<String, dynamic>>? houses;
  AddHomeLoaded({required this.houses});
}

class AddHomeLoading extends HomeState {}

class AddHomeError extends HomeState {
  final String errorMessage;
  AddHomeError({required this.errorMessage});
} 

class GetAllHousesLoaded extends HomeState {
  final QuerySnapshot<HouseDetail> houses;

  GetAllHousesLoaded({required this.houses});
}
 
class GetAllHousesLoading extends HomeState {}

class GetAllHouseError extends HomeState {
  final String errorMessage; 
  GetAllHouseError( {required this.errorMessage});
}

class UpLoadMultipleImageLoading extends HomeState {}

class UpLoadMultipleImageError extends HomeState {
  final String errorMessage;
  UpLoadMultipleImageError({required this.errorMessage});
}

class UpLoadMultipleImageLoaded extends HomeState {
  final List<String> imageURL;
  UpLoadMultipleImageLoaded({required this.imageURL});
}

class UpdateHouseLoading extends HomeState {}

class UpdateHouseError extends HomeState {
  final String errorMessage;
  UpdateHouseError({required this.errorMessage});
}

class UpdateHouseLoaded extends HomeState {}

class PlaceSearchLoading extends HomeState {}

class PlaceSearchError extends HomeState {
  final String errorMessage;
  PlaceSearchError({required this.errorMessage});
}

class PlaceSearchLoaded extends HomeState {
  final PlaceSearch placeSearch;

  PlaceSearchLoaded({required this.placeSearch});
}

class GetPlaceByLatLngLoading extends HomeState {}

class GetPlaceByLatLngError extends HomeState {
  final String errorMessage;
  GetPlaceByLatLngError({required this.errorMessage});
}

class GetPlaceByLatLngLoaded extends HomeState {
  final PlaceSearch placeSearch;

  GetPlaceByLatLngLoaded({required this.placeSearch});
}

class AddLocationLoaded extends HomeState {
  final HouseLocation houseLocation;
   AddLocationLoaded({required this.houseLocation});
}


class AddLocationError extends HomeState{
  final String errorMessage;
   AddLocationError({required this.errorMessage});
}

class SendFCMMessageLoaded extends HomeState{

}

class SendFCMMessagesLoading extends HomeState{}

class SendFCMMessageError extends HomeState{
  final String errorMessage;
   SendFCMMessageError({required this.errorMessage});
}