
import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:job_board_app/services/session/session_services.dart';

import '../../model/company_model.dart';
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

  static Future<void> updateProfilePicture(String field, dynamic model,String role,File file) async {

    try{
      //getting image file extension
      final ext = file.path.split('.').last;
      log('Extension: $ext');

      //storage file ref with path
      final ref = Utils.firestorage.ref().child('pictures/$field/${model.id}.$ext');

      //uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
      });

      //updating image in firestore database
      model.logoImage = await ref.getDownloadURL();
      SessionManager.companyModel!.logoImage = model.logoImage;
      await Utils.getRefPathBasedOnRole(role).doc(model.id).update({'logo_image': model.logoImage});
    }catch(e){
      print("Error updating profile: $e");
      throw e;
    }
  }

  static Future<void> updateCompanyStatus(String companyId, CompanyStatus newStatus) async {
    try {
      await Utils.companyAdminsRef.doc(companyId)
          .update({'status': newStatus.index});
    } catch (e) {
      print('Error updating company status: $e');
    }
  }
}
