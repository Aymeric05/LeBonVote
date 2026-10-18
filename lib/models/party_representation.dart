class PartyRepresentation {
  final int deputies; // /577
  final int senators; // /348
  final int euroDeputies; // /81
  final int deptPresidents; // /95
  final int regPresidents; // /17
  final int largeCityMayors; // /288

  const PartyRepresentation({
    required this.deputies,
    required this.senators,
    required this.euroDeputies,
    required this.deptPresidents,
    required this.regPresidents,
    required this.largeCityMayors,
  });

  factory PartyRepresentation.fromMap(Map<String, dynamic> map) {
    return PartyRepresentation(
      deputies: (map['deputies'] as num?)?.toInt() ?? 0,
      senators: (map['senators'] as num?)?.toInt() ?? 0,
      euroDeputies: (map['euroDeputies'] as num?)?.toInt() ?? 0,
      deptPresidents: (map['deptPresidents'] as num?)?.toInt() ?? 0,
      regPresidents: (map['regPresidents'] as num?)?.toInt() ?? 0,
      largeCityMayors: (map['largeCityMayors'] as num?)?.toInt() ?? 0,
    );
  }

  // Totaux institutionnels en France
  static const int totalDeputies = 577;
  static const int totalSenators = 348;
  static const int totalEuroDeputies = 81;
  static const int totalDeptPresidents = 95;
  static const int totalRegPresidents = 17;
  static const int totalLargeCityMayors = 288;
}
