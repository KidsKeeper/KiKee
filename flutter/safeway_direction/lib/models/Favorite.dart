class Favorite {
  final int id;
  int icon;

  final String description;
  final String mainText;

  double longitude;
  double latitude;
  
  Favorite({ this.id, this.description, this.longitude, this.latitude,this.mainText, this.icon });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'longitude': longitude,
      'latitude': latitude,
      'mainText' : mainText,
      'icon': icon
    };
  }
}