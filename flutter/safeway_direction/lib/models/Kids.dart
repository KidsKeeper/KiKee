class Kids {
  int id;
  int kidsId;

  String key;

  Kids({ this.id, this.kidsId, this.key });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'kidsId': kidsId,
      'key': key
    };
  }
}