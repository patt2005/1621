import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'models/tshirt_models.dart';
import 'providers/tshirt_provider.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  File? _selectedImage;
  final _picker = ImagePicker();
  double _scale = 46.0;
  double _transparency = 0.7; // 70%
  String _proportion = '4:3';
  String _activeFilter = 'Warm';

  final List<String> _proportions = ['1:1', '4:3', 'Free'];
  final List<String> _filters = ['B/W', 'Warm', 'Contrast', 'Cool'];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle any errors here
      debugPrint('Error picking image: $e');
    }
  }

  void _addSelectedImage() {
    if (_selectedImage != null) {
      final provider = Provider.of<TShirtProvider>(context, listen: false);

      // Calculate dimensions based on proportion
      double width = 150.0;
      double height = 150.0;

      if (_proportion == '4:3') {
        height = width * (3 / 4);
      } else if (_proportion == '1:1') {
        height = width;
      }

      // Apply scale
      width =
          width *
          (_scale / 50); // Normalize scale to make 46 close to original size
      height = height * (_scale / 50);

      // Create a new t-shirt element with the image
      final element = TShirtElement(
        imagePath: _selectedImage!.path,
        x: 100, // Center position
        y: 100, // Center position
        width: width,
        height: height,
        scale: _scale / 50, // Store normalized scale
        textColor: Colors.black.withOpacity(
          _transparency,
        ), // Using textColor for opacity
      );

      provider.addElement(element);
      Navigator.pop(context); // Close the image picker screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Image',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child:
                  _selectedImage != null
                      ? Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: ColorFiltered(
                              colorFilter: _getColorFilter(_activeFilter),
                              child: Opacity(
                                opacity: _transparency,
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.contain,
                                  scale:
                                      100 / _scale, // Inverse scale for preview
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedImage = null;
                                });
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                      : Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No image selected',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ),
            ),
          ),
          if (_selectedImage != null)
            Expanded(
              flex: 3,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Scale',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Slider(
                      value: _scale,
                      min: 1,
                      max: 100,
                      onChanged: (value) => setState(() => _scale = value),
                    ),
                    const Text(
                      'Transparency',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    Slider(
                      value: _transparency,
                      min: 0,
                      max: 1,
                      onChanged:
                          (value) => setState(() => _transparency = value),
                    ),
                    const Text(
                      'Proportions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children:
                          _proportions
                              .map(
                                (prop) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ElevatedButton(
                                    onPressed:
                                        () =>
                                            setState(() => _proportion = prop),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _proportion == prop
                                              ? const Color(0xFFFFB347)
                                              : Colors.grey[200],
                                      foregroundColor:
                                          _proportion == prop
                                              ? Colors.black
                                              : Colors.grey[600],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(prop),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children:
                          _filters
                              .map(
                                (filter) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: ElevatedButton(
                                    onPressed:
                                        () => setState(
                                          () => _activeFilter = filter,
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _activeFilter == filter
                                              ? const Color(0xFFFFB347)
                                              : Colors.grey[200],
                                      foregroundColor:
                                          _activeFilter == filter
                                              ? Colors.black
                                              : Colors.grey[600],
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(filter),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(24),
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
                Row(
                  children: [
                    Expanded(
                      child: _buildOptionButton(
                        icon: Icons.photo_library,
                        label: 'Choose from Gallery',
                        onTap: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildOptionButton(
                        icon: Icons.camera_alt,
                        label: 'Take a Photo',
                        onTap: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        _selectedImage != null ? _addSelectedImage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB347),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Add Image',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
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
    );
  }

  ColorFilter _getColorFilter(String filter) {
    switch (filter) {
      case 'B/W':
        return const ColorFilter.matrix([
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0.2126,
          0.7152,
          0.0722,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
      case 'Warm':
        return const ColorFilter.matrix([
          1.2,
          0,
          0,
          0,
          0,
          0,
          1.1,
          0,
          0,
          0,
          0,
          0,
          0.9,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
      case 'Cool':
        return const ColorFilter.matrix([
          0.9,
          0,
          0,
          0,
          0,
          0,
          0.9,
          0,
          0,
          0,
          0,
          0,
          1.2,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ]);
      case 'Contrast':
        return const ColorFilter.matrix([
          1.5,
          0,
          0,
          0,
          -0.1,
          0,
          1.5,
          0,
          0,
          -0.1,
          0,
          0,
          1.5,
          0,
          -0.1,
          0,
          0,
          0,
          1,
          0,
        ]);
      default:
        return const ColorFilter.mode(Colors.transparent, BlendMode.srcOver);
    }
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.grey[700]),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
