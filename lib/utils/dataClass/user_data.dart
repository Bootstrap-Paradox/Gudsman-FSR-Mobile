class UserDetails {
  static late String userId;
  static late String name;
  static late String email;
  static late String phone;
  static late dynamic userData;

  factory UserDetails() => UserDetails._internal();
  UserDetails._internal();

  static void setUserDetails(dynamic userData) {
    UserDetails.userId = userData['user_id'];
    UserDetails.name = userData['name'];
    // UserDetails.email = email;
    // UserDetails.phone = phone;
    UserDetails.userData = userData;
  }
}
