import 'package:job_board_app/model/user_model.dart';

import '../../model/company_model.dart';

class SessionManager {
  static CompanyModel? _companyModel; // Change this to UserModel if needed
  static UserModel? _userModel; // Change this to UserModel if needed

  static CompanyModel? get companyModel => _companyModel;

  static UserModel? get userModel => _userModel;

  static setCompanyModel(CompanyModel companyModel) {
    _companyModel = companyModel;
  }

  static setUserModel(UserModel userModel) {
    _userModel = userModel;
  }
}
