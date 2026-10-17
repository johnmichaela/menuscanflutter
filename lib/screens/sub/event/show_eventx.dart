// pages/event_list_screen.dart
import 'dart:convert';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:ballon/screens/sub/event/add_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================
// THEME
// ============================================================
class _C {
  // static const primary = Color(0xFF1565C0);
  // static const bg = Color(0xFFF5F7FA);
  // static const card = Colors.white;
  // static const textDark = Color(0xFF1A1A1A);
  // static const textMid = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const red = Color(0xFFDC2626);
}

// ============================================================
// MODEL — EventListItem
// ============================================================
class EventListItem {
  final int? id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String? categoryName;
  final int? categoryId;
  final int sessionsCount;

  EventListItem({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    this.status = 'draft',
    this.categoryName,
    this.categoryId,
    this.sessionsCount = 0,
  });

  factory EventListItem.fromJson(Map<String, dynamic> json) {
    final sessions = json['sessions'];
    final category = json['category_details'];
    final venue = json['venue_details'];

    String loc = '';
    if (venue is Map) {
      final n = venue['name'];
      if (n != null && n.toString().isNotEmpty) loc = n.toString();
    }
    if (loc.isEmpty && json['location'] != null) {
      loc = json['location'].toString();
    }

    return EventListItem(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      location: loc,
      startTime: DateTime.tryParse(json['start_time']?.toString() ?? '') ??
          DateTime.now(),
      endTime: DateTime.tryParse(json['end_time']?.toString() ?? '') ??
          DateTime.now().add(const Duration(hours: 2)),
      status: (json['status'] ?? 'draft').toString(),
      categoryName:
          category is Map ? (category['name'] ?? '').toString() : null,
      categoryId: json['category'] is int
          ? json['category']
          : int.tryParse('${json['category']}'),
      sessionsCount: sessions is List ? sessions.length : 0,
    );
  }
}

// ============================================================
// MODEL — Category / Venue
// ============================================================
class EventCategoryMini {
  final int? id;
  final String name;
  EventCategoryMini({this.id, required this.name});

  factory EventCategoryMini.fromJson(Map<String, dynamic> json) =>
      EventCategoryMini(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
        name: (json['name'] ?? '').toString(),
      );
}

class VenueMini {
  final int? id;
  final String name;
  final String address;
  VenueMini({this.id, required this.name, this.address = ''});

  factory VenueMini.fromJson(Map<String, dynamic> json) => VenueMini(
        id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
        name: (json['name'] ?? '').toString(),
        address: (json['address'] ?? '').toString(),
      );
}

// ============================================================
// SERVICE
// ============================================================
class EventListService {
  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// GET /events-timetable/api/events/
  static Future<List<EventListItem>> fetchEvents({String? search}) async {
    final uri = Uri.parse('${Urls.baseUrl}/events-timetable/api/events/');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode != 200) {
      throw Exception('Failed to load events (${res.statusCode}): ${res.body}');
    }

    final dynamic decoded = jsonDecode(res.body);
    final List list = decoded is List ? decoded : (decoded['results'] ?? []);

    final events = list
        .whereType<Map>()
        .map((e) => EventListItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      return events
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              e.location.toLowerCase().contains(q))
          .toList();
    }
    return events;
  }

  /// GET /events-timetable/api/categories/
  static Future<List<EventCategoryMini>> fetchCategories() async {
    try {
      final uri =
          Uri.parse('${Urls.baseUrl}/events-timetable/api/categories/');
      final res = await http.get(uri, headers: await _authHeaders());
      if (res.statusCode != 200) return [];
      final dynamic decoded = jsonDecode(res.body);
      final List list = decoded is List ? decoded : (decoded['results'] ?? []);
      return list
          .whereType<Map>()
          .map((e) => EventCategoryMini.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// GET /events-timetable/api/venues/
  static Future<List<VenueMini>> fetchVenues() async {
    try {
      final uri = Uri.parse('${Urls.baseUrl}/events-timetable/api/venues/');
      final res = await http.get(uri, headers: await _authHeaders());
      if (res.statusCode != 200) return [];
      final dynamic decoded = jsonDecode(res.body);
      final List list = decoded is List ? decoded : (decoded['results'] ?? []);
      return list
          .whereType<Map>()
          .map((e) => VenueMini.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// POST /events-timetable/api/events/
  static Future<EventListItem> createEvent({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    int? categoryId,
    int? venueId,
    String attendanceType = 'public',
    String status = 'draft',
    int? maxAttendees,
    DateTime? registrationDeadline,
  }) async {
    final uri = Uri.parse('${Urls.baseUrl}/events-timetable/api/events/');
    final body = <String, dynamic>{
      'title': title,
      'description': description,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
      'attendance_type': attendanceType,
      'status': status,
      if (categoryId != null) 'category': categoryId,
      if (venueId != null) 'venue': venueId,
      if (maxAttendees != null) 'max_attendees': maxAttendees,
      if (registrationDeadline != null)
        'registration_deadline': registrationDeadline.toUtc().toIso8601String(),
    };

    final res = await http.post(
      uri,
      headers: await _authHeaders(),
      body: jsonEncode(body),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return EventListItem.fromJson(
        Map<String, dynamic>.from(jsonDecode(res.body)),
      );
    }
    throw Exception('Failed to create event (${res.statusCode}): ${res.body}');
  }
}

// ============================================================
// SCREEN — Event List
// ============================================================
class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<EventListItem> _events = [];
  bool _loading = true;
  String? _error;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await EventListService.fetchEvents(search: _search);
      if (!mounted) return;
      setState(() {
        _events = list;
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

  Future<void> _openDetail(EventListItem e) async {
    if (e.id == null) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEventScreen(eventId: e.id!),
      ),
    );
    _load();
  }

  Future<void> _openCreateSheet() async {
    final created = await showModalBottomSheet<EventListItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _EventFormSheet(),
    );

    if (created == null) return;
    if (!mounted) return;

    setState(() => _events.insert(0, created));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created')),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        // foregroundColor: Theme.of(context).cardColor,
        elevation: 0,
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Add event',
            onPressed: _openCreateSheet,
            icon: const Icon(Icons.add),
          ),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _buildBody(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateSheet,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).cardColor,
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return  Center(
        child: CircularProgressIndicator(color: Theme.of(context).primaryColor),
      );
    }

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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: _load,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
         Text(
          'Events',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 4),
         Text(
          'Discover amazing events, conferences, workshops and more.',
          style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        const SizedBox(height: 16),

        TextField(
          onChanged: (v) {
            _search = v;
            _load();
          },
          decoration: InputDecoration(
            hintText: 'Search events...',
            prefixIcon: Icon(Icons.search, color: Theme.of(context).textTheme.bodyMedium?.color),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:  BorderSide(color: const Color.fromARGB(132, 224, 224, 224)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:  BorderSide(color: const Color.fromARGB(123, 224, 224, 224)),
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (_events.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy,
                      size: 56, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                 Text('No events yet',
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _openCreateSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).cardColor,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Create your first event'),
                  ),
                ],
              ),
            ),
          )
        else
          ..._events.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _EventCard(
                  event: e,
                  onTap: () => _openDetail(e),
                ),
              )),
      ],
    );
  }
}

// ============================================================
// EVENT CARD
// ============================================================
class _EventCard extends StatelessWidget {
  final EventListItem event;
  final VoidCallback onTap;

  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color.fromARGB(88, 224, 224, 224), width: 1),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.event,
                      color: Theme.of(context).primaryColor, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style:  TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          event.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:  TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                 Icon(Icons.chevron_right, color: Theme.of(context).textTheme.bodyMedium?.color),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${DateFormat('dd MMM yyyy').format(event.startTime)}  •  '
                    '${DateFormat('HH:mm').format(event.startTime)} - '
                    '${DateFormat('HH:mm').format(event.endTime)}',
                    style:  TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            if (event.location.isNotEmpty)
              Row(
                children: [
                  Icon(Icons.place_outlined,
                      size: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      event.location,
                      style:  TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 12),

            Row(
              children: [
                if (event.categoryName != null &&
                    event.categoryName!.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.categoryName!,
                      style:  TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                 Icon(Icons.event_note, size: 14, color: Theme.of(context).textTheme.bodyMedium?.color),
                const SizedBox(width: 4),
                Text(
                  '${event.sessionsCount} session${event.sessionsCount == 1 ? '' : 's'}',
                  style:  TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add',
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EVENT FORM SHEET (create)
// ============================================================
class _EventFormSheet extends StatefulWidget {
  const _EventFormSheet();

  @override
  State<_EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends State<_EventFormSheet> {
  final _formKey = GlobalKey<FormState>();

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _maxAttendeesCtrl = TextEditingController();

  DateTime? _start;
  DateTime? _end;
  DateTime? _regDeadline;

  int? _categoryId;
  int? _venueId;
  String? _selectedCategoryName;
  String? _selectedVenueName;

  String _attendanceType = 'public';
  String _status = 'draft';

  List<EventCategoryMini> _categories = [];
  List<VenueMini> _venues = [];
  bool _loadingRefs = true;
  bool _submitting = false;

  /// Must match Event.ATTENDANCE_CHOICES in Django exactly.
  static const _attendanceTypes = <String, String>{
    'public': 'Public — anyone can attend',
    'registered': 'Registered users only',
    'staff': 'Staff only',
    'invite': 'Invitation only',
    'members': 'Members only',
  };

  /// Must match Event.STATUS_CHOICES in Django exactly.
  static const _statuses = <String, String>{
    'draft': 'Draft',
    'published': 'Published',
    'cancelled': 'Cancelled',
    'completed': 'Completed',
  };

  @override
  void initState() {
    super.initState();
    _loadRefs();
  }

  Future<void> _loadRefs() async {
    final cats = await EventListService.fetchCategories();
    final venues = await EventListService.fetchVenues();
    if (!mounted) return;
    setState(() {
      _categories = cats;
      _venues = venues;
      _loadingRefs = false;
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _maxAttendeesCtrl.dispose();
    super.dispose();
  }

  // ---------- PICKERS ----------
  Future<void> _pickCategory() async {
    final picked = await showModalBottomSheet<EventCategoryMini>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SearchPickerSheet<EventCategoryMini>(
        title: 'Choose Category',
        hint: 'Search categories...',
        icon: Icons.category_outlined,
        items: _categories,
        labelBuilder: (c) => c.name,
      ),
    );
    if (picked == null) return;
    setState(() {
      _categoryId = picked.id;
      _selectedCategoryName = picked.name;
    });
  }

  Future<void> _pickVenue() async {
    final picked = await showModalBottomSheet<VenueMini>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SearchPickerSheet<VenueMini>(
        title: 'Choose Venue',
        hint: 'Search venues...',
        icon: Icons.place_outlined,
        items: _venues,
        labelBuilder: (v) => v.name,
        subtitleBuilder: (v) => v.address,
      ),
    );
    if (picked == null) return;
    setState(() {
      _venueId = picked.id;
      _selectedVenueName = picked.name;
    });
  }

  // ---------- DATE/TIME ----------
  Future<DateTime?> _pickDateTime({
    required DateTime initial,
  }) async {
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return null;
    if (!mounted) return null;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    return DateTime(
      d.year,
      d.month,
      d.day,
      t?.hour ?? 0,
      t?.minute ?? 0,
    );
  }

  String _fmt(DateTime? d) => d == null
      ? 'Select date & time'
      : DateFormat('dd MMM yyyy, HH:mm').format(d);

  // ---------- SUBMIT ----------
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_start == null || _end == null) {
      _snack('Please pick start and end date/time');
      return;
    }
    if (!_end!.isAfter(_start!)) {
      _snack('End time must be after start time');
      return;
    }
    if (_regDeadline != null && _regDeadline!.isAfter(_start!)) {
      _snack('Registration deadline must be before start time');
      return;
    }

    setState(() => _submitting = true);

    try {
      final created = await EventListService.createEvent(
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        startTime: _start!,
        endTime: _end!,
        categoryId: _categoryId,
        venueId: _venueId,
        attendanceType: _attendanceType,
        status: _status,
        maxAttendees: _maxAttendeesCtrl.text.trim().isEmpty
            ? null
            : int.tryParse(_maxAttendeesCtrl.text.trim()),
        registrationDeadline: _regDeadline,
      );

      if (!mounted) return;
      Navigator.of(context).pop(created);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _snack(e.toString(), isError: true);
    }
  }

  void _snack(String m, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(m),
        backgroundColor: isError ? _C.red : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
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
              const Text('Add New Event',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Title
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Required'
                    : null,
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // Category (searchable picker)
              _loadingRefs
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    )
                  : _PickerField(
                      label: 'Category',
                      icon: Icons.category_outlined,
                      placeholder: _categories.isEmpty
                          ? 'No categories available'
                          : '— Tap to choose —',
                      value: _selectedCategoryName ?? '',
                      onTap: _categories.isEmpty ? () {} : _pickCategory,
                      onClear: _categoryId == null
                          ? null
                          : () => setState(() {
                                _categoryId = null;
                                _selectedCategoryName = null;
                              }),
                    ),
              const SizedBox(height: 12),

              // Venue (searchable picker)
              _loadingRefs
                  ? const SizedBox.shrink()
                  : _PickerField(
                      label: 'Venue',
                      icon: Icons.place_outlined,
                      placeholder: _venues.isEmpty
                          ? 'No venues available'
                          : '— Tap to choose —',
                      value: _selectedVenueName ?? '',
                      onTap: _venues.isEmpty ? () {} : _pickVenue,
                      onClear: _venueId == null
                          ? null
                          : () => setState(() {
                                _venueId = null;
                                _selectedVenueName = null;
                              }),
                    ),
              const SizedBox(height: 12),

              // Start
              InkWell(
                onTap: () async {
                  final picked = await _pickDateTime(
                      initial: _start ?? DateTime.now());
                  if (picked != null) {
                    setState(() {
                      _start = picked;
                      if (_end == null || _end!.isBefore(picked)) {
                        _end = picked.add(const Duration(hours: 2));
                      }
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Start *',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_fmt(_start)),
                ),
              ),
              const SizedBox(height: 12),

              // End
              InkWell(
                onTap: () async {
                  final picked = await _pickDateTime(
                      initial: _end ??
                          (_start ?? DateTime.now())
                              .add(const Duration(hours: 2)));
                  if (picked != null) {
                    setState(() => _end = picked);
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'End *',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_fmt(_end)),
                ),
              ),
              const SizedBox(height: 12),

              // Registration deadline
              InkWell(
                onTap: () async {
                  final picked = await _pickDateTime(
                      initial: _regDeadline ??
                          (_start ?? DateTime.now())
                              .subtract(const Duration(days: 1)));
                  if (picked != null) {
                    setState(() => _regDeadline = picked);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Registration deadline (optional)',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: _regDeadline == null
                          ? null
                          : () => setState(() => _regDeadline = null),
                    ),
                  ),
                  child: Text(_fmt(_regDeadline)),
                ),
              ),
              const SizedBox(height: 12),

              // Attendance type
              DropdownButtonFormField<String>(
                value: _attendanceType,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Attendance type',
                  border: OutlineInputBorder(),
                ),
                items: _attendanceTypes.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) =>
                    setState(() => _attendanceType = v ?? 'public'),
              ),
              const SizedBox(height: 12),

              // Status
              DropdownButtonFormField<String>(
                value: _status,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: _statuses.entries
                    .map((e) => DropdownMenuItem(
                          value: e.key,
                          child: Text(e.value),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? 'draft'),
              ),
              const SizedBox(height: 12),

              // Max attendees
              TextFormField(
                controller: _maxAttendeesCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max attendees (optional)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return null;
                  return int.tryParse(v.trim()) == null
                      ? 'Invalid number'
                      : null;
                },
              ),
              const SizedBox(height: 20),

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
                      : const Text('Create Event',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// PICKER FIELD (tap → opens search sheet)
// ============================================================
class _PickerField extends StatelessWidget {
  final String label;
  final String value;
  final String placeholder;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _PickerField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.icon,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: hasValue && onClear != null
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: onClear,
                )
              : Icon(icon, size: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
        child: Text(
          hasValue ? value : placeholder,
          style: TextStyle(
            fontSize: 14,
            color: hasValue ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).textTheme.bodyMedium?.color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

// ============================================================
// SEARCH PICKER SHEET (bottom sheet with search)
// ============================================================
class _SearchPickerSheet<T> extends StatefulWidget {
  final String title;
  final String hint;
  final List<T> items;
  final String Function(T) labelBuilder;
  final String Function(T)? subtitleBuilder;
  final IconData icon;

  const _SearchPickerSheet({
    required this.title,
    required this.hint,
    required this.items,
    required this.labelBuilder,
    this.subtitleBuilder,
    this.icon = Icons.list,
  });

  @override
  State<_SearchPickerSheet<T>> createState() => _SearchPickerSheetState<T>();
}

class _SearchPickerSheetState<T> extends State<_SearchPickerSheet<T>> {
  final _searchCtrl = TextEditingController();
  List<T> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) {
      setState(() => _filtered = widget.items);
      return;
    }
    setState(() {
      _filtered = widget.items.where((item) {
        final label = widget.labelBuilder(item).toLowerCase();
        final subtitle =
            (widget.subtitleBuilder?.call(item) ?? '').toLowerCase();
        return label.contains(query) || subtitle.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(widget.icon, color: Theme.of(context).primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                autofocus: true,
                onChanged: _filter,
                decoration: InputDecoration(
                  hintText: widget.hint,
                  prefixIcon:
                       Icon(Icons.search, color: Theme.of(context).textTheme.bodyMedium?.color),
                  filled: true,
                  fillColor: Theme.of(context).canvasColor,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:  BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:  BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
              ),
            ),
            Expanded(
              child: _filtered.isEmpty
                  ?  Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No matches',
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                           Divider(height: 1, color: Theme.of(context).dividerColor),
                      itemBuilder: (_, i) {
                        final item = _filtered[i];
                        final subtitle =
                            widget.subtitleBuilder?.call(item) ?? '';
                        return ListTile(
                          title: Text(widget.labelBuilder(item)),
                          subtitle: subtitle.isEmpty
                              ? null
                              : Text(
                                  subtitle,
                                  style:  TextStyle(
                                      fontSize: 12, color: Theme.of(context).textTheme.bodyMedium?.color),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          onTap: () => Navigator.pop(context, item),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}