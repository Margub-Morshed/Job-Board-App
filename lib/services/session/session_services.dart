import 'package:job_board_app/model/user_model.dart';

import '../../model/company_model.dart';
import '../../model/super_admin_model.dart';

class SessionManager {
  static CompanyModel? _companyModel; // Change this to Company if needed
  static UserModel? _userModel; // Change this to UserModel if needed
  static SuperAdminModel? _superAdminModel; // Change this to SuperAdminModel if needed

  static CompanyModel? get companyModel => _companyModel;

  static UserModel? get userModel => _userModel;

  static SuperAdminModel? get superAdminModel => _superAdminModel;

  static setCompanyModel(CompanyModel companyModel) {
    _companyModel = companyModel;
  }

  static setUserModel(UserModel userModel) {
    _userModel = userModel;
  }

  static setSuperAdminModel(SuperAdminModel superAdminModel) {
    _superAdminModel = superAdminModel;
  }
}
