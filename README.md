# Drivo Medical Clinic + Doctor Dashboard

Professional hard-coded Flutter dashboard demo that matches the patient app flow.

## Included
- Clinic Admin / Doctor role switch
- Arabic + English with RTL / LTR
- Overview analytics
- Appointments with details, confirm, mark paid, complete
- Patient directory + medical profile
- Doctors + schedules
- Online consultation waiting room + video room demo
- Medical records preview
- Prescriptions workflow
- Follow-ups
- Services
- Payments
- Messages
- Notifications
- Reports
- Settings

No backend, Firebase, real payment, real video call, storage or notification provider is connected. It is a client-facing demo.

## Run
```bash
flutter pub get
flutter run -d chrome
```

## Build web
```bash
flutter build web --release
```

Output:
`build/web/`

If your local Flutter requires a freshly generated platform scaffold:
```bash
flutter create . --platforms=web
flutter pub get
flutter run -d chrome
```
