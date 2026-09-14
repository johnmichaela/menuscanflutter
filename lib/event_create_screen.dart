// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'app_state.dart';
// import 'models.dart';
// import 'auth_screens.dart';

// /// Screen for the user to create a new event.
// class EventCreateScreen extends StatefulWidget {
//   const EventCreateScreen({super.key});

//   @override
//   State<EventCreateScreen> createState() => _EventCreateScreenState();
// }

// class _EventCreateScreenState extends State<EventCreateScreen> {
//   final _titleCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _locationCtrl = TextEditingController();
//   final _timeCtrl = TextEditingController();
//   final _imageCtrl = TextEditingController();

//   DateTime? _date;
//   String _category = 'Music';
//   bool _loading = false;

//   static const _categories = [
//     'Music',
//     'Family',
//     'Food & Drink',
//     'Sports',
//     'Art',
//     'Tech',
//     'Business',
//     'Other',
//   ];

//   @override
//   void dispose() {
//     _titleCtrl.dispose();
//     _descCtrl.dispose();
//     _locationCtrl.dispose();
//     _timeCtrl.dispose();
//     _imageCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: _date ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime.now().add(const Duration(days: 730)),
//     );
//     if (picked != null) setState(() => _date = picked);
//   }

//   Future<void> _submit() async {
//     final app = Provider.of<AppState>(context, listen: false);
//     if (!app.isLoggedIn) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please login to create an event')),
//       );
//       Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
//       return;
//     }
//     if (_titleCtrl.text.trim().isEmpty) {
//       _toast('Please enter an event title');
//       return;
//     }
//     if (_date == null) {
//       _toast('Please pick an event date');
//       return;
//     }

//     setState(() => _loading = true);
//     final draft = EventModel(
//       id: 0,
//       title: _titleCtrl.text.trim(),
//       description: _descCtrl.text.trim(),
//       location: _locationCtrl.text.trim(),
//       date:
//           '${_date!.year.toString().padLeft(4, '0')}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}',
//       time: _timeCtrl.text.trim(),
//       image: _imageCtrl.text.trim(),
//       category: _category,
//     );
//     try {
//       await app.createEvent(draft);
//       if (mounted) {
//         _toast('Event created successfully!');
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       if (mounted) _toast('Failed to create event. Try again.');
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _toast(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F7),
//       appBar: AppBar(
//         title: const Text('Create Event'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//         centerTitle: true,
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           TextField(
//             controller: _titleCtrl,
//             decoration: const InputDecoration(
//               labelText: 'Event Title',
//               prefixIcon: Icon(Icons.event),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 14),
//           TextField(
//             controller: _descCtrl,
//             decoration: const InputDecoration(
//               labelText: 'Description',
//               prefixIcon: Icon(Icons.description_outlined),
//               border: OutlineInputBorder(),
//             ),
//             maxLines: 3,
//           ),
//           const SizedBox(height: 14),
//           TextField(
//             controller: _locationCtrl,
//             decoration: const InputDecoration(
//               labelText: 'Location / Venue',
//               prefixIcon: Icon(Icons.location_on_outlined),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 14),
//           // Date picker
//           InkWell(
//             onTap: _pickDate,
//             child: InputDecorator(
//               decoration: const InputDecoration(
//                 labelText: 'Event Date',
//                 prefixIcon: Icon(Icons.calendar_today_outlined),
//                 border: OutlineInputBorder(),
//               ),
//               child: Text(
//                 _date == null
//                     ? 'Select date'
//                     : '${_date!.day}/${_date!.month}/${_date!.year}',
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//           const SizedBox(height: 14),
//           TextField(
//             controller: _timeCtrl,
//             decoration: const InputDecoration(
//               labelText: 'Time (e.g. 6:00 PM – 11:00 PM)',
//               prefixIcon: Icon(Icons.access_time),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 14),
//           TextField(
//             controller: _imageCtrl,
//             keyboardType: TextInputType.url,
//             decoration: const InputDecoration(
//               labelText: 'Image URL',
//               prefixIcon: Icon(Icons.image_outlined),
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 14),
//           // Category dropdown
//           InputDecorator(
//             decoration: const InputDecoration(
//               labelText: 'Category',
//               prefixIcon: Icon(Icons.category_outlined),
//               border: OutlineInputBorder(),
//             ),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _category,
//                 isExpanded: true,
//                 items: _categories
//                     .map((c) => DropdownMenuItem(value: c, child: Text(c)))
//                     .toList(),
//                 onChanged: (v) => setState(() => _category = v ?? _category),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton(
//             onPressed: _loading ? null : _submit,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFFE71D36),
//               padding: const EdgeInsets.symmetric(vertical: 16),
//             ),
//             child: _loading
//                 ? const SizedBox(
//                     height: 22,
//                     width: 22,
//                     child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                   )
//                 : const Text('Create Event', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           ),
//         ],
//       ),
//     );
//   }
// }
