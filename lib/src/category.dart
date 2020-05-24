import 'dart:ui';
import 'dart:math' as math;

class Category {

  static math.Random rnd = null;

  String name;
  Color color;

  Category(this.name) {
    if (rnd == null) rnd = math.Random();
    color = Color(rnd.nextInt(0xffffffff));
  }

  String toString() => name;

  @override
  bool equals(Object e1, Object e2){
    return (e1 as Category).name == (e2 as Category).name;
  }

}