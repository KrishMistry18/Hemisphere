<div align="center">

# 🏘️ HemiSphere

**AI-Powered Smart Community Mobile App**

[![Live Demo](https://img.shields.io/badge/🔗_Live_Demo-hemisphere--dev.vercel.app-0070f3?style=for-the-badge)](https://hemisphere-dev.vercel.app)
[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)](https://firebase.google.com)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-%23FF6F00.svg?style=for-the-badge&logo=TensorFlow&logoColor=white)](https://tensorflow.org)

*Your neighbourhood's unified operating system — safety, community, and environment in one app.*

</div>

---

## 🎯 The Problem

Neighbourhood apps today are fragmented — one for safety alerts, another for community chat, another for reporting issues. HemiSphere unifies all of this with AI-driven insights, on-device ML, and real-time communication into a single platform.

---

## ✨ Key Features

| Feature | Description |
|---|---|
| 🤖 **AI Incident Detection** | On-device MobileNetV3 CNN (via TensorFlow Lite) classifies accidents, garbage, and construction from images in real time |
| 🗺️ **Interactive Map & GPS** | Powered by `flutter_map` + Mapbox; pin reports, incidents, or events with precise location tagging |
| 🚨 **SOS & Safety Reporting** | One-tap SOS with automatic location tagging and emergency contact alerts |
| 💬 **Community Hub & Chat** | Real-time community feeds, 1-on-1 messaging, and neighbourhood alerts |
| 🌱 **CO₂ Emissions Tracker** | Neural network models estimate and log carbon footprint from daily routines and vehicles |
| 🗑️ **Waste Classification** | Image classification model categorizes garbage to streamline community cleanup efforts |
| 🎨 **Custom Design System** | ClashDisplay + Satoshi typography, bespoke colour palette, full dark/light theming |

---

## 🧠 On-Device ML Models

HemiSphere runs inference locally on the device for privacy and speed:

| Model | Purpose |
|---|---|
| `safety_model.tflite` | Neighbourhood safety scoring from environmental inputs |
| `garbage_classification_model.tflite` | Image-based waste detection and categorization |
| `emissions_model.tflite` | Carbon emission estimation from vehicle/routine data |
| `emissions_model_2.tflite` | Secondary emissions model (cross-validation) |

*Advanced NLP tasks offloaded to Groq LLM API.*

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart) ^3.11.1
- **Backend & Auth:** Firebase Auth + Cloud Firestore
- **Maps:** `flutter_map`, `latlong2`, `geolocator`, Mapbox APIs
- **Machine Learning:** `tflite_flutter` (on-device), Groq LLM (cloud NLP)
- **State Management:** `provider` + `ValueNotifier`
- **Design:** Custom typography (ClashDisplay, Satoshi), `flutter_svg`, `flutter_native_splash`

---

## 🚀 Getting Started

### Prerequisites

1. [Flutter SDK](https://docs.flutter.dev/get-started/install) ^3.11.1
2. Android Studio / Xcode for native compilation
3. `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from your Firebase project

### Setup

```bash
# Clone the repo
git clone https://github.com/KrishMistry18/Hemisphere.git
cd Hemisphere

# Install dependencies
flutter pub get
```

Create a `.env` file in the root:

```
GROQ_API_KEY=your_groq_key
MAPBOX_ACCESS_TOKEN=your_mapbox_token
```

### Run

```bash
flutter run
```

### Build Release APK

```powershell
# Auto bumps version, obfuscates Dart code, builds APK
.\build_app.ps1 -Release
# Output: build\app\outputs\flutter-apk\app-release.apk
```

---

## 📁 Directory Structure

```
hemisphere/
├── assets/
│   ├── fonts/          # ClashDisplay, Satoshi
│   ├── images/         # SVG & PNG assets
│   └── models/         # TensorFlow Lite models (*.tflite)
├── lib/
│   ├── data/           # Local data layers
│   ├── models/         # Dart data classes
│   ├── providers/      # State management (ChangeNotifiers)
│   ├── screens/
│   │   ├── auth/       # Login & authentication flow
│   │   ├── community/  # Feeds, posts, chat
│   │   ├── map/        # Mapbox map views
│   │   ├── profile/    # Profile, settings, emissions logger
│   │   └── report/     # SOS + incident reporting
│   ├── services/       # Firebase, Auth, external APIs
│   ├── theme/          # Colors, text styles, theming
│   └── widgets/        # Reusable UI components
└── pubspec.yaml
```

---

## 🏆 Recognition

Built and showcased at **Colloquium '25** — earned Runner-Up among competing teams.

---

## 📄 License

MIT © [Krish Mistry](https://github.com/KrishMistry18)
