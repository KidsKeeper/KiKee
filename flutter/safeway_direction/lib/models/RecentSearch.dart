class RecentSearch {
  final int id;

  final String placeId;
  final String description;
  final String mainText;

  double longitude;
  double latitude;

  
  RecentSearch({ this.placeId, this.id, this.description, this.longitude, this.latitude,this.mainText });
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'mainText' : mainText,
    };
  }
}