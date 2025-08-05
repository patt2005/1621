import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tshirt_provider.dart';
import '../models/tshirt_models.dart';

class TextEditorScreen extends StatefulWidget {
  const TextEditorScreen({super.key});

  @override
  State<TextEditorScreen> createState() => _TextEditorScreenState();
}

class _TextEditorScreenState extends State<TextEditorScreen> {
  final TextEditingController _textController = TextEditingController();
  String _selectedFont = 'Roboto';
  Color _textColor = Colors.black;
  double _textSize = 46;
  double _lineThickness = 4;
  bool _shadowEnabled = false;
  bool _circuitEnabled = false;
  String _alignment = 'Center';
  bool _allCaps = false;
  bool _mixedCase = false;
  double _textRotation = 0.0; // Rotation in radians
  double _textScale = 1.0; // Scale factor
  final List<Map<String, dynamic>> _undoStack = []; // For undo functionality
  double _containerLeft = 80; // X position of text container
  double _containerTop = 120; // Y position of text container
  double _containerWidth = 200; // Width of text container
  double _containerHeight = 80; // Height of text container

  final List<String> _fonts = [
    'Roboto',
    'Comic',
    'Blinker',
    'CINZEL',
    'Courier',
  ];
  final List<Color> _presetColors = [
    const Color(0xFFFFB347), // Yellow
    Colors.red,
    Colors.green,
    Colors.cyan,
    Colors.blue,
    Colors.purple,
    Colors.lime,
    Colors.orange,
    Colors.pink,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // T-Shirt Display Area
            Expanded(
              flex: 2,
              child: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    // T-Shirt Image
                    Center(
                      child: Image.asset(
                        'images/front.png',
                        fit: BoxFit.fitHeight,
                        height: 400,
                      ),
                    ),
                    // Draggable Text Box
                    Positioned(
                      left: _containerLeft,
                      top: _containerTop,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            _containerLeft = (_containerLeft + details.delta.dx)
                                .clamp(0.0, 400.0 - _containerWidth);
                            _containerTop = (_containerTop + details.delta.dy)
                                .clamp(0.0, 300.0 - _containerHeight);
                          });
                        },
                        child: Container(
                          width: _containerWidth,
                          height: _containerHeight,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Corner handles
                              ..._buildCornerHandles(),
                              // Control buttons
                              Positioned(
                                bottom: -35,
                                left: 20,
                                child: Row(
                                  children: [
                                    _buildFunctionalControlButton(
                                      Icons.refresh,
                                      Colors.grey,
                                      _rotateText,
                                    ),
                                    const SizedBox(width: 12),
                                    _buildFunctionalControlButton(
                                      Icons.delete,
                                      Colors.red,
                                      _deleteText,
                                    ),
                                  ],
                                ),
                              ),
                              // Text content
                              Align(
                                alignment: _getAlignment(),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Transform.rotate(
                                    angle: _textRotation,
                                    child: Transform.scale(
                                      scale: _textScale,
                                      child: Stack(
                                        children: [
                                          // Circuit/outline effect
                                          if (_circuitEnabled)
                                            Text(
                                              _textController.text.isEmpty
                                                  ? 'Sample Text'
                                                  : _getDisplayText(),
                                              style: TextStyle(
                                                fontFamily: _selectedFont,
                                                fontSize: _textSize * 0.4,
                                                foreground:
                                                    Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth =
                                                          _lineThickness
                                                      ..color = _textColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: _getTextAlign(),
                                            ),
                                          // Shadow effect
                                          if (_shadowEnabled)
                                            Transform.translate(
                                              offset: const Offset(2, 2),
                                              child: Text(
                                                _textController.text.isEmpty
                                                    ? 'Sample Text'
                                                    : _getDisplayText(),
                                                style: TextStyle(
                                                  fontFamily: _selectedFont,
                                                  fontSize: _textSize * 0.4,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                textAlign: _getTextAlign(),
                                              ),
                                            ),
                                          // Main text
                                          Text(
                                            _textController.text.isEmpty
                                                ? 'Sample Text'
                                                : _getDisplayText(),
                                            style: TextStyle(
                                              fontFamily: _selectedFont,
                                              fontSize: _textSize * 0.4,
                                              color:
                                                  _circuitEnabled
                                                      ? Colors.transparent
                                                      : _textColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: _getTextAlign(),
                                          ),
                                          // Fill for circuit effect
                                          if (_circuitEnabled)
                                            Text(
                                              _textController.text.isEmpty
                                                  ? 'Sample Text'
                                                  : _getDisplayText(),
                                              style: TextStyle(
                                                fontFamily: _selectedFont,
                                                fontSize: _textSize * 0.4,
                                                color: _textColor.withOpacity(
                                                  0.7,
                                                ),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              textAlign: _getTextAlign(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Controls Panel
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text Input
                      TextField(
                        controller: _textController,
                        onChanged: (value) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Enter your text...',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Font Selection
                      const Text(
                        'Selecting a font',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              _fonts
                                  .map((font) => _buildFontChip(font))
                                  .toList(),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Text Color
                      const Text(
                        'Text color',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children:
                            _presetColors
                                .map((color) => _buildColorChip(color))
                                .toList(),
                      ),
                      const SizedBox(height: 12),

                      // Custom Color Picker
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _showColorPicker,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const SweepGradient(
                                  colors: [
                                    Colors.red,
                                    Colors.orange,
                                    Colors.yellow,
                                    Colors.green,
                                    Colors.cyan,
                                    Colors.blue,
                                    Colors.purple,
                                    Colors.red,
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: CircleAvatar(
                                  radius: 2,
                                  backgroundColor: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Custom color',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '#${((_textColor.r * 255).round() << 16 | (_textColor.g * 255).round() << 8 | (_textColor.b * 255).round()).toRadixString(16).padLeft(6, '0').toUpperCase()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Text Size
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Text size',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            '${_textSize.round()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _textSize,
                        min: 10,
                        max: 100,
                        divisions: 90,
                        onChanged: (value) => setState(() => _textSize = value),
                        activeColor: const Color(0xFFFFB347),
                        inactiveColor: Colors.grey[300],
                      ),

                      // Line Thickness
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Line thickness',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          Text(
                            '${_lineThickness.round()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: _lineThickness,
                        min: 1,
                        max: 8,
                        divisions: 7,
                        onChanged:
                            (value) => setState(() => _lineThickness = value),
                        activeColor: const Color(0xFFFFB347),
                        inactiveColor: Colors.grey[300],
                      ),

                      // Toggles
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Text(
                                  'Shadow',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const Spacer(),
                                Switch(
                                  value: _shadowEnabled,
                                  onChanged:
                                      (value) => setState(
                                        () => _shadowEnabled = value,
                                      ),
                                  activeColor: const Color(0xFFFFB347),
                                  activeTrackColor: const Color(
                                    0xFFFFB347,
                                  ).withOpacity(0.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Text(
                                  'Circuit',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const Spacer(),
                                Switch(
                                  value: _circuitEnabled,
                                  onChanged:
                                      (value) => setState(
                                        () => _circuitEnabled = value,
                                      ),
                                  activeColor: const Color(0xFFFFB347),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Alignment
                      const Text(
                        'Alignment',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildAlignmentButton('Left'),
                          const SizedBox(width: 8),
                          _buildAlignmentButton('Center'),
                          const SizedBox(width: 8),
                          _buildAlignmentButton('Right'),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Additional Functions
                      const Text(
                        'Additional functions',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildFunctionButton('All caps', _allCaps, () {
                            setState(() {
                              _allCaps = !_allCaps;
                              if (_allCaps) _mixedCase = false;
                            });
                          }),
                          const SizedBox(width: 8),
                          _buildFunctionButton('Mixed Case', _mixedCase, () {
                            setState(() {
                              _mixedCase = !_mixedCase;
                              if (_mixedCase) _allCaps = false;
                            });
                          }),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Action Buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                final provider = Provider.of<TShirtProvider>(
                                  context,
                                  listen: false,
                                );
                                final element = TShirtElement(
                                  text: _textController.text,
                                  x: _containerLeft,
                                  y: _containerTop,
                                  width: _containerWidth,
                                  height: _containerHeight,
                                  fontFamily: _selectedFont,
                                  fontSize: _textSize,
                                  textColor: _textColor,
                                  rotation: _textRotation,
                                  scale: _textScale,
                                  shadowEnabled: _shadowEnabled,
                                  circuitEnabled: _circuitEnabled,
                                  alignment: _alignment,
                                  allCaps: _allCaps,
                                  mixedCase: _mixedCase,
                                  lineThickness: _lineThickness,
                                );
                                provider.addElement(element);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB347),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: _resetForm,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFFFB347),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey[400]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCornerHandles() {
    return [
      // Top-left
      Positioned(
        top: -4,
        left: -4,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              double newWidth = _containerWidth - details.delta.dx;
              double newHeight = _containerHeight - details.delta.dy;
              if (newWidth > 50 && newHeight > 30) {
                _containerLeft += details.delta.dx;
                _containerTop += details.delta.dy;
                _containerWidth = newWidth;
                _containerHeight = newHeight;
              }
            });
          },
          child: const _CornerHandle(),
        ),
      ),
      // Top-right
      Positioned(
        top: -4,
        right: -4,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              double newWidth = _containerWidth + details.delta.dx;
              double newHeight = _containerHeight - details.delta.dy;
              if (newWidth > 50 && newHeight > 30) {
                _containerTop += details.delta.dy;
                _containerWidth = newWidth;
                _containerHeight = newHeight;
              }
            });
          },
          child: const _CornerHandle(),
        ),
      ),
      // Bottom-left
      Positioned(
        bottom: -4,
        left: -4,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              double newWidth = _containerWidth - details.delta.dx;
              double newHeight = _containerHeight + details.delta.dy;
              if (newWidth > 50 && newHeight > 30) {
                _containerLeft += details.delta.dx;
                _containerWidth = newWidth;
                _containerHeight = newHeight;
              }
            });
          },
          child: const _CornerHandle(),
        ),
      ),
      // Bottom-right
      Positioned(
        bottom: -4,
        right: -4,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              double newWidth = _containerWidth + details.delta.dx;
              double newHeight = _containerHeight + details.delta.dy;
              if (newWidth > 50 && newHeight > 30) {
                _containerWidth = newWidth;
                _containerHeight = newHeight;
              }
            });
          },
          child: const _CornerHandle(),
        ),
      ),
    ];
  }

  Widget _buildControlButton(IconData icon, Color color) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Icon(icon, color: color, size: 16),
    );
  }

  Widget _buildFunctionalControlButton(
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color == Colors.red ? Colors.red : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: color == Colors.red ? Colors.red : Colors.grey[400]!,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color == Colors.red ? Colors.white : Colors.grey[700],
          size: 18,
        ),
      ),
    );
  }

  Widget _buildFontChip(String font) {
    final isSelected = font == _selectedFont;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(font),
        selected: isSelected,
        onSelected: (selected) {
          setState(() => _selectedFont = font);
        },
        selectedColor: Colors.grey[300],
        backgroundColor: Colors.grey[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : Colors.grey[600],
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Widget _buildColorChip(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _textColor = color),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _textColor == color ? Colors.black : Colors.grey[300]!,
            width: _textColor == color ? 2 : 1,
          ),
        ),
      ),
    );
  }

  Widget _buildAlignmentButton(String alignment) {
    final isSelected = alignment == _alignment;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _alignment = alignment),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFB347) : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              alignment,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionButton(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? Colors.grey[300] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[600],
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    String text = _textController.text;
    if (_allCaps) {
      return text.toUpperCase();
    } else if (_mixedCase) {
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

  TextAlign _getTextAlign() {
    switch (_alignment) {
      case 'Left':
        return TextAlign.left;
      case 'Right':
        return TextAlign.right;
      default:
        return TextAlign.center;
    }
  }

  Alignment _getAlignment() {
    switch (_alignment) {
      case 'Left':
        return Alignment.centerLeft;
      case 'Right':
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  void _resetForm() {
    setState(() {
      _textController.clear();
      _selectedFont = 'Roboto';
      _textColor = Colors.black;
      _textSize = 46;
      _lineThickness = 4;
      _shadowEnabled = false;
      _circuitEnabled = false;
      _alignment = 'Center';
      _allCaps = false;
      _mixedCase = false;
      _textRotation = 0.0;
      _textScale = 1.0;
      _containerLeft = 80;
      _containerTop = 120;
      _containerWidth = 200;
      _containerHeight = 80;
      _undoStack.clear();
    });
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Choose Color',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: 300,
              child: GridView.count(
                crossAxisCount: 6,
                shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: _buildColorPalette(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontFamily: 'Roboto', color: Colors.grey),
                ),
              ),
            ],
          ),
    );
  }

  List<Widget> _buildColorPalette() {
    final colors = [
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
      const Color(0xFF039BE5),
      const Color(0xFF00ACC1),
      const Color(0xFF00897B),
      const Color(0xFF43A047),
      const Color(0xFF7CB342),
      const Color(0xFFC0CA33),
      const Color(0xFFFFB300),
      const Color(0xFFFF8F00),
      const Color(0xFFFF6F00),
      const Color(0xFFE53935),
      const Color(0xFFD81B60),
      const Color(0xFF8E24AA),
    ];

    return colors
        .map(
          (color) => GestureDetector(
            onTap: () {
              setState(() {
                _textColor = color;
              });
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      _textColor == color
                          ? const Color(0xFFFFB347)
                          : Colors.grey[300]!,
                  width: _textColor == color ? 3 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child:
                  _textColor == color
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
            ),
          ),
        )
        .toList();
  }

  void _saveState() {
    _undoStack.add({
      'text': _textController.text,
      'font': _selectedFont,
      'color': _textColor,
      'size': _textSize,
      'thickness': _lineThickness,
      'shadow': _shadowEnabled,
      'circuit': _circuitEnabled,
      'alignment': _alignment,
      'allCaps': _allCaps,
      'mixedCase': _mixedCase,
      'rotation': _textRotation,
      'scale': _textScale,
      'containerLeft': _containerLeft,
      'containerTop': _containerTop,
      'containerWidth': _containerWidth,
      'containerHeight': _containerHeight,
    });
    if (_undoStack.length > 10) {
      _undoStack.removeAt(0); // Keep only last 10 states
    }
  }

  void _rotateText() {
    _saveState();
    setState(() {
      _textRotation += 0.785398; // 45 degrees in radians
      if (_textRotation >= 6.283185) {
        // 360 degrees
        _textRotation = 0.0;
      }
    });
  }

  void _scaleText() {
    _saveState();
    setState(() {
      _textScale += 0.2;
      if (_textScale > 2.0) {
        _textScale = 0.6; // Reset to smaller size
      }
    });
  }

  void _deleteText() {
    _saveState();
    setState(() {
      _textController.clear();
      _textRotation = 0.0;
      _textScale = 1.0;
      _containerLeft = 80;
      _containerTop = 120;
      _containerWidth = 200;
      _containerHeight = 80;
    });
  }

  void _undoAction() {
    if (_undoStack.isNotEmpty) {
      final lastState = _undoStack.removeLast();
      setState(() {
        _textController.text = lastState['text'];
        _selectedFont = lastState['font'];
        _textColor = lastState['color'];
        _textSize = lastState['size'];
        _lineThickness = lastState['thickness'];
        _shadowEnabled = lastState['shadow'];
        _circuitEnabled = lastState['circuit'];
        _alignment = lastState['alignment'];
        _allCaps = lastState['allCaps'];
        _mixedCase = lastState['mixedCase'];
        _textRotation = lastState['rotation'];
        _textScale = lastState['scale'];
        _containerLeft = lastState['containerLeft'];
        _containerTop = lastState['containerTop'];
        _containerWidth = lastState['containerWidth'];
        _containerHeight = lastState['containerHeight'];
      });
    }
  }
}

class _CornerHandle extends StatelessWidget {
  const _CornerHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[400]!),
        shape: BoxShape.rectangle,
      ),
    );
  }
}
