# cyberlog

# What I've learned
-> Native vs Cross-Platform
 -Native apps (Android → Kotlin/Java, iOS → Swift) are built separately for each platform, giving maximum performance but requiring two different codebases.
 -Cross-platform frameworks like Flutter, React Native, and Xamarin let developers use one codebase for multiple platforms, reducing development time and effort.

->Why we use Flutter
  Flutter uses Dart and allows building apps for Android, iOS, Web, Windows, macOS, and Linux from a single codebase.It uses the Skia rendering engine, which draws its own UI instead of relying on native components—giving smooth, consistent, high-FPS performance across devices.Its widget-based architecture makes UI creation extremely flexible and customizable.

->Hot Reload & Widgets
   Hot Reload instantly refreshes the UI after code changes without restarting the app, making development faster and more interactive . Flutter apps are built using a widget tree, where every element—text, buttons, layouts—is a widget.

 It provides:
 -StatelessWidget for static UI
 
 -StatefulWidget for dynamic, interactive UI

# Steps to Install & Run Flutter App

1. Download Flutter ZIP from the official website.

2. Unzip the folder anywhere on your PC.

3. Open the unzipped folder → go inside → copy the path of the bin folder.

4. Go to Environment Variables → Path → Add New → paste the bin path.

5. Install Android Studio.

6. Inside Android Studio, install:

   -Android SDK

   -SDK Tools

   -Android Virtual Device (AVD)

7. Open Android Studio → Open Project → select your Flutter project folder.

8. Select a Virtual Device (Emulator) and click Run.


<img width="1080" height="2424" alt="image" src="https://github.com/user-attachments/assets/c7a96daf-f415-43a7-89f3-56f112a411cc" />

