int calcAge(DateTime bd){
  final DateTime td = DateTime.now();
  return (td.year-bd.year)+(((td.day-bd.day)>=0 && (td.month-bd.month)>=0)?0:-1);
}
void main(){
  // log(Convertors.toSHA256("Hello"));
  calcAge(DateTime(2003, 1, 3)).toString();
}