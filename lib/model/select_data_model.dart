class SelectDataModel {
  final int id;
  final String title;
  final String subTitle;
  final dynamic data;

  SelectDataModel({
    required this.id,
    required this.title,
    this.subTitle = "",
    this.data,
  });
  static List<SelectDataModel> listGender = [
    SelectDataModel(id: 0, title: "Male"),
    SelectDataModel(id: 1, title: "Female"),
  ];
  @override
  String toString() {
    return 'SelectDataModel{id=$id, title=$title, subTitle=$subTitle, data=$data}';
  }
}
