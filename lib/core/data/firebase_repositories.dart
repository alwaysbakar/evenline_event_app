import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'app_store.dart';

class FirebaseEventRepository {
  FirebaseEventRepository(this.firestore);
  final FirebaseFirestore firestore;

  CollectionReference<Map<String, dynamic>> get events =>
      firestore.collection('events');

  Future<List<Event>> readEvents() async {
    final snapshot = await events
        .orderBy('date')
        .get(const GetOptions(source: Source.serverAndCache));
    return snapshot.docs.map(Event.fromFirestore).toList(growable: false);
  }

  Future<String> create({required Event event, required String ownerId}) async {
    final reference = await events.add({
      ...event.toFirestore(),
      'ownerId': ownerId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'quantityTotal': event.capacity,
      'quantitySold': 0,
    });
    return reference.id;
  }

  Future<void> update({
    required String eventId,
    required Map<String, Object?> values,
  }) async {
    await events.doc(eventId).update({
      ...values,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> delete(String eventId) => events.doc(eventId).delete();
}

class FirebaseUserRepository {
  FirebaseUserRepository(this.firestore);
  final FirebaseFirestore firestore;

  DocumentReference<Map<String, dynamic>> user(String uid) =>
      firestore.collection('users').doc(uid);

  Future<Map<String, dynamic>?> readProfile(String uid) async =>
      (await user(uid).get(const GetOptions(source: Source.serverAndCache)))
          .data();

  Future<void> writeProfile({
    required String uid,
    required String email,
    required String name,
    String role = 'attendee',
  }) async {
    await user(uid).set({
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<List<Booking>> readBookings(String uid) async {
    final snapshot = await user(uid)
        .collection('bookings')
        .orderBy('createdAt', descending: true)
        .get(const GetOptions(source: Source.serverAndCache));
    return snapshot.docs.map(Booking.fromFirestore).toList(growable: false);
  }

  Future<void> toggleFavorite({
    required String uid,
    required String eventId,
    required bool saved,
  }) async {
    final reference = user(uid).collection('favorites').doc(eventId);
    if (saved) {
      await reference.set({
        'eventId': eventId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await reference.delete();
    }
  }

  Future<bool> isFavorite({
    required String uid,
    required String eventId,
  }) async =>
      (await user(uid).collection('favorites').doc(eventId).get()).exists;

  Future<List<String>> readFavoriteIds(String uid) async =>
      (await user(uid).collection('favorites').get()).docs
          .map((doc) => doc.id)
          .toList(growable: false);

  Future<void> toggleFollowing({
    required String uid,
    required String organizerId,
    required bool following,
  }) async {
    final reference = user(uid).collection('following').doc(organizerId);
    if (following) {
      await reference.set({
        'organizerId': organizerId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } else {
      await reference.delete();
    }
  }

  Future<bool> isFollowing({
    required String uid,
    required String organizerId,
  }) async =>
      (await user(uid).collection('following').doc(organizerId).get()).exists;

  Future<List<String>> readFollowingIds(String uid) async =>
      (await user(uid).collection('following').get()).docs
          .map((doc) => doc.id)
          .toList(growable: false);

  Future<void> createBooking({
    required String uid,
    required Event event,
    required int quantity,
  }) async {
    if (quantity < 1) throw ArgumentError.value(quantity, 'quantity');
    final eventReference = firestore.collection('events').doc(event.id);
    final bookingReference = user(uid)
        .collection('bookings')
        .doc('${event.id}-${_token()}');
    await firestore.runTransaction((transaction) async {
      final eventSnapshot = await transaction.get(eventReference);
      final data = eventSnapshot.data();
      if (data == null) throw StateError('Event no longer exists');
      final total =
          (data['quantityTotal'] as num?)?.toInt() ??
          (data['capacity'] as num?)?.toInt() ??
          0;
      final sold = (data['quantitySold'] as num?)?.toInt() ?? 0;
      if (quantity > total - sold) {
        throw StateError('Not enough tickets available');
      }
      transaction.set(bookingReference, {
        'eventId': event.id,
        'eventTitle': event.title,
        'quantity': quantity,
        'status': 'issued',
        'token': _token(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      transaction.update(eventReference, {
        'quantitySold': sold + quantity,
        'capacity': total - sold - quantity,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> cancelBooking({
    required String uid,
    required String bookingId,
  }) async {
    final bookingReference = user(uid).collection('bookings').doc(bookingId);
    await firestore.runTransaction((transaction) async {
      final bookingSnapshot = await transaction.get(bookingReference);
      final data = bookingSnapshot.data();
      if (data == null) return;
      final eventReference = firestore
          .collection('events')
          .doc(data['eventId'] as String);
      final eventSnapshot = await transaction.get(eventReference);
      final eventData = eventSnapshot.data() ?? <String, dynamic>{};
      final sold = (eventData['quantitySold'] as num?)?.toInt() ?? 0;
      final quantity = (data['quantity'] as num?)?.toInt() ?? 1;
      transaction.update(eventReference, {
        'quantitySold': max(0, sold - quantity),
        'capacity': FieldValue.increment(quantity),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      transaction.delete(bookingReference);
    });
  }

  static String _token() => List<String>.generate(
    24,
    (_) => Random.secure().nextInt(36).toRadixString(36),
  ).join();
}

class FirebaseCheckInRepository {
  FirebaseCheckInRepository(this.firestore);
  final FirebaseFirestore firestore;

  Future<void> checkIn({
    required String token,
    required String organizerId,
  }) async {
    final matches = await firestore
        .collectionGroup('bookings')
        .where('token', isEqualTo: token)
        .limit(1)
        .get();
    if (matches.docs.isEmpty) throw StateError('Ticket not found');
    final ticket = matches.docs.first.reference;
    await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ticket);
      final data = snapshot.data();
      if (data == null) throw StateError('Ticket not found');
      if (data['status'] != 'issued') {
        throw StateError('Ticket already checked in');
      }
      transaction.update(ticket, {
        'status': 'checkedIn',
        'checkedInAt': FieldValue.serverTimestamp(),
        'checkedInBy': organizerId,
      });
    });
  }
}
