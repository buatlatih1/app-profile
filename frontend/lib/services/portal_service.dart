import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/menu_model.dart';
import '../models/setting_model.dart';
import '../models/slide_model.dart';

class PortalService {
  final ApiClient apiClient;

  PortalService(this.apiClient);

  Future<List<SlideModel>> getSlides() async {
    final response = await apiClient.get(ApiConstants.slides);

    if (response is Map<String, dynamic> && response['data'] is List) {
      return (response['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => SlideModel.fromJson(item))
          .toList();
    }

    return [];
  }

  Future<SettingModel> getSettings() async {
    final response = await apiClient.get(ApiConstants.settings);

    if (response is Map<String, dynamic> && response['data'] is Map<String, dynamic>) {
      return SettingModel.fromJson(response['data'] as Map<String, dynamic>);
    }

    return SettingModel.fromJson({});
  }

  Future<MenuModel?> getMenu(String location) async {
    try {
      final response = await apiClient.get('${ApiConstants.menus}/$location');

      if (response is Map<String, dynamic> && response['data'] is Map<String, dynamic>) {
        return MenuModel.fromJson(response['data'] as Map<String, dynamic>);
      }
    } catch (_) {
      // Return null if menu location not configured yet
    }
    return null;
  }
}

