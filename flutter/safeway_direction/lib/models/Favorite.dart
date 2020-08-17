class Favorite {
  int id;
  int icon;

  String description;
  String text;
  String mainText;

  double longitude;
  double latitude;
  
  Favorite({ this.id, this.description, this.text, this.longitude, this.latitude,this.mainText, this.icon });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'text': text,
      'longitude': longitude,
      'latitude': latitude,
      'mainText' : mainText,
      'icon': icon
    };
  }
}