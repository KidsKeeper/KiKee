class Place {
  final String placeId;
  final String description;
  final double longitude;
  final double latitude;
  Place({this.placeId, this.description, this.longitude, this.latitude});
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}