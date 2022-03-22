class Segments {
  final String name;
  final String route;
  final bool isDialog;
  final String image;
  final int index;
  final Map<String, dynamic> arguments;
  final String link;

  const Segments({
    this.name,
    this.link,
    this.route,
    this.isDialog = false,
    this.image,
    this.index,
    this.arguments,
  });
}
