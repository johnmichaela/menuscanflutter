// pages/menu_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// MODEL
// ============================================================
class FoodItem {
  final int? id;
  final int? profile;
  final String name;
  final String description;
  final String? image; // URL returned from server
  final double price;
  final String currency;
  final double? discountPrice;
  final bool isAvailable;
  final bool isVeg;
  final bool isFeatured;
  final double? rating;
  final int? ratingCount;

  FoodItem({
    this.id,
    this.profile,
    required this.name,
    required this.description,
    this.image,
    required this.price,
    this.currency = 'TZS',
    this.discountPrice,
    this.isAvailable = true,
    this.isVeg = false,
    this.isFeatured = false,
    this.rating,
    this.ratingCount,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      profile: json['profile'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'],
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      currency: json['currency'] ?? 'TZS',
      discountPrice: json['discount_price'] != null
          ? double.tryParse(json['discount_price'].toString())
          : null,
      isAvailable: json['is_available'] ?? true,
      isVeg: json['is_veg'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      ratingCount: json['rating_count'],
    );
  }
}

// ============================================================
// SERVICE
// ============================================================
class MenuService {
  /// Set this after login, e.g. MenuService.authToken = token;
  static String? authToken;

  // static Map<String, String> get _jsonHeaders => {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       if (authToken != null) 'Authorization': 'Token $authToken',
  //     };

  // static Map<String, String> get _authHeaders => {
  //       'Accept': 'application/json',
  //       if (authToken != null) 'Authorization': 'Token $authToken',
  //     };

  /// GET /prof/api/my-menus/
  static Future<List<FoodItem>> fetchMyMenus() async {
     final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/my-menus/');
    final res = await http.get(uri, headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      });

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final List list =
          decoded is List ? decoded : (decoded['results'] ?? []);
          print('Decoded menus: $list');
      return list.map((e) => FoodItem.fromJson(e)).toList();
    }
    throw Exception('Failed to load menus (${res.statusCode}): ${res.body}');
  }

  /// POST /prof/api/menus/create
  /// Sends multipart/form-data so the ImageField works correctly.
  static Future<FoodItem> createMenu(
    FoodItem item, {
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/menus/create');
    final request = http.MultipartRequest('POST', uri);

    if (token != null) {
      request.headers['Authorization'] = 'Token $token';
    }
    request.headers['Accept'] = 'application/json';

    // Text fields — only those that exist on the model
    request.fields['name'] = item.name;
    request.fields['description'] = item.description;
    request.fields['price'] = item.price.toString();
    request.fields['currency'] = item.currency;
    request.fields['is_available'] = item.isAvailable.toString();
    request.fields['is_veg'] = item.isVeg.toString();
    request.fields['is_featured'] = item.isFeatured.toString();

    if (item.discountPrice != null) {
      request.fields['discount_price'] = item.discountPrice!.toString();
    }

    // NOTE: `profile` is set server-side from request.user — do NOT send it.

    // Image file (required as multipart when image is an ImageField)
    if (imageFile != null) {
      final ext = imageFile.path.split('.').last.toLowerCase();
      final mime = (ext == 'png')
          ? 'png'
          : (ext == 'webp')
              ? 'webp'
              : 'jpeg';
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: MediaType('image', mime),
        ),
      );
      print('Added image file to request: ${imageFile.path}');
      print('Request fields: ${request.fields}');
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
     print('Response status: ${res.statusCode}, body: ${res.body}');
    if (res.statusCode == 200 || res.statusCode == 201) {
        print('Menu created successfully: ${res.body}');
      return FoodItem.fromJson(jsonDecode(res.body));
    
    }
    throw Exception(
        'Failed to create menu (${res.statusCode}): ${res.body}');
  }
}

// ============================================================
// PAGE
// ============================================================
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<FoodItem> _menus = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await MenuService.fetchMyMenus();
      setState(() {
        _menus
          ..clear()
          ..addAll(items);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _openCreateSheet() async {
    final created = await showModalBottomSheet<FoodItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MenuFormSheet(),
    );

    if (created != null) {
      setState(() => _menus.insert(0, created));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu created successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Menus'),
        actions: [
          IconButton(onPressed: _loadMenus, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(onRefresh: _loadMenus, child: _buildBody()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Menu'),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: _loadMenus, child: const Text('Retry')),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (_menus.isEmpty) {
      return ListView(
        children: const [
          SizedBox(height: 120),
          Center(child: Text('No menus yet. Tap + to add one.')),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: _menus.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _MenuTile(item: _menus[i]),
    );
  }
}

// ============================================================
// LIST TILE
// ============================================================
class _MenuTile extends StatelessWidget {
  final FoodItem item;
  const _MenuTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (item.image != null && item.image!.isNotEmpty)
                  ? Image.network(
                      item.image!,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholderImg(),
                    )
                  : _placeholderImg(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _vegDot(item.isVeg),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (item.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${item.currency} ${item.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (item.discountPrice != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${item.currency} ${item.discountPrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: item.isAvailable
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item.isAvailable ? 'Available' : 'Unavailable',
                          style: TextStyle(
                            fontSize: 11,
                            color: item.isAvailable
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vegDot(bool isVeg) {
    final color = isVeg ? Colors.green : Colors.red;
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }

  Widget _placeholderImg() => Container(
        width: 72,
        height: 72,
        color: Colors.grey.shade200,
        child: const Icon(Icons.fastfood, color: Colors.grey),
      );
}

// ============================================================
// BOTTOM SHEET FORM
// ============================================================
class MenuFormSheet extends StatefulWidget {
  const MenuFormSheet({super.key});

  @override
  State<MenuFormSheet> createState() => _MenuFormSheetState();
}

class _MenuFormSheetState extends State<MenuFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();

  String _currency = 'TZS';
  bool _isAvailable = true;
  bool _isVeg = false;
  bool _isFeatured = false;
  bool _submitting = false;

  File? _imageFile;

  static const _currencies = ['TZS', 'USD', 'EUR', 'KES'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final item = FoodItem(
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      currency: _currency,
      discountPrice: _discountCtrl.text.trim().isEmpty
          ? null
          : double.tryParse(_discountCtrl.text.trim()),
      isAvailable: _isAvailable,
      isVeg: _isVeg,
      isFeatured: _isFeatured,
    );

    try {
      final created = await MenuService.createMenu(item, imageFile: _imageFile);
      if (!mounted) return;
      Navigator.of(context).pop(created);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add New Menu',
                  style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // -------- Image picker --------
                GestureDetector(
                  onTap: _showImagePickerOptions,
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_imageFile!,
                                fit: BoxFit.cover, width: double.infinity),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo,
                                  size: 36, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Tap to add image',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                  ),
                ),
                if (_imageFile != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => setState(() => _imageFile = null),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Remove image'),
                    ),
                  ),
                const SizedBox(height: 12),

                // -------- Fields --------
                _tf(_nameCtrl, 'Name *', validator: _required),
                const SizedBox(height: 12),

                _tf(_descCtrl, 'Description',
                    maxLines: 3, validator: null),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _tf(_priceCtrl, 'Price *',
                          keyboard: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: _numberRequired),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _currency,
                        decoration: const InputDecoration(
                          labelText: 'Currency',
                          border: OutlineInputBorder(),
                        ),
                        items: _currencies
                            .map((c) => DropdownMenuItem(
                                value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _currency = v ?? 'TZS'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                _tf(_discountCtrl, 'Discount Price (optional)',
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true)),
                const SizedBox(height: 12),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Is Available'),
                  value: _isAvailable,
                  onChanged: (v) => setState(() => _isAvailable = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Is Veg'),
                  value: _isVeg,
                  onChanged: (v) => setState(() => _isVeg = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Is Featured'),
                  value: _isFeatured,
                  onChanged: (v) => setState(() => _isFeatured = v),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Create Menu',
                            style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tf(
    TextEditingController c,
    String label, {
    int maxLines = 1,
    TextInputType? keyboard,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _numberRequired(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v.trim()) == null) return 'Invalid number';
    return null;
  }
}