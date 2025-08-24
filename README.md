🚀 Cargo Pro Assignments - Flutter App  

A complete Flutter solution showcasing OTP authentication, RESTful API integration, CRUD operations, pagination, and a polished UI — powered by GetX.  

---

📋 Overview  
This app demonstrates a production-ready architecture with:  

- 🔐 Custom Phone OTP Authentication  
- 🔄 RESTful API Integration with full CRUD + Pagination  
- ⚠️ Robust Error Handling & user-friendly feedback  
- 📱 Responsive UI for Mobile, Tablet, and Web  
- ⚙️ GetX for state management & navigation  

---

🔐 Setup Guide

- Create a Firebase project
- https://console.firebase.google.com

Register your app(s):

Android, iOS: download google-services.json (Android) or GoogleService-Info.plist (iOS)

Web: copy Firebase config snippet to web/index.html

Enable Phone Authentication
In Firebase Console: Auth > Sign-in method

Platform configuration:

Android: add internet permissions, update Gradle, place google-services.json

iOS: configure URL types, add GoogleService-Info.plist

Web: add domain (e.g., localhost) to Firebase hosting/allowed domains

Initialize Firebase

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

✨ Features  

🔑 Authentication  
- Login with a hardcoded phone number:+1234567890  
- Custom 6-digit OTP generation (shown in console for demo)  
- Persistent login state using shared_preferences  
- Logout functionality  

📡 API Data Handling  
- Fetch paginated list of objects from REST API  
- View details for each object  
- Create / Update objects with JSON input  
- Delete with confirmation dialogs  

🎨 UI/UX Enhancements  
- ⏳ Loading indicators during requests  
- ✅ Real-time error & success messages (snackbars)  
- 📝 JSON validation on create/edit  
- 📱 Adaptive & polished design across screen sizes  

---

## 📂 Project Structure  

lib/
├── controllers/  GetX controllers (Auth, API)
├── models/  Data models (ApiObject)
├── services/  API service classes
├── views/  UI screens
├── utils/ theme files


🎯 Usage

- Launch the app and enter phone: +1234567890
- Tap Send OTP (check console for OTP)
- Enter OTP → Login
- Browse paginated objects
- Tap item → View details
- Use ➕ button → Create object (JSON input)
- Edit/Delete objects → with confirmation dialogs

⚠️ Limitations


- SMS delivery for phone auth may not work in all regions or emulator configs
- Firebase phone auth is not available on desktop platforms
- No UI for reCAPTCHA fallback on web
- No advanced error recovery (e.g., rate limiting, auth throttling)
- Minimal handling of edge cases (multi-factor, repeated invalid code)

🚧 Future Improvements


- Alerting for blocked/invalid numbers
- Integration with more providers (Google, Apple, etc.)
- Advanced error handling and analytics reporting
- UI/UX polish, phone field masking, and accessibility improvements

Drive Link:
https://drive.google.com/drive/folders/1VksQSmnhlwWVjxF1ZoKCbglnqvQOIVm4?usp=sharing
