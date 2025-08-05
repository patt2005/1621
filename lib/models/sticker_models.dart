class StickerCategory {
  final String name;
  final String icon;
  final List<Sticker> stickers;

  const StickerCategory({
    required this.name,
    required this.icon,
    required this.stickers,
  });
}

class Sticker {
  final String emoji;
  final String? description;

  const Sticker({required this.emoji, this.description});
}
