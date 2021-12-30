class TraineesRequestsModel {
  String? traineename, traineeemail, traineephone;
  bool? isAccepted;
  TraineesRequestsModel({
    required this.traineename,
    required this.traineeemail,
    required this.traineephone,
    required this.isAccepted,
  });
  TraineesRequestsModel.fromJson(Map<String, dynamic> json) {
    traineename = json['traineename'];
    traineeemail = json['traineeemail'];
    traineephone = json['traineephone'];
    isAccepted = json['accepted'];
  }
  Map<String, dynamic> toMap() => {
        'traineename': traineename,
        'traineeemail': traineeemail,
        'traineephone': traineephone,
        'accepted': isAccepted,
      };
}
