

class GeneralStates {
  GeneralStates._();

  static GeneralStates get instance => GeneralStates._();

  final Map<dynamic,dynamic> _data = {};

 dynamic get(String key){
    return _data[key];
  }

  dynamic set(String key,dynamic value){
    _data[key] = value;
  }

}