class CurrencyModel {
  final int id;
  final String code;
  final String ccy;
  final String nameRu;
  final String nameUz;
  final String nameUzc;
  final String nameEn;
  final int nominal;
  final double rate;
  final double diff;
  final String date;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.ccy,
    required this.nameRu,
    required this.nameUz,
    required this.nameUzc,
    required this.nameEn,
    required this.nominal,
    required this.rate,
    required this.diff,
    required this.date,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: int.parse(json['id'].toString()),
      code: json['Code'],
      ccy: json['Ccy'],
      nameRu: json['CcyNm_RU'],
      nameUz: json['CcyNm_UZ'],
      nameUzc: json['CcyNm_UZC'],
      nameEn: json['CcyNm_EN'],
      nominal: int.parse(json['Nominal']),
      rate: double.parse(json['Rate']),
      diff: double.parse(json['Diff']),
      date: json['Date'],
    );
  }
}
