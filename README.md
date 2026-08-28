# Evenline

Evenline is an event discovery and booking app backed by Firebase.

## Implemented flows

- Firebase Authentication sign-in, account creation, and sign-out
- Firestore event discovery and organizer event publishing
- Firestore booking transactions that decrement event capacity atomically
- Firestore attendee tickets with cancellation
- Persistent onboarding state and responsive attendee screens

## Firebase setup

The workspace does not contain a Firebase project configuration yet. Run this from the project root after installing the FlutterFire CLI:

```text
flutterfire configure
```

Enable Email/Password in Firebase Authentication and create the Firestore database. Add rules so users can read events, organizers can create their own events, and users can read and write only their own `users/{uid}/bookings` documents. The app initializes Firebase in `lib/main.dart` and uses `lib/core/data/app_store.dart` for Auth and Firestore operations.

The local mode in `AppStore` exists only so the widget test can run without network credentials; production startup passes `useFirebase: true`.