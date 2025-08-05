import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'text_editor_screen.dart';
import 'sticker_gallery_screen.dart';
import 'image_picker_screen.dart';
import 'providers/tshirt_provider.dart';
import 'models/tshirt_models.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  TextAlign _getTextAlign(String alignment) {
    switch (alignment) {
      case 'Left':
        return TextAlign.left;
      case 'Right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        final provider = Provider.of<TShirtProvider>(context, listen: false);
        provider.setCurrentView(_tabController.index == 0 ? 'Front' : 'Back');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showDesignOptions(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildDesignOption(
                        emoji: '🎨',
                        label: 'New design',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Implement new design
                        },
                      ),
                      _buildDesignOption(
                        emoji: '📁',
                        label: 'My designs',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Implement my designs
                        },
                      ),
                      _buildDesignOption(
                        emoji: '✏️',
                        label: 'Add text',
                        onTap: () {
                          Navigator.pop(context);
                          _addText(context);
                        },
                      ),
                      _buildDesignOption(
                        emoji: '🖼️',
                        label: 'Add image',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImagePickerScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDesignOption(
                        emoji: '😀',
                        label: 'Add stickers',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const StickerGalleryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDesignOption(
                        emoji: '💾',
                        label: 'Save design',
                        onTap: () {
                          Navigator.pop(context);
                          _save();
                        },
                      ),
                      _buildDesignOption(
                        emoji: '⚙️',
                        label: 'Settings',
                        onTap: () {
                          Navigator.pop(context);
                          // TODO: Implement settings
                        },
                      ),
                      _buildDesignOption(
                        emoji: '🎯',
                        label: 'Sticker Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const StickerGalleryScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildDesignOption({
    required String emoji,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[800]!, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDesignOptions(context),
        backgroundColor: Colors.black,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[800]!, width: 2),
          ),
          child: const Icon(Icons.add, color: Color(0xFFFFB347), size: 32),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: const Color(0xFFFFB347),
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                ),
                tabs: const [Tab(text: 'Front'), Tab(text: 'Back')],
              ),
            ),
            // T-Shirt Display
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Front View
                  _buildTShirtView('images/front.png'),
                  // Back View
                  _buildTShirtView('images/back.png'),
                ],
              ),
            ),
            // Bottom Controls
            _buildBottomControls(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTShirtView(String imagePath) {
    return Consumer<TShirtProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Center(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),
              ),
              // Design elements
              for (var element in provider.currentElements)
                Positioned(
                  left: element.x,
                  top: element.y,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        element.x += details.delta.dx;
                        element.y += details.delta.dy;
                      });
                      provider.notifyListeners();
                    },
                    child:
                        element.imagePath != null
                            ? SizedBox(
                              width: element.width,
                              height: element.height,
                              child: Transform.rotate(
                                angle: element.rotation,
                                child: Opacity(
                                  opacity: element.textColor.opacity,
                                  child: Image.file(
                                    File(element.imagePath!),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            )
                            : SizedBox(
                              width: element.width,
                              height: element.height,
                              child: Transform.rotate(
                                angle: element.rotation,
                                child: Transform.scale(
                                  scale: element.scale,
                                  child: Stack(
                                    children: [
                                      if (element.circuitEnabled)
                                        Text(
                                          element.text ?? '',
                                          style: TextStyle(
                                            fontFamily: element.fontFamily,
                                            fontSize: element.fontSize,
                                            foreground:
                                                Paint()
                                                  ..style = PaintingStyle.stroke
                                                  ..strokeWidth =
                                                      element.lineThickness
                                                  ..color = element.textColor,
                                          ),
                                          textAlign: _getTextAlign(
                                            element.alignment,
                                          ),
                                        ),
                                      if (element.shadowEnabled)
                                        Transform.translate(
                                          offset: const Offset(2, 2),
                                          child: Text(
                                            element.text ?? '',
                                            style: TextStyle(
                                              fontFamily: element.fontFamily,
                                              fontSize: element.fontSize,
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                            textAlign: _getTextAlign(
                                              element.alignment,
                                            ),
                                          ),
                                        ),
                                      Text(
                                        element.text ?? '',
                                        style: TextStyle(
                                          fontFamily: element.fontFamily,
                                          fontSize: element.fontSize,
                                          color:
                                              element.circuitEnabled
                                                  ? Colors.transparent
                                                  : element.textColor,
                                        ),
                                        textAlign: _getTextAlign(
                                          element.alignment,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                  ),
                ),
              Positioned(
                bottom: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => _showDesignOptions(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add, color: Colors.black, size: 24),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Plus button in bottom right corner
  }
}

TextAlign _getTextAlign(String alignment) {
  switch (alignment) {
    case 'Left':
      return TextAlign.left;
    case 'Right':
      return TextAlign.right;
    default:
      return TextAlign.center;
  }
}

Widget _buildElement(TShirtElement element, BuildContext context) {
  return Positioned(
    left: element.x,
    top: element.y,
    child: GestureDetector(
      onPanUpdate: (details) {
        final provider = Provider.of<TShirtProvider>(context, listen: false);
        // Update position through the provider
        element.x = (element.x + details.delta.dx).clamp(
          0.0,
          MediaQuery.of(context).size.width - element.width,
        );
        element.y = (element.y + details.delta.dy).clamp(
          0.0,
          MediaQuery.of(context).size.height - element.height,
        );
        // Notify listeners to rebuild
        provider.updateElement(
          provider.currentElements.indexOf(element),
          element,
        );
      },
      child:
          element.imagePath != null
              ? SizedBox(
                width: element.width,
                height: element.height,
                child: Transform.rotate(
                  angle: element.rotation,
                  child: Opacity(
                    opacity: element.textColor.opacity,
                    child: Image.file(
                      File(element.imagePath!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
              : SizedBox(
                width: element.width,
                height: element.height,
                child: Transform.rotate(
                  angle: element.rotation,
                  child: Transform.scale(
                    scale: element.scale,
                    child: Stack(
                      children: [
                        if (element.circuitEnabled)
                          Text(
                            element.text ?? '',
                            style: TextStyle(
                              fontFamily: element.fontFamily,
                              fontSize: element.fontSize,
                              foreground:
                                  Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = element.lineThickness
                                    ..color = element.textColor,
                            ),
                            textAlign: _getTextAlign(element.alignment),
                          ),
                        if (element.shadowEnabled)
                          Transform.translate(
                            offset: const Offset(2, 2),
                            child: Text(
                              element.text ?? '',
                              style: TextStyle(
                                fontFamily: element.fontFamily,
                                fontSize: element.fontSize,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              textAlign: _getTextAlign(element.alignment),
                            ),
                          ),
                        Text(
                          element.text ?? '',
                          style: TextStyle(
                            fontFamily: element.fontFamily,
                            fontSize: element.fontSize,
                            color:
                                element.circuitEnabled
                                    ? Colors.transparent
                                    : element.textColor,
                          ),
                          textAlign: _getTextAlign(element.alignment),
                        ),
                        if (element.circuitEnabled)
                          Text(
                            element.text ?? '',
                            style: TextStyle(
                              fontFamily: element.fontFamily,
                              fontSize: element.fontSize,
                              color: element.textColor.withOpacity(0.7),
                            ),
                            textAlign: _getTextAlign(element.alignment),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
    ),
  );
}

Widget _buildTextElement(TShirtElement element) {
  return Stack(
    children: [
      // Shadow effect
      if (element.shadowEnabled)
        Transform.translate(
          offset: const Offset(2, 2),
          child: Text(
            _getDisplayText(element),
            style: TextStyle(
              fontFamily: element.fontFamily,
              fontSize: element.fontSize * 0.4,
              color: Colors.black.withOpacity(0.3),
              fontWeight: FontWeight.w500,
            ),
            textAlign: _getTextAlign(element.alignment),
          ),
        ),
      // Circuit/outline effect
      if (element.circuitEnabled)
        Text(
          _getDisplayText(element),
          style: TextStyle(
            fontFamily: element.fontFamily,
            fontSize: element.fontSize * 0.4,
            foreground:
                Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = element.lineThickness
                  ..color = element.textColor,
            fontWeight: FontWeight.w500,
          ),
          textAlign: _getTextAlign(element.alignment),
        ),
      // Main text
      Text(
        _getDisplayText(element),
        style: TextStyle(
          fontFamily: element.fontFamily,
          fontSize: element.fontSize * 0.4,
          color:
              element.circuitEnabled ? Colors.transparent : element.textColor,
          fontWeight: FontWeight.w500,
        ),
        textAlign: _getTextAlign(element.alignment),
      ),
      // Fill for circuit effect
      if (element.circuitEnabled)
        Text(
          _getDisplayText(element),
          style: TextStyle(
            fontFamily: element.fontFamily,
            fontSize: element.fontSize * 0.4,
            color: element.textColor.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
          textAlign: _getTextAlign(element.alignment),
        ),
    ],
  );
}

Widget _buildImageElement(TShirtElement element) {
  return Image.asset(
    element.imagePath!,
    width: element.width,
    height: element.height,
    fit: BoxFit.contain,
  );
}

String _getDisplayText(TShirtElement element) {
  String text = element.text ?? '';
  if (element.allCaps) {
    return text.toUpperCase();
  } else if (element.mixedCase) {
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }
  return text;
}

void _undo() {
  // TODO: Implement undo functionality
}

void _redo() {
  // TODO: Implement redo functionality
}

void _addText(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const TextEditorScreen()),
  );
}

void _save() {
  // TODO: Implement save functionality
}

Widget _buildBottomControls(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(24.0),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Color Picker Row
        Consumer<TShirtProvider>(
          builder:
              (context, provider, _) => Row(
                children: [
                  // Color Wheel
                  InkWell(
                    onTap: () => _showColorPicker(context),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: provider.selectedColor,
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Current Color Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current color',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '#${(provider.selectedColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        ),
        const SizedBox(height: 20),
        // Undo/Redo Row
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _undo,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Undo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: _redo,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey[400]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Redo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Add Text Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _addText(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFFFFB347)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Add text',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Save Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFB347),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

void _showColorPicker(BuildContext context) {
  final List<Color> colors = [
    Colors.white,
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.teal,
    Colors.amber,
    Colors.deepOrange,
    Colors.lightBlue,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.brown,
    Colors.grey,
    const Color(0xFF8E24AA),
    const Color(0xFF5E35B1),
    const Color(0xFF3949AB),
    const Color(0xFF1E88E5),
  ];

  showDialog(
    context: context,
    builder:
        (BuildContext dialogContext) => Consumer<TShirtProvider>(
          builder:
              (context, provider, _) => AlertDialog(
                title: const Text(
                  'Choose Color',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 6,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          children: [
                            for (Color color in colors)
                              GestureDetector(
                                onTap: () {
                                  provider.setSelectedColor(color);
                                  Navigator.pop(dialogContext);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          provider.selectedColor == color
                                              ? const Color(0xFFFFB347)
                                              : Colors.grey[300]!,
                                      width:
                                          provider.selectedColor == color
                                              ? 3
                                              : 1,
                                    ),
                                  ),
                                  child:
                                      provider.selectedColor == color
                                          ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 20,
                                          )
                                          : null,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder:
                                  (BuildContext pickerContext) => AlertDialog(
                                    title: const Text('Custom Color'),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: provider.selectedColor,
                                        onColorChanged: (color) {
                                          provider.setSelectedColor(color);
                                        },
                                        showLabel: true,
                                        pickerAreaHeightPercent: 0.8,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(pickerContext),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.color_lens,
                                  color: provider.selectedColor,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '#${(provider.selectedColor.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
        ),
  );
}
