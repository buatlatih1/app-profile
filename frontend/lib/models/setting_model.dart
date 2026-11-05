import '../core/network/api_client.dart';

class SettingModel {
  final String siteName;
  final String siteTagline;
  final String siteDescription;
  final String? siteLogo;
  final String address;
  final String phone;
  final String email;
  final String? whatsapp;
  final String officeHours;
  final Map<String, String> socialMedia;
  final Map<String, dynamic> raw;

  SettingModel({
    required this.siteName,
    required this.siteTagline,
    required this.siteDescription,
    this.siteLogo,
    required this.address,
    required this.phone,
    required this.email,
    this.whatsapp,
    required this.officeHours,
    this.socialMedia = const {},
    this.raw = const {},
  });

  String? get resolvedLogoUrl => ApiClient.resolveImageUrl(siteLogo);

  factory SettingModel.fromJson(Map<String, dynamic> json) {
    final general = json['general'] is Map<String, dynamic>
        ? json['general'] as Map<String, dynamic>
        : <String, dynamic>{};

    final contact = json['contact'] is Map<String, dynamic>
        ? json['contact'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawSocial = json['social_media'] is Map<String, dynamic>
        ? json['social_media'] as Map<String, dynamic>
        : <String, dynamic>{};

    Map<String, String> social = {};
    rawSocial.forEach((k, v) {
      if (v != null && v.toString().trim().isNotEmpty) {
        social[k] = v.toString();
      }
    });

    return SettingModel(
      siteName: general['site_name']?.toString() ?? 'Portal Resmi Instansi',
      siteTagline: general['site_tagline']?.toString() ??
          'Melayani dengan Integritas, Cepat, dan Akuntabel',
      siteDescription: general['site_description']?.toString() ?? '',
      siteLogo: general['site_logo']?.toString(),
      address: contact['address']?.toString() ??
          'Jl. Protokol Pusat Pemerintahan No. 10',
      phone: contact['phone']?.toString() ?? '(021) 555-0199',
      email: contact['email']?.toString() ?? 'info@instansi.go.id',
      whatsapp: contact['whatsapp']?.toString(),
      officeHours: contact['office_hours']?.toString() ??
          'Senin - Jumat: 08:00 - 16:00 WIB',
      socialMedia: social,
      raw: json,
    );
  }
}

