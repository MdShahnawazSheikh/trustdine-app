void main() {
  List l1 = [123.0, 124.1, 125.2];
  String str = l1.join(",");
  double d1 = double.parse((str.split(","))[2]);
  print(d1);
}
