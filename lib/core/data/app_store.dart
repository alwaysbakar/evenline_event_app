import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Event {
  const Event({required this.id, required this.title, required this.category, required this.date, required this.time, required this.venue, required this.description, required this.price, required this.capacity, required this.color, this.organizer = 'Evenline hosts'});
  final String id;
  final String title;
  final String category;
  final String date;
  final String time;
  final String venue;
  final String description;
  final double price;
  final int capacity;
  final int color;
  final String organizer;

  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Event(id: snapshot.id, title: data['title'] as String? ?? '', category: data['category'] as String? ?? 'Community', date: data['date'] as String? ?? '', time: data['time'] as String? ?? '', venue: data['venue'] as String? ?? '', description: data['description'] as String? ?? '', price: (data['price'] as num?)?.toDouble() ?? 0, capacity: data['capacity'] as int? ?? 0, color: data['color'] as int? ?? 0xFFC6D8D1, organizer: data['organizer'] as String? ?? 'Evenline hosts');
  }

  Map<String, Object> toFirestore() => {'title': title, 'category': category, 'date': date, 'time': time, 'venue': venue, 'description': description, 'price': price, 'capacity': capacity, 'color': color, 'organizer': organizer};
}

class Booking {
  const Booking({required this.id, required this.eventId, required this.quantity});
  final String id;
  final String eventId;
  final int quantity;
  factory Booking.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) => Booking(id: snapshot.id, eventId: snapshot.data()?['eventId'] as String? ?? '', quantity: snapshot.data()?['quantity'] as int? ?? 1);
}

class AppStore extends ChangeNotifier {
  AppStore(this.preferences, {this.useFirebase = false});
  final SharedPreferences preferences;
  final bool useFirebase;
  final List<Booking> _bookings = [];
  final List<Event> _events = [];
  String? _email;
  String? _name;

  List<Event> get events => List.unmodifiable(_events);
  List<Booking> get bookings => List.unmodifiable(_bookings);
  String? get email => useFirebase ? FirebaseAuth.instance.currentUser?.email : _email;
  String get displayName => useFirebase ? (_name ?? FirebaseAuth.instance.currentUser?.displayName ?? 'Alex') : _name ?? 'Alex';
  bool get isSignedIn => useFirebase ? FirebaseAuth.instance.currentUser != null : _email != null;
  CollectionReference<Map<String, dynamic>> get _eventCollection => FirebaseFirestore.instance.collection('events');

  Future<void> load() async {
    if (!useFirebase) {
      _email = preferences.getString('account_email');
      _name = preferences.getString('account_name');
      final saved = preferences.getStringList('bookings') ?? <String>[];
      _bookings..clear()..addAll(saved.map((value) { final data = jsonDecode(value) as Map<String, dynamic>; return Booking(id: data['id'] as String, eventId: data['eventId'] as String, quantity: data['quantity'] as int); }));
      _events..clear()..addAll(_defaultEvents);
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    final events = await _eventCollection.orderBy('date').get();
    if (events.docs.isEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      for (final event in _defaultEvents) {
        batch.set(_eventCollection.doc(event.id), event.toFirestore());
      }
      await batch.commit();
      _events..clear()..addAll(_defaultEvents);
    } else {
      _events..clear()..addAll(events.docs.map(Event.fromFirestore));
    }
    if (user != null) {
      final profile = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      _name = profile.data()?['name'] as String? ?? user.displayName;
      final bookings = await FirebaseFirestore.instance.collection('users').doc(user.uid).collection('bookings').get();
      _bookings..clear()..addAll(bookings.docs.map(Booking.fromFirestore));
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    if (useFirebase) { await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password); await load(); notifyListeners(); return true; }
    if (!email.contains('@') || password.length < 6) return false;
    _email = email.trim(); _name = email.split('@').first; await _persistLocalAccount(); notifyListeners(); return true;
  }

  Future<bool> signUp(String name, String email, String password) async {
    if (useFirebase) { final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.trim(), password: password); await credential.user!.updateDisplayName(name.trim()); await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({'name': name.trim(), 'email': email.trim(), 'createdAt': FieldValue.serverTimestamp()}); await load(); notifyListeners(); return true; }
    if (name.trim().isEmpty || !email.contains('@') || password.length < 6) return false;
    _name = name.trim(); _email = email.trim(); await _persistLocalAccount(); notifyListeners(); return true;
  }

  Future<void> sendPasswordReset(String email) async {
    if (useFirebase) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      return;
    }
    if (!email.contains('@')) throw const FormatException('Enter a valid email');
  }

  Future<void> signOut() async { if (useFirebase) { await FirebaseAuth.instance.signOut(); } else { _email = null; _name = null; await preferences.remove('account_email'); await preferences.remove('account_name'); } _bookings.clear(); notifyListeners(); }
  Event eventById(String id) => _events.firstWhere((event) => event.id == id);
  bool hasBooking(String eventId) => _bookings.any((booking) => booking.eventId == eventId);

  Future<void> book(Event event, int quantity) async {
    if (useFirebase) {
      final user = FirebaseAuth.instance.currentUser!;
      final bookingRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('bookings').doc(event.id);
      await FirebaseFirestore.instance.runTransaction((transaction) async { final eventSnapshot = await transaction.get(_eventCollection.doc(event.id)); final available = eventSnapshot.data()?['capacity'] as int? ?? 0; if (available < quantity) throw StateError('Not enough tickets available'); transaction.update(eventSnapshot.reference, {'capacity': available - quantity}); transaction.set(bookingRef, {'eventId': event.id, 'quantity': quantity, 'eventTitle': event.title, 'createdAt': FieldValue.serverTimestamp()}); });
      await load(); return;
    }
    final booking = Booking(id: event.id, eventId: event.id, quantity: quantity); _bookings.removeWhere((item) => item.eventId == event.id); _bookings.add(booking); await _persistLocalBookings(); notifyListeners();
  }

  Future<void> cancelBooking(String bookingId) async {
    if (useFirebase) {
      final user = FirebaseAuth.instance.currentUser!;
      final bookingRef = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('bookings').doc(bookingId);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final bookingSnapshot = await transaction.get(bookingRef);
        final bookingData = bookingSnapshot.data();
        if (bookingData == null) return;
        final eventRef = _eventCollection.doc(bookingData['eventId'] as String);
        final eventSnapshot = await transaction.get(eventRef);
        final capacity = eventSnapshot.data()?['capacity'] as int? ?? 0;
        transaction.update(eventRef, {'capacity': capacity + (bookingData['quantity'] as int? ?? 1)});
        transaction.delete(bookingRef);
      });
      await load();
      return;
    }
    _bookings.removeWhere((booking) => booking.id == bookingId);
    await _persistLocalBookings();
    notifyListeners();
  }

  Future<void> createEvent({required String title, required String category, required String date, required String time, required String venue, required double price}) async {
    final event = Event(id: '', title: title, category: category, date: date, time: time, venue: venue, description: 'A new gathering created by $displayName.', price: price, capacity: 80, color: 0xFFC6D8D1, organizer: displayName);
    if (useFirebase) { await _eventCollection.add(event.toFirestore()); await load(); return; }
    _events.add(Event(id: 'custom-${DateTime.now().millisecondsSinceEpoch}', title: event.title, category: event.category, date: event.date, time: event.time, venue: event.venue, description: event.description, price: event.price, capacity: event.capacity, color: event.color, organizer: event.organizer)); notifyListeners();
  }

  Future<void> _persistLocalAccount() async { await preferences.setString('account_email', _email!); await preferences.setString('account_name', _name!); }
  Future<void> _persistLocalBookings() async => preferences.setStringList('bookings', _bookings.map((booking) => jsonEncode({'id': booking.id, 'eventId': booking.eventId, 'quantity': booking.quantity})).toList());
}

const _defaultEvents = <Event>[
  Event(id: 'sunday-social', title: 'The Sunday Social', category: 'Food', date: 'Sat, Jun 22', time: '7:00 PM', venue: 'Hearth House', description: 'An easygoing evening of shared plates, live records, and good conversation.', price: 24, capacity: 60, color: 0xFFB7C7B0),
  Event(id: 'gallery-night', title: 'Night at the Gallery', category: 'Art', date: 'Thu, Jun 27', time: '8:00 PM', venue: 'Northline Gallery', description: 'A late opening with new work, local pours, and a room full of curious people.', price: 18, capacity: 40, color: 0xFFE6B4A8),
  Event(id: 'future-sound', title: 'Future Sound', category: 'Music', date: 'Fri, Jul 05', time: '9:00 PM', venue: 'The Foundry', description: 'Three boundary-pushing live acts in one warm, loud, unforgettable night.', price: 32, capacity: 120, color: 0xFFD8C7A0),
];