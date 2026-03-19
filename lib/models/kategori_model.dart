class KategoriModel {
  String? id;
  String name;

  KategoriModel({this.id, required this.name});

  Map<String, dynamic> toMap() {
    return {'idKategori': id, 'nama': name};
  }
}
