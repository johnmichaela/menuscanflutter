// pages/menu_page.dart
import 'dart:convert';
import 'dart:io';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';
// ============================================================
// THEME CONSTANTS (Qopera look)
// ============================================================
class _AppColors {
  static const primary = Color(0xFF1565C0);
  static const primaryDark = Color(0xFF0D47A1);
  static const accent = Color(0xFF1976D2);
  static const bg = Color(0xFFF5F7FA);
  static const card = Colors.white;
  static const textDark = Color(0xFF1A1A1A);
  static const textMid = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const green = Color(0xFF16A34A);
  static const red = Color(0xFFDC2626);
}

// ============================================================
// MODEL — MenuCategory
// ============================================================
class MenuCategory {
  final int? id;
  final int? profile;
  final String name;
  final int sortOrder;

  MenuCategory({
    this.id,
    this.profile,
    required this.name,
    this.sortOrder = 0,
  });

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    return MenuCategory(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      profile: json['profile'] is int
          ? json['profile']
          : (json['profile'] is Map ? json['profile']['id'] : null),
      name: json['name'] ?? '',
      sortOrder: json['sort_order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'sort_order': sortOrder,
      };
}

// ============================================================
// MODEL — FoodItem
// ============================================================
class FoodItem {
  final int? id;
  final int? profile;
  final String name;
  final String? description;
  final String? image;
  final double price;
  final String currency;
  final double? discountPrice;
  final bool isAvailable;
  final bool isVeg;
  final bool isFeatured;
  final double? rating;
  final int? ratingCount;
  final MenuCategory? category;

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
    this.category,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      profile: json['profile'] is int
          ? json['profile']
          : (json['profile'] is Map ? json['profile']['id'] : null),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: _fullImageUrl(json['image']),
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
      category: json['category'] != null && json['category'] is Map
          ? MenuCategory.fromJson(json['category'])
          : null,
    );
  }

  static String? _fullImageUrl(dynamic path) {
    if (path == null) return null;
    final s = path.toString();
    if (s.isEmpty) return null;
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    final base = Urls.baseUrl.endsWith('/')
        ? Urls.baseUrl.substring(0, Urls.baseUrl.length - 1)
        : Urls.baseUrl;
    return s.startsWith('/') ? '$base$s' : '$base/$s';
  }
}

// ============================================================
// SERVICE
// ============================================================
class MenuService {
  static String? authToken;

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

static Future<List<FoodItem>> fetchMyMenus() async {
  final uri = Uri.parse('${Urls.baseUrl}/prof/api/my-menus/');
  final res = await http.get(uri, headers: await _authHeaders());

  if (res.statusCode != 200) {
    throw Exception('Failed to load menus (${res.statusCode}): ${res.body}');
  }

  final decoded = jsonDecode(res.body);
  final List list = decoded is List ? decoded : (decoded['results'] ?? []);
  debugPrint('Fetched ${list.length} menus');

  final items = <FoodItem>[];
  for (int i = 0; i < list.length; i++) {
    final raw = list[i];
    try {
      final map = Map<String, dynamic>.from(raw as Map);
      final item = FoodItem.fromJson(map);
      items.add(item);
      debugPrint('[$i] id=${item.id} name="${item.name}" '
          'price=${item.price} ${item.currency} '
          'category=${item.category?.name ?? "—"}');
    } catch (e, st) {
      debugPrint('❌ [$i] parse failed: $e');
      debugPrint('   raw = $raw');
      debugPrint('   stack = $st');
    }
  }
  return items;
}
  static Future<List<FoodItem>> fetchMyMenusx() async {
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/my-menus/');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final List list =
          decoded is List ? decoded : (decoded['results'] ?? []);
          print('Fetched ${list.length} menus');
          print('Response body: ${res.body}');
          // test FoodItem as working with the following code:

          print('Objects: ${list.map((e) => FoodItem.fromJson(e)).toList()}');
          final items = list
      .whereType<Map>()
      .map((e) => FoodItem.fromJson(Map<String, dynamic>.from(e)))
      .toList();

  // Pretty log for debugging
  for (int i = 0; i < items.length; i++) {
    final it = items[i];
    debugPrint('[$i] id=${it.id} '
        'name="${it.name}" '
        'price=${it.price} ${it.currency} '
        'category=${it.category?.name ?? "—"}');
  }

  return items;
          
      // return list.map((e) => FoodItem.fromJson(e)).toList();
    }
    throw Exception('Failed to load menus (${res.statusCode}): ${res.body}');
  }

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

    request.fields['name'] = item.name;
    request.fields['description'] = item.description!;
    request.fields['price'] = item.price.toString();
    request.fields['currency'] = item.currency;
    request.fields['is_available'] = item.isAvailable.toString();
    request.fields['is_veg'] = item.isVeg.toString();
    request.fields['is_featured'] = item.isFeatured.toString();

    if (item.discountPrice != null) {
      request.fields['discount_price'] = item.discountPrice!.toString();
    }
    if (item.category?.id != null) {
      request.fields['category'] = item.category!.id.toString();
    }

    if (imageFile != null) {
      request.files.add(await _imagePart(imageFile));
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return FoodItem.fromJson(jsonDecode(res.body));
    }
    throw Exception(
        'Failed to create menu (${res.statusCode}): ${res.body}');
  }

  static Future<FoodItem> updateMenu(
    int id,
    FoodItem item, {
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/menus/$id/update');
    final request = http.MultipartRequest('PATCH', uri);

    if (token != null) {
      request.headers['Authorization'] = 'Token $token';
    }
    request.headers['Accept'] = 'application/json';

    request.fields['name'] = item.name;
    request.fields['description'] = item.description!;
    request.fields['price'] = item.price.toString();
    request.fields['currency'] = item.currency;
    request.fields['is_available'] = item.isAvailable.toString();
    request.fields['is_veg'] = item.isVeg.toString();
    request.fields['is_featured'] = item.isFeatured.toString();

    request.fields['discount_price'] =
        item.discountPrice?.toString() ?? '';

    if (item.category?.id != null) {
      request.fields['category'] = item.category!.id.toString();
    } else {
      request.fields['category'] = '';
    }

    if (imageFile != null) {
      request.files.add(await _imagePart(imageFile));
    }

    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode == 200) {
      return FoodItem.fromJson(jsonDecode(res.body));
    }
    throw Exception(
        'Failed to update menu (${res.statusCode}): ${res.body}');
  }

  static Future<void> deleteMenu(int id) async {
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/menus/$id/delete');
    final res = await http.delete(uri, headers: await _authHeaders());

    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception(
        'Failed to delete menu (${res.statusCode}): ${res.body}');
  }

  static Future<List<MenuCategory>> fetchCategories() async {
    final uri = Uri.parse('${Urls.baseUrl}/prof/api/menu-categories/');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final List list =
          decoded is List ? decoded : (decoded['results'] ?? []);
      return list.map((e) => MenuCategory.fromJson(e)).toList();
    }
    throw Exception(
        'Failed to load categories (${res.statusCode}): ${res.body}');
  }

  static Future<MenuCategory> createCategory(String name) async {
    final uri =
        Uri.parse('${Urls.baseUrl}/prof/api/menu-categories/create');
    final headers = await _authHeaders();
    headers['Content-Type'] = 'application/json';

    final res = await http.post(
      uri,
      headers: headers,
      body: jsonEncode({'name': name}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return MenuCategory.fromJson(jsonDecode(res.body));
    }
    throw Exception(
        'Failed to create category (${res.statusCode}): ${res.body}');
  }

  static Future<http.MultipartFile> _imagePart(File imageFile) async {
    final ext = imageFile.path.split('.').last.toLowerCase();
    final mime = (ext == 'png')
        ? 'png'
        : (ext == 'webp')
            ? 'webp'
            : 'jpeg';
    return http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      contentType: MediaType('image', mime),
    );
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
  List<MenuCategory> _categories = [];
  bool _loading = true;
  String? _error;

  /// null = "All"
  int? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        MenuService.fetchMyMenus(),
        MenuService.fetchCategories(),
      ]);
      if (!mounted) return;
      setState(() {
        _menus
          ..clear()
          ..addAll(results[0] as List<FoodItem>);
        _categories = results[1] as List<MenuCategory>;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<FoodItem> get _filtered {
    if (_selectedCategoryId == null) return _menus;
    return _menus
        .where((m) => m.category?.id == _selectedCategoryId)
        .toList();
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
      _snack('Menu created successfully');
    }
  }

  Future<void> _openEditSheet(FoodItem item) async {
    final updated = await showModalBottomSheet<FoodItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MenuFormSheet(existing: item),
    );

    if (updated != null) {
      setState(() {
        final idx = _menus.indexWhere((m) => m.id == updated.id);
        if (idx != -1) _menus[idx] = updated;
      });
      _snack('Menu updated successfully');
    }
  }

  Future<void> _confirmDelete(FoodItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text( context.tr.deleteItemTitle),
        content: Text('${context.tr.deleteItemConfirm} "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text(context.tr.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _AppColors.red),
            onPressed: () => Navigator.pop(context, true),
            child:  Text( context.tr.delete),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await MenuService.deleteMenu(item.id!);
      if (!mounted) return;
      setState(() => _menus.removeWhere((m) => m.id == item.id));
      _snack('Item deleted');
    } catch (e) {
      if (!mounted) return;
      _snack(e.toString(), isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? _AppColors.red : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
        title:  Text(
          context.tr.menu ,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAll,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAll,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        backgroundColor: _AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label:  Text(context.tr.addItem),
      ),
    );
  }

  // ---------- BODY ----------
  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: _AppColors.primary),
      );
    }

    if (_error!= null) {
      print('Error loading menus: $_error');
      return ListView(
        children: [
          const SizedBox(height: 100),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Icon(Icons.error_outline,
                      color: _AppColors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: _AppColors.primary),
                    onPressed: _loadAll,
                    child:  Text( context.tr.retry),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    final items = _filtered;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        // ---- Header block ----
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration:  BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_basket,
                  color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedCategoryId == null
                        ? context.tr.allItems
                        : (_categories
                                .firstWhere(
                                  (c) => c.id == _selectedCategoryId,
                                  orElse: () => MenuCategory(name: 'Items'),
                                )
                                .name),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text( context.tr.manageMenuSubtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color:  Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // ---- Category chips ----
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _chip(
                label: 'All',
                selected: _selectedCategoryId == null,
                onTap: () => setState(() => _selectedCategoryId = null),
              ),
              const SizedBox(width: 8),
              ..._categories.map((c) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _chip(
                      label: c.name,
                      selected: _selectedCategoryId == c.id,
                      onTap: () =>
                          setState(() => _selectedCategoryId = c.id),
                    ),
                  )),
              // Add-category chip
              GestureDetector(
                onTap: _promptCreateCategory,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children:  [
                      Icon(Icons.add, size: 16, color: Theme.of(context).primaryColor),
                      SizedBox(width: 4),
                      Text( context.tr.newLabel,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // ---- Items ----
        if (items.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined,
                      size: 56, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    _menus.isEmpty
                        ?  context.tr.noItemsYet
                        : context.tr.noItemsInCategory,
                    style: const TextStyle(color: _AppColors.textMid),
                  ),
                ],
              ),
            ),
          )
        else
          ...items.map((it) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProductRow(
                  item: it,
                  onEdit: () => _openEditSheet(it),
                  onDelete: () => _confirmDelete(it),
                ),
              )),
      ],
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Theme.of(context).primaryColor : const Color.fromARGB(255, 116, 115, 115),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Theme.of(context).textTheme.titleMedium?.color,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _promptCreateCategory() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.tr.newCategory),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: InputDecoration(
            labelText:  context.tr.categoryName,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text( context.tr.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child:  Text( context.tr.create),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    try {
      final created = await MenuService.createCategory(name);
      if (!mounted) return;
      setState(() {
        _categories.add(created);
        _selectedCategoryId = created.id;
      });
    } catch (e) {
      if (!mounted) return;
      _snack(e.toString(), isError: true);
    }
  }
}

// ============================================================
// PRODUCT ROW
// ============================================================
class _ProductRow extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductRow({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: const Color.fromARGB(255, 179, 178, 178), width: 1),
      ),
      // padding: const EdgeInsets.all(6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Image ----
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: (item.image != null && item.image!.isNotEmpty)
                ? Image.network(
                    item.image!,
                    width: 90,
                    height:110 ,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                : _placeholder(),
          ),
          const SizedBox(width: 12),

          // ---- Info ----
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // veg indicator
                      // _vegDot(item.isVeg),
                      // const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // action menu
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon:  Icon(Icons.more_vert,
                            color: Theme.of(context).textTheme.titleMedium?.color),
                        onSelected: (v) {
                          if (v == 'edit') onEdit();
                          if (v == 'delete') onDelete();
                        },
                        itemBuilder: (_) =>  [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18),
                                SizedBox(width: 8),
                                Text( context.tr.edit),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline,
                                    size: 18, color: _AppColors.red),
                                SizedBox(width: 8),
                                Text( context.tr.delete,
                                    style: TextStyle(color: _AppColors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  if (item.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: _AppColors.textMid),
                    ),
                  ],
                  const SizedBox(height: 8),
              
                  // price + status
                  Row(
                    children: [
                      Text(
                       item.discountPrice != null ? '${item.currency} ${NumberFormat.decimalPattern().format(item.discountPrice)}' : '${item.currency} ${NumberFormat.decimalPattern().format(item.price)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          // color: Theme.of(context).primaryColor,
                        ),
                      ),
                      if (item.discountPrice != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${item.currency} ${NumberFormat.decimalPattern().format(item.price)}',
                          style:  TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                       const Spacer(),
                  //     if (item.category != null) ...[
                  //   // const SizedBox(height: 2),
                  //   Text(
                  //     item.category!.name,
                  //     style: const TextStyle(
                  //         fontSize: 12, color: _AppColors.textMid),
                  //   ),
                  // ],
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: item.isAvailable
                              ? _AppColors.green.withOpacity(.1)
                              : _AppColors.red.withOpacity(.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.isAvailable ?context.tr.available:  context.tr.unavailable,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: item.isAvailable
                                ? _AppColors.green
                                : _AppColors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vegDot(bool isVeg) {
    final color = isVeg ? _AppColors.green : _AppColors.red;
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

  Widget _placeholder() => Container(
        width: 72,
        height: 72,
        color: Colors.grey.shade100,
        child: const Icon(Icons.fastfood, color: Colors.grey),
      );
}

// ============================================================
// BOTTOM SHEET FORM (create + edit)
// ============================================================
class MenuFormSheet extends StatefulWidget {
  final FoodItem? existing;

  const MenuFormSheet({super.key, this.existing});

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
  String? _existingImageUrl;

  List<MenuCategory> _categories = [];
  int? _selectedCategoryId;
  bool _loadingCategories = true;

  static const _currencies = ['TZS', 'USD', 'EUR', 'KES'];

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _prefill();
    _loadCategories();
  }

  void _prefill() {
    final e = widget.existing;
    if (e == null) return;
    _nameCtrl.text = e.name;
    _descCtrl.text = e.description!;
    _priceCtrl.text = e.price.toString();
    _discountCtrl.text =
        e.discountPrice != null ? e.discountPrice!.toString() : '';
    _currency = e.currency;
    _isAvailable = e.isAvailable;
    _isVeg = e.isVeg;
    _isFeatured = e.isFeatured;
    _existingImageUrl = e.image;
    _selectedCategoryId = e.category?.id;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _discountCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final list = await MenuService.fetchCategories();
      if (!mounted) return;
      setState(() {
        _categories = list;
        _loadingCategories = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingCategories = false);
    }
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
              title:  Text( context.tr.takePhoto),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title:  Text(context.tr.chooseFromGallery ),
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

  Future<void> _promptCreateCategory() async {
    final ctrl = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title:  Text( context.tr.newCategory),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration:  InputDecoration(
            labelText: context.tr.categoryName,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text( context.tr.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, ctrl.text.trim()),
            child:  Text(context.tr.create),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;

    try {
      final created = await MenuService.createCategory(name);
      if (!mounted) return;
      setState(() {
        _categories.add(created);
        _selectedCategoryId = created.id;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: _AppColors.red),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    MenuCategory? selected;
    if (_selectedCategoryId != null) {
      for (final c in _categories) {
        if (c.id == _selectedCategoryId) {
          selected = c;
          break;
        }
      }
    }

    final item = FoodItem(
      id: widget.existing?.id,
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
      category: selected,
    );

    try {
      final result = _isEdit
          ? await MenuService.updateMenu(
              widget.existing!.id!,
              item,
              imageFile: _imageFile,
            )
          : await MenuService.createMenu(item, imageFile: _imageFile);

      if (!mounted) return;
      Navigator.of(context).pop(result);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: _AppColors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
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
                Text(
                  _isEdit ?  context.tr.editItem :  context.tr.addNewItem,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

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
                        : (_existingImageUrl != null &&
                                _existingImageUrl!.isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  _existingImageUrl!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) =>
                                      _imagePickerPlaceholder(),
                                ),
                              )
                            : _imagePickerPlaceholder(),
                  ),
                ),
                if (_imageFile != null || _existingImageUrl != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => setState(() {
                        _imageFile = null;
                        _existingImageUrl = null;
                      }),
                      icon: const Icon(Icons.close, size: 16),
                      label:  Text( context.tr.removeImage),
                    ),
                  ),
                const SizedBox(height: 12),

                _tf(_nameCtrl, ' ${context.tr.name} *', validator: _required),
                const SizedBox(height: 12),

                _tf(_descCtrl, ' ${context.tr.description}', maxLines: 3, validator: null),
                const SizedBox(height: 12),

                _loadingCategories
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: LinearProgressIndicator(),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int?>(
                              value: _selectedCategoryId,
                              isExpanded: true,
                              decoration:  InputDecoration(
                                labelText: context.tr.categoryOptional,
                                border: OutlineInputBorder(),
                              ),
                              items: [
                                const DropdownMenuItem<int?>(
                                  value: null,
                                  child: Text('— None —'),
                                ),
                                ..._categories.map(
                                  (c) => DropdownMenuItem<int?>(
                                    value: c.id,
                                    child: Text(c.name),
                                  ),
                                ),
                              ],
                              onChanged: (v) =>
                                  setState(() => _selectedCategoryId = v),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: context.tr.newCategory,
                            onPressed: _promptCreateCategory,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _tf(_priceCtrl, '${context.tr.price} *',
                          keyboard: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: _numberRequired),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _currency,
                        decoration:  InputDecoration(
                          labelText:  context.tr.currency,
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

                _tf(_discountCtrl,  context.tr.discountPriceOptional,
                    keyboard:
                        const TextInputType.numberWithOptions(decimal: true)),
                const SizedBox(height: 12),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title:  Text( context.tr.isAvailable),
                  value: _isAvailable,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (v) => setState(() => _isAvailable = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title:  Text( context.tr.isVeg),
                  value: _isVeg,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (v) => setState(() => _isVeg = v),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title:  Text( context.tr.featured),
                  value: _isFeatured,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (v) => setState(() => _isFeatured = v),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
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
                        : Text(
                            _isEdit ?  context.tr.updateItem : context.tr.createItem,
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePickerPlaceholder() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  [
          Icon(Icons.add_a_photo, size: 36, color: Colors.grey),
          SizedBox(height: 8),
          Text( context.tr.tapToAddImage, style: TextStyle(color: Colors.grey)),
        ],
      );

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