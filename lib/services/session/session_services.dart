import 'package:job_board_app/model/user_model.dart';

import '../../model/company_model.dart';
import '../../model/super_admin_model.dart';
import '../login_session/login_session.dart';

class SessionManager {
  static CompanyModel? _companyModel; // Change this to Company if needed
  static UserModel? _userModel; // Change this to UserModel if needed
  static SuperAdminModel? _superAdminModel; // Change this to SuperAdminModel if needed

  static List<String> _appliedJobPostIds = [];

  static CompanyModel? get companyModel => _companyModel;

  static UserModel? get userModel => _userModel;

  static SuperAdminModel? get superAdminModel => _superAdminModel;

  static List<String> get appliedJobPostIds => _appliedJobPostIds;

  static setCompanyModel(CompanyModel companyModel) {
    _companyModel = companyModel;
    LoginSession.saveSessionData(companyModel.role);
    print(LoginSession.getRole());
  }

  static setUserModel(UserModel userModel) {
    _userModel = userModel;
    LoginSession.saveSessionData(userModel.role);
    print(LoginSession.getRole());
  }

  static setSuperAdminModel(SuperAdminModel superAdminModel) {
    _superAdminModel = superAdminModel;
    LoginSession.saveSessionData(superAdminModel.role);
    print(LoginSession.getRole());
  }

  static void resetCompanyModel() {
    _companyModel = null;
  }

  static void resetUserModel() {
    _userModel = null;
  }

  static void resetSuperAdminModel() {
    _superAdminModel = null;
  }

  static void resetAllModels() {
    _companyModel = null;
    _userModel = null;
    _superAdminModel = null;
  }

  static void addAppliedJobPostId(String jobId) {
    _appliedJobPostIds.add(jobId);
  }

  static void removeAppliedJobPostId(String jobId) {
    _appliedJobPostIds.remove(jobId);
  }

  static bool hasAppliedToJobPost(String jobId) {
    return _appliedJobPostIds.contains(jobId);
  }
}
