// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

class PlaceLocation {
  final double longitude;
  final double latitude;
  final String address;

  PlaceLocation({
    this.longitude = 0.0,
    this.latitude = 0.0,
    this.address = '',
  });

  

  PlaceLocation copyWith({
    double? longitude,
    double? latitude,
    String? address,
  }) {
    return PlaceLocation(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'longitude': longitude,
      'latitude': latitude,
      'address': address,
    };
  }

  factory PlaceLocation.fromMap(Map<String, dynamic> map) {
    return PlaceLocation(
      longitude: map['longitude'] as double,
      latitude: map['latitude'] as double,
      address: map['address'] as String,
    );
  }

}

class Place {
  final String id;
  final String title;
  final PlaceLocation? location;
  final File image;

  Place({
    this.id = '',
    this.title = '',
    this.location,
    required this.image,
  });


  Place copyWith({
    String? id,
    String? title,
    PlaceLocation? location,
    File? image,
  }) {
    return Place(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      image: image ?? this.image,
    );
  }

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      id: map['id'] as String,
      title: map['title'] as String,
      location: map['location'] != null ? PlaceLocation.fromMap(map['location'] as Map<String,dynamic>) : null,
      image: File.fromRawPath(map['image']),
    );
  }
}
