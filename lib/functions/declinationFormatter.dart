
String declination(int initialNumber, Declination variants){
  if(initialNumber.toString().endsWith("11") || initialNumber.toString().endsWith("12") || initialNumber.toString().endsWith("13") || initialNumber.toString().endsWith("14")){
    return '$initialNumber ${variants.fifth}';
  }
  if(initialNumber.toString().endsWith("1") ) return '$initialNumber ${variants.first}';
  if(initialNumber.toString().endsWith("2") || initialNumber.toString().endsWith("3")|| initialNumber.toString().endsWith("4") ) return '$initialNumber ${variants.second}';
  return "$initialNumber ${variants.fifth}";
}

class Declination{
  /// Если число заканчивается на единицу
  String first;

  /// Если число заканчивается на двойку
  String second;

  /// Если число заканчивается на пять
  String fifth;

  Declination({
    required this.first,
    required this.second,
    required this.fifth,
});

}