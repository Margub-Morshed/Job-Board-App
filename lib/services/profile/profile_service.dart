import '../../utils/utils.dart';

class ProfileService {
  static Future<void> updateProfile(dynamic model) async {
    try {
      if (model.id != null) {
        print("Model ID: " + model.id);
        await Utils.jobSeekersRef.doc(model.id).update(model.toMap());
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
