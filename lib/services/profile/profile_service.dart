import '../../utils/utils.dart';

class ProfileService {
  static Future<void> updateProfile(dynamic model, String role) async {
    try {
      if (model.id != null) {
        await Utils.getRefPathBasedOnRole(role).doc(model.id).update(model.toMap());
      } else {
        // Handle the case where the model's id is null
        throw Exception('Model id is null');
      }
    } catch (e) {
      // Handle errors
      print("Error updating profile: $e");
      throw e;
    }
  }
}
