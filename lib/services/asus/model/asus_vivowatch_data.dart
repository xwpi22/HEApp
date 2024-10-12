class ASUSVivowatchData {
  final String deviceId;
  final Map<String, dynamic> latestHb;
  final Map<String, dynamic> latestBp;
  final Map<String, dynamic> latestSpO2;
  final Map<String, dynamic> latestStep;

  ASUSVivowatchData({
    required this.deviceId,
    required this.latestHb,
    required this.latestBp,
    required this.latestSpO2,
    required this.latestStep,
  });

  factory ASUSVivowatchData.fromJson(Map<String, dynamic> json) {
    return ASUSVivowatchData(
      deviceId: json['deviceId'],
      latestHb: json['latestHb'],
      latestBp: json['latestBp'],
      latestSpO2: json['latestSpO2'],
      latestStep: json['latestStep'],
    );
  }
}
