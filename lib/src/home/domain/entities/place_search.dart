import 'package:equatable/equatable.dart';

class PlaceSearch extends Equatable {
  final List<Result>? results;
  const PlaceSearch({required this.results});

  @override
  List<Object?> get props => [results];
}

class Result extends Equatable {
  final Geometry? geometry;
  final String? formatedAddress;
  final String? name;

  const Result({
    required this.geometry,
    required this.formatedAddress,
    required this.name,
  });

  @override
  List<Object?> get props => [
        geometry,
        formatedAddress,
        name
      ];
}

class Geometry extends Equatable {
  final Location location;

  const Geometry({required this.location});
  @override
  List<Object?> get props => [location];
}

class Location extends Equatable {
  final num? lat, lng;

  const Location({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}
