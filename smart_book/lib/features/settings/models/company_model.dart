class CompanyModel {
  String nameAr;
  String nameEn;
  String taxNumber;
  String address;
  String phone;
  String? logoPath;

  CompanyModel({
    required this.nameAr,
    required this.nameEn,
    required this.taxNumber,
    required this.address,
    required this.phone,
    this.logoPath,
  });
}