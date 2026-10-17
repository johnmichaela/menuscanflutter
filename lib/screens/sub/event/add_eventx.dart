import 'dart:convert';
import 'package:ballon/pagination/data/data_source/urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  // 🔧 CHANGE THIS to your API base URL
  // static const String baseUrl = 'https://your-api.com/api';
  static final String endpoint = '${Urls.baseUrl}/events-timetable/api/events/';

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // 'Authorization': 'Bearer YOUR_TOKEN',
  };

  List<Event> _events = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  // ============================================================
  // GET
  // ============================================================
  Future<void> _loadEvents() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await http.get(Uri.parse(endpoint), headers: _headers);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List list = data is List ? data : (data['data'] ?? []);
        setState(() {
          _events = list.map((e) => Event.fromJson(e)).toList();
        });
      } else {
        setState(() => _error = 'Failed to load (${res.statusCode})');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  // ============================================================
  // POST (create)
  // ============================================================
  Future<bool> _createEvent(Event event) async {
    try {
      final res = await http.post(
        Uri.parse(endpoint),
        headers: _headers,
        body: jsonEncode(event.toJson()),
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        await _loadEvents();
        return true;
      }
      _error = 'Create failed (${res.statusCode})';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // ============================================================
  // PUT (update)
  // ============================================================
  Future<bool> _updateEvent(Event event) async {
    try {
      final res = await http.put(
        Uri.parse('$endpoint/${event.id}'),
        headers: _headers,
        body: jsonEncode(event.toJson()),
      );

      if (res.statusCode == 200) {
        await _loadEvents();
        return true;
      }
      _error = 'Update failed (${res.statusCode})';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // ============================================================
  // DELETE
  // ============================================================
  Future<bool> _deleteEvent(int id) async {
    try {
      final res = await http.delete(
        Uri.parse('$endpoint/$id'),
        headers: _headers,
      );

      if (res.statusCode == 200 || res.statusCode == 204) {
        setState(() => _events.removeWhere((e) => e.id == id));
        return true;
      }
      _error = 'Delete failed (${res.statusCode})';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    }
  }

  // ============================================================
  // ADD / EDIT — modal bottom sheet form
  // ============================================================
  Future<void> _openForm({Event? event}) async {
    final isEdit = event != null;

    final titleCtrl = TextEditingController(text: event?.title ?? '');
    final descCtrl = TextEditingController(text: event?.description ?? '');
    final locationCtrl = TextEditingController(text: event?.location ?? '');
    DateTime? startDate = event?.startDate;
    DateTime? endDate = event?.endDate;
    String status = event?.status ?? 'upcoming';
    bool saving = false;
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            Future<void> pickDate({required bool isStart}) async {
              final initial = (isStart ? startDate : endDate) ?? DateTime.now();
              final picked = await showDatePicker(
                context: ctx,
                initialDate: initial,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked == null) return;
              final time = await showTimePicker(
                context: ctx,
                initialTime: TimeOfDay.fromDateTime(initial),
              );
              final finalDate = DateTime(
                picked.year, picked.month, picked.day,
                time?.hour ?? 0, time?.minute ?? 0,
              );
              setSheetState(() {
                if (isStart) {
                  startDate = finalDate;
                  if (endDate == null || endDate!.isBefore(finalDate)) {
                    endDate = finalDate;
                  }
                } else {
                  endDate = finalDate;
                }
              });
            }

            Future<void> submit() async {
              if (!formKey.currentState!.validate()) return;
              if (startDate == null || endDate == null) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Please select start & end dates')),
                );
                return;
              }
              if (endDate!.isBefore(startDate!)) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('End date must be after start date')),
                );
                return;
              }

              setSheetState(() => saving = true);

              final newEvent = Event(
                id: event?.id,
                title: titleCtrl.text.trim(),
                description: descCtrl.text.trim(),
                location: locationCtrl.text.trim(),
                startDate: startDate!,
                endDate: endDate!,
                status: status,
                imageUrl: event?.imageUrl,
              );

              final ok = isEdit
                  ? await _updateEvent(newEvent)
                  : await _createEvent(newEvent);

              setSheetState(() => saving = false);

              if (!mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ok
                        ? (isEdit ? 'Event updated' : 'Event created')
                        : (_error ?? 'Something went wrong'),
                  ),
                ),
              );
            }

            String fmt(DateTime? d) => d == null
                ? 'Select date & time'
                : DateFormat('dd MMM yyyy, HH:mm').format(d);

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        isEdit ? 'Edit Event' : 'Add Event',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: titleCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Title *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Title required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: locationCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Location *',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Location required'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: descCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      InkWell(
                        onTap: () => pickDate(isStart: true),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Start Date & Time *',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(fmt(startDate)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      InkWell(
                        onTap: () => pickDate(isStart: false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'End Date & Time *',
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          child: Text(fmt(endDate)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: status,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'upcoming', child: Text('Upcoming')),
                          DropdownMenuItem(value: 'ongoing', child: Text('Ongoing')),
                          DropdownMenuItem(value: 'completed', child: Text('Completed')),
                          DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
                        ],
                        onChanged: (v) =>
                            setSheetState(() => status = v ?? 'upcoming'),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton.icon(
                        onPressed: saving ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Icon(isEdit ? Icons.save : Icons.add),
                        label: Text(
                          saving
                              ? 'Saving...'
                              : (isEdit ? 'Update Event' : 'Create Event'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    titleCtrl.dispose();
    descCtrl.dispose();
    locationCtrl.dispose();
  }

  // ============================================================
  // DELETE confirmation
  // ============================================================
  Future<void> _confirmDelete(Event event) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Delete "${event.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (ok != true) return;
    if (!mounted) return;

    final success = await _deleteEvent(event.id!);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Event deleted' : (_error ?? 'Delete failed')),
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Event', style: TextStyle(color: Colors.white)),
        onPressed: () => _openForm(),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading && _events.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadEvents, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_events.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No events yet'),
            const SizedBox(height: 4),
            Text(
              'Tap + to create your first event',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _events.length,
        itemBuilder: (_, i) {
          final e = _events[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.teal.shade100,
                        child: const Icon(Icons.event, color: Colors.teal),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          e.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      _statusChip(e.status),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(child: Text(e.location)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${DateFormat('dd MMM yyyy HH:mm').format(e.startDate)}'
                          '  →  '
                          '${DateFormat('dd MMM yyyy HH:mm').format(e.endDate)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  if (e.description.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      e.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => _openForm(event: e),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text('Edit'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.teal,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _confirmDelete(e),
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    Color color;
    switch (status) {
      case 'ongoing':
        color = Colors.orange;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Event {
  final int? id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? imageUrl;
  final String status;

  Event({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.imageUrl,
    this.status = 'upcoming',
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}'),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      startDate: DateTime.parse(json['start_date'] ?? json['startDate']),
      endDate: DateTime.parse(json['end_date'] ?? json['endDate']),
      imageUrl: json['image_url'] ?? json['imageUrl'],
      status: json['status'] ?? 'upcoming',
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'title': title,
        'description': description,
        'location': location,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'image_url': imageUrl,
        'status': status,
      };
}