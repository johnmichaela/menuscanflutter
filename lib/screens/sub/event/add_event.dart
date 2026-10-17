// pages/event_detail_screen.dart
import 'dart:convert';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ballon/l10n/app_strings.dart';

class AppColors {
  static const primary = Color(0xFF1565C0);
  static const bg = Color(0xFFF5F7FA);
  static const card = Colors.white;
  static const textDark = Color(0xFF1A1A1A);
  static const textMid = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const red = Color(0xFFDC2626);
}

// ============================================================
// MODELS
// ============================================================
class EventSession {
  final int? id;
  final int? event; // event id
  final String title;
  final String description;
  final String speaker;
  final String location;
  final DateTime startTime;
  final DateTime endTime;

  EventSession({
    this.id,
    this.event,
    required this.title,
    this.description = '',
    this.speaker = '',
    this.location = '',
    required this.startTime,
    required this.endTime,
  });

  factory EventSession.fromJson(Map<String, dynamic> json) {
    return EventSession(
      id: _asInt(json['id']),
      event: _asInt(
        json['event'] is Map ? json['event']['id'] : json['event'],
      ),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      speaker: (json['speaker'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      startTime: DateTime.tryParse(json['start_time']?.toString() ?? '') ??
          DateTime.now(),
      endTime: DateTime.tryParse(json['end_time']?.toString() ?? '') ??
          DateTime.now().add(const Duration(hours: 1)),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'speaker': speaker,
        'location': location,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
      };

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }
}

class EventInfo {
  final int? id;
  final String title;
  final String description;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final List<EventSession> sessions;

  EventInfo({
    this.id,
    required this.title,
    this.description = '',
    this.location = '',
    required this.startTime,
    required this.endTime,
    this.status = 'upcoming',
    this.sessions = const [],
  });

  factory EventInfo.fromJson(Map<String, dynamic> json) {
    final rawSessions = json['sessions'];
    return EventInfo(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      location: (json['venue_details']?['name'] ??
              json['location'] ??
              '')
          .toString(),
      startTime:
          DateTime.tryParse(json['start_time']?.toString() ?? '') ??
              DateTime.now(),
      endTime: DateTime.tryParse(json['end_time']?.toString() ?? '') ??
          DateTime.now().add(const Duration(hours: 2)),
      status: (json['status'] ?? 'upcoming').toString(),
      sessions: rawSessions is List
          ? rawSessions
              .whereType<Map>()
              .map((e) => EventSession.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}

// ============================================================
// SERVICE
// ============================================================
class EventService {
  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// GET /events-timetable/api/events/<id>/
  static Future<EventInfo> fetchEvent(int id) async {
    final uri = Uri.parse('${Urls.baseUrl}/events-timetable/api/events/$id/');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode == 200) {
      return EventInfo.fromJson(
        Map<String, dynamic>.from(jsonDecode(res.body)),
      );
    }
    throw Exception('Failed to load event (${res.statusCode}): ${res.body}');
  }

  /// GET /events-timetable/api/events/<eventId>/sessions/
  static Future<List<EventSession>> fetchSessions(int eventId) async {
    final uri = Uri.parse(
        '${Urls.baseUrl}/events-timetable/api/events/$eventId/sessions/');
    final res = await http.get(uri, headers: await _authHeaders());

    if (res.statusCode == 200) {
      final List list = jsonDecode(res.body);
      return list
          .whereType<Map>()
          .map((e) => EventSession.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    throw Exception(
        'Failed to load sessions (${res.statusCode}): ${res.body}');
  }

  /// POST /events-timetable/api/events/<eventId>/sessions/
  static Future<EventSession> createSession(
    int eventId,
    EventSession session,
  ) async {
    final uri = Uri.parse(
        '${Urls.baseUrl}/events-timetable/api/events/$eventId/sessions/');
    final res = await http.post(
      uri,
      headers: await _authHeaders(),
      body: jsonEncode(session.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return EventSession.fromJson(
        Map<String, dynamic>.from(jsonDecode(res.body)),
      );
    }
    throw Exception(
        'Failed to create session (${res.statusCode}): ${res.body}');
  }

  /// PATCH /events-timetable/api/sessions/<id>/
  static Future<EventSession> updateSession(EventSession session) async {
    final uri = Uri.parse(
        '${Urls.baseUrl}/events-timetable/api/sessions/${session.id}/');
    final res = await http.patch(
      uri,
      headers: await _authHeaders(),
      body: jsonEncode(session.toJson()),
    );

    if (res.statusCode == 200) {
      return EventSession.fromJson(
        Map<String, dynamic>.from(jsonDecode(res.body)),
      );
    }
    throw Exception(
        'Failed to update session (${res.statusCode}): ${res.body}');
  }

  /// DELETE /events-timetable/api/sessions/<id>/
  static Future<void> deleteSession(int id) async {
    final uri = Uri.parse('${Urls.baseUrl}/events-timetable/api/sessions/$id/');
    final res = await http.delete(uri, headers: await _authHeaders());

    if (res.statusCode == 200 || res.statusCode == 204) return;
    throw Exception(
        'Failed to delete session (${res.statusCode}): ${res.body}');
  }
}

// ============================================================
// EVENT DETAIL SCREEN
// ============================================================
class AddEventScreen extends StatefulWidget {
  final int eventId;
  const AddEventScreen({super.key, required this.eventId});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  EventInfo? _event;
  List<EventSession> _sessions = [];
  bool _loading = true;
  String? _error;

  int _tab = 0; // 0 = Sessions, 1 = Event Info

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
      final ev = await EventService.fetchEvent(widget.eventId);
      final sessions = ev.sessions.isNotEmpty
          ? ev.sessions
          : await EventService.fetchSessions(widget.eventId);
      if (!mounted) return;
      setState(() {
        _event = ev;
        _sessions = sessions;
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

  Future<void> _openSessionForm({EventSession? existing}) async {
    final isEdit = existing != null;
    final result = await showModalBottomSheet<EventSession>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SessionFormSheet(
        existing: existing,
        eventStart: _event?.startTime,
        eventEnd: _event?.endTime,
      ),
    );

    if (result == null) return;

    try {
      if (isEdit) {
        final updated = await EventService.updateSession(result);
        if (!mounted) return;
        setState(() {
          final idx = _sessions.indexWhere((s) => s.id == updated.id);
          if (idx != -1) _sessions[idx] = updated;
        });
        _snack('Session updated');
      } else {
        final created =
            await EventService.createSession(widget.eventId, result);
        if (!mounted) return;
        setState(() => _sessions.add(created));
        _snack('Session created');
      }
    } catch (e) {
      if (!mounted) return;
      _snack(e.toString(), isError: true);
    }
  }

  Future<void> _confirmDelete(EventSession s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete session?'),
        content: Text('Delete "${s.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await EventService.deleteSession(s.id!);
      if (!mounted) return;
      setState(() => _sessions.removeWhere((e) => e.id == s.id));
      _snack('Session deleted');
    } catch (e) {
      if (!mounted) return;
      _snack(e.toString(), isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.red : null,
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
        title:  Text( context.tr.eventSessions,
            style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(onPressed: _loadAll, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openSessionForm(),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        icon: const Icon(Icons.add),
        label:  Text(context.tr.addSession),
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
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.red, size: 48),
              const SizedBox(height: 12),
              Text(context.tr.networkError, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                onPressed: _loadAll,
                child:  Text(context.tr.retry),
              ),
            ],
          ),
        ),
      );
    }

    final ev = _event!;
    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          _headerCard(ev),
          const SizedBox(height: 16),
          _tabs(),
          const SizedBox(height: 16),
          if (_tab == 0) _sessionsSection() else _eventInfoSection(ev),
        ],
      ),
    );
  }

  // ---------- Header card ----------
  Widget _headerCard(EventInfo ev) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_month,
                color: Theme.of(context).primaryColor, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ev.title,
                  style:  TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.titleMedium?.color),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                     Icon(Icons.place,
                        size: 14, color:Theme.of(context).textTheme.titleMedium?.color),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ev.location.isEmpty ? 'Location TBA'  : ev.location,
                        style: TextStyle(
                            fontSize: 12, color: Theme.of(context).textTheme.titleMedium?.color),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                     Icon(Icons.schedule,
                        size: 14, color: Theme.of(context).textTheme.titleMedium?.color),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${DateFormat('dd MMM yyyy').format(ev.startTime)} • '
                        '${DateFormat('HH:mm').format(ev.startTime)} - '
                        '${DateFormat('HH:mm').format(ev.endTime)}',
                        style: TextStyle(
                            fontSize: 12, color: Theme.of(context).textTheme.titleMedium?.color),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tabs ----------
  Widget _tabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          _tabButton(
            icon: Icons.calendar_today_outlined,
            label: context.tr.sessions,
            selected: _tab == 0,
            onTap: () => setState(() => _tab = 0),
          ),
          _tabButton(
            icon: Icons.info_outline,
            label: context.tr.eventInfo,
            selected: _tab == 1,
            onTap: () => setState(() => _tab = 1),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: selected ? Theme.of(context).primaryColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.titleMedium?.color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Sessions section ----------
  Widget _sessionsSection() {
    if (_sessions.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.event_note,
                  size: 56, color: Colors.grey.shade400),
              const SizedBox(height: 12),
               Text( context.tr.noSessionsYet,
                  style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color)),
              const SizedBox(height: 4),
               Text( context.tr.tapToAddOne,
                  style:
                      TextStyle(fontSize: 12, color: Theme.of(context).textTheme.titleMedium?.color)),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text( context.tr.eventSessions ,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
         Text( context.tr.selectSessionSubtitle,
            style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.titleMedium?.color)),
        const SizedBox(height: 12),
        ..._sessions.map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SessionRow(
                session: s,
                onEdit: () => _openSessionForm(existing: s),
                onDelete: () => _confirmDelete(s),
              ),
            )),
      ],
    );
  }

  Widget _eventInfoSection(EventInfo ev) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(context.tr.aboutThisEvent,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            ev.description.isEmpty ? 'No description provided.' : ev.description,
            style:  TextStyle(color: Theme.of(context).textTheme.titleMedium?.color, height: 1.5),
          ),
          const SizedBox(height: 16),
           Text(context.tr.status,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(ev.status.toUpperCase(),
              style:  TextStyle(color: Theme.of(context).primaryColor)),
        ],
      ),
    );
  }
}

// ============================================================
// SESSION ROW (matches template)
// ============================================================
class _SessionRow extends StatelessWidget {
  final EventSession session;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SessionRow({
    required this.session,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final start = session.startTime;
    final end = session.endTime;
    final durationHrs =
        end.difference(start).inMinutes / 60.0;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color.fromARGB(83, 229, 231, 235)),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // date box
          Container(
            width: 64,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  DateFormat('dd').format(start),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  DateFormat('MMM').format(start).toUpperCase(),
                  style:  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('HH:mm').format(start),
                  style:  TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.titleMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        session.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.titleMedium?.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
                        PopupMenuItem(value: 'edit', child: Text(context.tr.edit)),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(context.tr.delete,
                              style: TextStyle(color: AppColors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
                if (session.location.isNotEmpty)
                  Text(
                    '${session.location} • ${durationHrs.toStringAsFixed(durationHrs.truncateToDouble() == durationHrs ? 0 : 1)} Hours',
                    style:  TextStyle(
                        fontSize: 12, color: Theme.of(context).textTheme.titleMedium?.color),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                     Icon(Icons.schedule,
                        size: 14, color: Theme.of(context).textTheme.titleMedium?.color),
                    const SizedBox(width: 4),
                    Text(
                      '${DateFormat('HH:mm').format(start)} - '
                      '${DateFormat('HH:mm').format(end)}',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).textTheme.titleMedium?.color),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SESSION FORM SHEET (create + edit)
// ============================================================
class _SessionFormSheet extends StatefulWidget {
  final EventSession? existing;
  final DateTime? eventStart;
  final DateTime? eventEnd;

  const _SessionFormSheet({
    this.existing,
    this.eventStart,
    this.eventEnd,
  });

  @override
  State<_SessionFormSheet> createState() => _SessionFormSheetState();
}

class _SessionFormSheetState extends State<_SessionFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _speakerCtrl;
  late final TextEditingController _locCtrl;

  DateTime? _start;
  DateTime? _end;

  bool get _isEdit => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _descCtrl = TextEditingController(text: e?.description ?? '');
    _speakerCtrl = TextEditingController(text: e?.speaker ?? '');
    _locCtrl = TextEditingController(text: e?.location ?? '');
    _start = e?.startTime ?? widget.eventStart;
    _end = e?.endTime ??
        widget.eventStart?.add(const Duration(hours: 1)) ??
        DateTime.now().add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _speakerCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  Future<void> _pick({required bool isStart}) async {
    final initial = (isStart ? _start : _end) ?? DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    final dt = DateTime(
        d.year, d.month, d.day, t?.hour ?? 0, t?.minute ?? 0);
    setState(() {
      if (isStart) {
        _start = dt;
        if (_end == null || _end!.isBefore(dt)) {
          _end = dt.add(const Duration(hours: 1));
        }
      } else {
        _end = dt;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_start == null || _end == null) {
      _snack('Please pick both start and end times');
      return;
    }
    if (!_end!.isAfter(_start!)) {
      _snack('End time must be after start time');
      return;
    }
    if (widget.eventStart != null && _start!.isBefore(widget.eventStart!)) {
      _snack('Session cannot start before the event');
      return;
    }
    if (widget.eventEnd != null && _end!.isAfter(widget.eventEnd!)) {
      _snack('Session cannot end after the event');
      return;
    }

    final s = EventSession(
      id: widget.existing?.id,
      event: widget.existing?.event,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      speaker: _speakerCtrl.text.trim(),
      location: _locCtrl.text.trim(),
      startTime: _start!,
      endTime: _end!,
    );
    Navigator.of(context).pop(s);
  }

  void _snack(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
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
              Text(_isEdit ?  context.tr.editSession : context.tr.addSession,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  labelText: '${context.tr.title} *',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Required'
                    : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _speakerCtrl,
                decoration:  InputDecoration(
                  labelText: context.tr.speaker,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _locCtrl,
                decoration: InputDecoration(
                  labelText:  context.tr.location,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText:  context.tr.description,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: () => _pick(isStart: true),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: '${context.tr.startDate} *',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_start == null
                      ? 'Select date & time'
                      : DateFormat('dd MMM yyyy, HH:mm').format(_start!)),
                ),
              ),
              const SizedBox(height: 12),

              InkWell(
                onTap: () => _pick(isStart: false),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: '${context.tr.endDate}*',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_end == null
                      ? 'Select date & time'
                      : DateFormat('dd MMM yyyy, HH:mm').format(_end!)),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(_isEdit ?  context.tr.updateSession :  context.tr.createSession,
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}