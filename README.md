# HealHer 🌸

A women's health app that helps anyone manage PCOD/PCOS by tracking their cycle, symptoms, weight, and water intake, with awareness content, diet plans, and exercise guidance in one place.

## Features
- **Period tracking:** log cycle dates and view history
- **Symptom tracking:** record daily symptoms and spot patterns
- **Weight tracking:** monitor weight changes over time
- **Water intake tracking:** set a daily water goal and log progress
- **Awareness hub:** learn about PCOD/PCOS
- **Diet plans:** meal guidance suited to PCOD/PCOS
- **Exercise:** workout suggestions
- **Profile:** view and edit your personal info

## Tech Stack
- **Frontend:** Flutter (Dart)
- **Authentication:** Firebase Authentication (email and password)
- **Database:** Cloud Firestore

## Security
- Login with Firebase Authentication
- Firestore rules make sure each user can read and write only their own data

## Screenshots
[Add 4 to 6 screenshots here]

## Run Locally
1. Clone the repo:
   `git clone https://github.com/amaldamda23/healherr.git`
2. Install packages:
   `flutter pub get`
3. Create your own Firebase project and turn on **Authentication** (Email/Password) and **Cloud Firestore**.
4. Connect the app to your Firebase project:
   `flutterfire configure`
   This creates `lib/firebase_options.dart`, which is not included in this repo for security reasons.
5. Start the app:
   `flutter run`

## Planned Improvements
- Cycle predictions and reminders

## Author
Amal · amaldamda23@gmail.com
