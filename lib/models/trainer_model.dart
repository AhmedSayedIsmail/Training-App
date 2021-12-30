class TrainerModel {
  String? name, email, location, pic, price, uid;
  bool? isTrainer;
  TrainerModel(
      {required this.name,
      required this.email,
      required this.location,
      required this.pic,
      required this.price,
      required this.uid,
      required this.isTrainer});
  TrainerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    location = json['location'];
    pic = json['image'];
    price = json['price'];
    uid = json['uid'];
    isTrainer = json['istrainer'];
  }
  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'location': location,
        'image': pic,
        'price': price,
        'uid': uid,
        'istrainer': isTrainer,
      };
}
