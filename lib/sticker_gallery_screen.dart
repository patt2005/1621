import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/tshirt_models.dart';
import 'models/sticker_models.dart';
import 'providers/tshirt_provider.dart';

class StickerGalleryScreen extends StatefulWidget {
  const StickerGalleryScreen({super.key});

  @override
  State<StickerGalleryScreen> createState() => _StickerGalleryScreenState();
}

class _StickerGalleryScreenState extends State<StickerGalleryScreen> {
  String? _expandedCategory;
  int? _selectedIndex;

  void _toggleCategory(String category) {
    setState(() {
      if (_expandedCategory == category) {
        _expandedCategory = null;
        _selectedIndex = null; // Reset selection when collapsing
      } else {
        _expandedCategory = category;
      }
    });
  }

  void _onStickerSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<StickerCategory> _stickerCategories = [
    StickerCategory(
      name: 'Food',
      icon: '🍔',
      stickers: [
        Sticker(emoji: '🍕', description: 'Pizza'),
        Sticker(emoji: '🍣', description: 'Sushi'),
        Sticker(emoji: '🍩', description: 'Donut'),
        Sticker(emoji: '🍟', description: 'Fries'),
        Sticker(emoji: '🍉', description: 'Watermelon'),
        Sticker(emoji: '🌮', description: 'Taco'),
        Sticker(emoji: '🍦', description: 'Ice Cream'),
        Sticker(emoji: '🍳', description: 'Fried Egg'),
        Sticker(emoji: '🥑', description: 'Avocado'),
      ],
    ),
    StickerCategory(
      name: 'Animals',
      icon: '🐶',
      stickers: [
        Sticker(emoji: '🐶', description: 'Dog'),
        Sticker(emoji: '🐱', description: 'Cat'),
        Sticker(emoji: '🐼', description: 'Panda'),
        Sticker(emoji: '🦁', description: 'Lion'),
        Sticker(emoji: '🐨', description: 'Koala'),
        Sticker(emoji: '🦊', description: 'Fox'),
        Sticker(emoji: '🐯', description: 'Tiger'),
        Sticker(emoji: '🦉', description: 'Owl'),
        Sticker(emoji: '🦋', description: 'Butterfly'),
      ],
    ),
    StickerCategory(
      name: 'Music',
      icon: '🎧',
      stickers: [
        Sticker(emoji: '🎸', description: 'Guitar'),
        Sticker(emoji: '🎹', description: 'Piano'),
        Sticker(emoji: '🎺', description: 'Trumpet'),
        Sticker(emoji: '🥁', description: 'Drum'),
        Sticker(emoji: '🎻', description: 'Violin'),
        Sticker(emoji: '🎼', description: 'Musical Score'),
        Sticker(emoji: '🎵', description: 'Musical Note'),
        Sticker(emoji: '🎧', description: 'Headphones'),
        Sticker(emoji: '🎤', description: 'Microphone'),
      ],
    ),
    StickerCategory(
      name: 'Sports',
      icon: '⚽',
      stickers: [
        Sticker(emoji: '⚽', description: 'Soccer'),
        Sticker(emoji: '🏀', description: 'Basketball'),
        Sticker(emoji: '🏈', description: 'Football'),
        Sticker(emoji: '⚾', description: 'Baseball'),
        Sticker(emoji: '🎾', description: 'Tennis'),
        Sticker(emoji: '🏐', description: 'Volleyball'),
        Sticker(emoji: '🏸', description: 'Badminton'),
        Sticker(emoji: '🎯', description: 'Dart'),
        Sticker(emoji: '⛳', description: 'Golf'),
      ],
    ),
    StickerCategory(
      name: 'Graffiti',
      icon: '🎨',
      stickers: [
        Sticker(emoji: '🎨', description: 'Paint Palette'),
        Sticker(emoji: '🖌️', description: 'Paintbrush'),
        Sticker(emoji: '✨', description: 'Sparkles'),
        Sticker(emoji: '💫', description: 'Dizzy'),
        Sticker(emoji: '💭', description: 'Thought Bubble'),
        Sticker(emoji: '💬', description: 'Speech Bubble'),
        Sticker(emoji: '🔥', description: 'Fire'),
        Sticker(emoji: '⭐', description: 'Star'),
        Sticker(emoji: '💡', description: 'Light Bulb'),
      ],
    ),
    StickerCategory(
      name: 'Nature',
      icon: '🌿',
      stickers: [
        Sticker(emoji: '🌺', description: 'Flower'),
        Sticker(emoji: '🌸', description: 'Cherry Blossom'),
        Sticker(emoji: '🌼', description: 'Daisy'),
        Sticker(emoji: '🌳', description: 'Tree'),
        Sticker(emoji: '🌵', description: 'Cactus'),
        Sticker(emoji: '🍁', description: 'Maple Leaf'),
        Sticker(emoji: '🌙', description: 'Crescent Moon'),
        Sticker(emoji: '☀️', description: 'Sun'),
        Sticker(emoji: '⭐', description: 'Star'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sticker categories:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              // Categories List
              Expanded(
                child: ListView.builder(
                  itemCount: _stickerCategories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = _stickerCategories[categoryIndex];
                    final isExpanded = _expandedCategory == category.name;

                    return Column(
                      children: [
                        // Category Card
                        InkWell(
                          onTap: () => _toggleCategory(category.name),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8E7),
                              borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(8),
                                bottom: Radius.circular(isExpanded ? 0 : 8),
                              ),
                              border: Border.all(
                                color:
                                    isExpanded
                                        ? const Color(0xFFFFB347)
                                        : Colors.transparent,
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  category.icon,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  category.name,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                const Spacer(),
                                Icon(
                                  isExpanded
                                      ? Icons.expand_less
                                      : Icons.expand_more,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Sticker Grid when expanded
                        if (isExpanded) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(8),
                              ),
                              border: Border.all(
                                color: const Color(0xFFFFB347),
                              ),
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1,
                                  ),
                              itemCount: category.stickers.length,
                              itemBuilder: (context, index) {
                                final sticker = category.stickers[index];
                                final isSelected =
                                    _selectedIndex == index &&
                                    _expandedCategory == category.name;

                                return GestureDetector(
                                  onTap: () => _onStickerSelected(index),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? const Color(0xFFFFF8E7)
                                              : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          isSelected
                                              ? Border.all(
                                                color: const Color(0xFFFFB347),
                                                width: 2,
                                              )
                                              : null,
                                    ),
                                    child: Center(
                                      child: Text(
                                        sticker.emoji,
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Add Sticker button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Consumer<TShirtProvider>(
                  builder: (context, provider, child) {
                    final canAddSticker =
                        _selectedIndex != null && _expandedCategory != null;
                    final selectedCategory =
                        canAddSticker
                            ? _stickerCategories.firstWhere(
                              (category) => category.name == _expandedCategory,
                            )
                            : null;

                    return ElevatedButton(
                      onPressed:
                          canAddSticker
                              ? () {
                                final sticker =
                                    selectedCategory!.stickers[_selectedIndex!];
                                final element = TShirtElement(
                                  text: sticker.emoji,
                                  x: 100,
                                  y: 100,
                                  width: 80,
                                  height: 80,
                                  fontSize: 40,
                                );
                                provider.addElement(element);
                                Navigator.of(context).pop();
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            canAddSticker
                                ? const Color(0xFFFFD233)
                                : Colors.grey[300],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Add Sticker',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Back button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
