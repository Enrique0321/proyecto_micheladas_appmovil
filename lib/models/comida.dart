class Comida {
  final int id;
  final String titulo;
  final String cocine;

  Comida({required this.id, required this.titulo, required this.cocine});

  factory Comida.fromJson(Map<String, dynamic> json) {
    return Comida(
      id: json['id'],
      titulo: json['titulo'],
      cocine: json['cocine'],
    );
  }
}
