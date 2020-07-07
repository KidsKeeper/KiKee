class Place {
  final String placeId;
  final String description;
  final String mainText;
  double longitude;
  double latitude;
  Place({this.placeId, this.description, this.longitude, this.latitude,this.mainText});
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}