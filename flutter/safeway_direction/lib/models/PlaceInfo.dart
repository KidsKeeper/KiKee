class PlaceInfo {
  final int id;

  final String placeId;
  final String description;
  final String mainText;

  double longitude;
  double latitude;

  PlaceInfo( {this.placeId, this.id, this.description, this.longitude, this.latitude,this.mainText });

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'id': id,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'mainText' : mainText
    };
  }
}