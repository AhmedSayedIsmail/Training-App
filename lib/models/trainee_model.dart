class TraineeModel {
  String? name, email, phoneNo, uid;
  bool? isTrainer;
  TraineeModel(
      {required this.name,
      required this.email,
      required this.phoneNo,
      required this.uid,
      required this.isTrainer});
  TraineeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    uid = json['uid'];
    isTrainer = json['isTrainer'];
  }
  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'phoneNo': phoneNo,
        'uid': uid,
        'istrainer': isTrainer,
      };
}
