
class LoginParams {
  final String password;
  final String email;

  LoginParams({required this.password, required this.email});


  Map<String,dynamic> toJson() => {
    "email": email,
    "password": password
  };


}