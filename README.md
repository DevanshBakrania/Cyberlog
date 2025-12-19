# cyberlog

## Session 1

**What I've learned**

-> Native vs Cross-Platform -Native apps (Android → Kotlin/Java, iOS → Swift) are built separately for each platform, giving maximum performance but requiring two different codebases. -Cross-platform frameworks like Flutter, React Native, and Xamarin let developers use one codebase for multiple platforms, reducing development time and effort.

->Why we use Flutter Flutter uses Dart and allows building apps for Android, iOS, Web, Windows, macOS, and Linux from a single codebase.It uses the Skia rendering engine, which draws its own UI instead of relying on native components—giving smooth, consistent, high-FPS performance across devices.Its widget-based architecture makes UI creation extremely flexible and customizable.

->Hot Reload & Widgets Hot Reload instantly refreshes the UI after code changes without restarting the app, making development faster and more interactive . Flutter apps are built using a widget tree, where every element—text, buttons, layouts—is a widget.

It provides:

- StatelessWidget for static UI
- StatefulWidget for dynamic, interactive UI

**Steps to Install & Run Flutter App**

1. Download Flutter ZIP from the official website.
2. Unzip the folder anywhere on your PC.
3. Open the unzipped folder → go inside → copy the path of the bin folder.
4. Go to Environment Variables → Path → Add New → paste the bin path.
5. Install Android Studio.
6. Inside Android Studio, install:
    - Android SDK
    - SDK Tools
    - Android Virtual Device (AVD)
7. Open Android Studio → Open Project → select your Flutter project folder.
8. Select a Virtual Device (Emulator) and click Run.

---

![fedd3748-fd4b-4487-94cd-741847b60e35](https://github.com/user-attachments/assets/68aab05b-dac7-4b23-b6e4-df5811110238)

---

## Session 2

**What I've learned**

→Core Principles of JIT vs AOT Compilation

### **JIT (Just-In-Time) Compilation**

- JIT compiles the Dart code **while the app is running**.
- It makes development fast because it supports **Hot Reload**.
- When you test your Even/Odd app in **debug mode**, Flutter uses JIT so changes in your code appear instantly.

### **AOT (Ahead-Of-Time) Compilation**

- AOT compiles the Dart code **before the app runs**.
- This gives **better performance** and **faster startup time**.
- When you build a **release APK** of your Even/Odd app, Flutter uses AOT so it runs smoothly on the device.

→**How Dart’s Conditionals Check Even/Odd (Short Explanation)**

In my app, I used an `if–else` statement to check whether the number is even or odd.

I applied the modulus operator `%` to see if the number is divisible by 2:

```
if (number % 2 == 0) {
  resultMessage = "The number $number is Even.";
} else {
  resultMessage = "The number $number is Odd.";
}
```

If the remainder is 0, it’s even; otherwise, it’s odd.

---

**→How String Interpolation Was Used (Short Explanation)**

I used Dart’s string interpolation (`$variable`) to display the result message.

This allows me to insert the number directly inside the text:

```
resultMessage = "The number $number is Even.";
```

It makes the message dynamic and easy to format.

---

![ddbe66e1-7e52-4511-89e2-7c2dddbc1728](https://github.com/user-attachments/assets/c1b261a7-0a00-4ff7-9aec-652116d8947f)

---

## Session 3

What I’ve learned

I created a **`Log` class** to organize each log entry, storing the action performed, the timestamp of the action, and its status (e.g., `"Success"`, `"Failed"`, `"Blocked"`). For example:

```
Log("Login Attempt", DateTime.now(), "Success")
```

represents a single log entry. Multiple logs are stored in a **`List<Log>`**, which allows us to manage and add new entries easily:

```
final List<Log> logs = [
  Log("Login Attempt", DateTime.now(), "Success"),
  Log("Password Change", DateTime.now(), "Failed"),
];
```

In the UI, we use **list iteration (`map`)** to dynamically generate a widget for each log, displaying its details automatically:

```
logs.map((log) => Text("${log.action} | ${log.timestamp.toLocal().toString().split(".")[0]} | ${log.status}")).toList()
```

Here I’ve used `.toLocal().toString().split(".")[0]` which formats the timestamp to **avoid milliseconds**, making it more readable. 

---

<img width="700" height="2000" alt="Screenshot_20251212_173637" src="https://github.com/user-attachments/assets/4d3fb05e-e9f0-4283-9d4c-ba61d4dca819" />

---

## Session 4

What I’ve learned

Flutter UI is built using widgets, and literally everything on the screen is a widget.
Widgets are arranged in a widget tree, where big widgets contain smaller ones (like LEGO blocks).

Flutter has two types of widgets:

StatelessWidget → UI that never changes

StatefulWidget → UI that updates using setState()

For example:
A StatelessWidget is used for fixed text or headers.
A StatefulWidget is used when the screen must change, like counters, buttons, or inputs.

We use Scaffold to build the main screen structure (AppBar + Body).
Inside the body, layout widgets like Column, Row, and SizedBox help arrange elements neatly.

Example structure:
```
Scaffold
 ├─ AppBar
 └─ Body
     └─ Column
          ├─ Text 
          ├─ SizedBox  
          └─ Button
```

<img width="700" height="2000" alt="Screenshot_20251211_164542" src="https://github.com/user-attachments/assets/a7dabe91-cbe9-4a01-818a-bceb7c6ca6f1" />

---

## Session 5

What I’ve learned

In this project, I built a CyberLog Dashboard using Flutter’s core layout widgets: Scaffold, AppBar, GridView, Container, Column, and Text. The dashboard displays four cards — Daily Log, Cyber Tips, Device Security, and Notes — arranged in a two-column layout using GridView.count, making the UI responsive, evenly spaced, and visually balanced.

Key properties used in the layout include:

-crossAxisCount: 2 → creates 2 columns

-childAspectRatio: 1 → ensures the cards are roughly square

-margin and padding → provide spacing around and inside each card

Each card is a Container with BoxDecoration, giving it a background color, rounded corners, and soft shadow, making the UI professional and visually appealing. Inside the Container, a Column is used to vertically center the icon and title, similar to how Column stacks widgets in login forms or profile screens.

By keeping the card titles in a list, the layout becomes data-driven, meaning we can change or add cards without modifying the UI. This demonstrates separation of data and UI, a principle used in real-world Flutter apps.

In this session I learned how to:

-Use GridView for multi-column layouts like dashboards and Instagram grids

-Style cards professionally with Container + BoxDecoration

-Organize content vertically using Column

-Apply spacing and alignment using padding, margin, and childAspectRatio

-Build a responsive, reusable, and data-driven UI in Flutter

---

<img width="700" height="2000" alt="Screenshot_20251212_180142" src="https://github.com/user-attachments/assets/aac0e726-11bc-4eba-85e0-186e1dd3d2ef" />

---

## Session 6

What I've learned

CyberLog is a Flutter-based dashboard application designed to demonstrate core UI concepts, navigation, and theming in Flutter. The app uses a BottomNavigationBar to switch between three main screens: Home, Logs, and Settings. The Home screen displays system status using card-based widgets, the Logs screen shows recent activity logs, and the Settings screen provides basic toggle options.

This project is built using Flutter and Dart with Material Design 3. It uses essential Flutter widgets such as MaterialApp, Scaffold, AppBar, Column, ListView, Card, ListTile, and SwitchListTile. Global theming is applied using ThemeData and ColorScheme to maintain a consistent and modern UI throughout the application.

Through this project, I learned how to structure a Flutter app using StatelessWidget and StatefulWidget, manage UI state using setState, implement bottom navigation, and apply global themes for better design consistency. This project helped strengthen my understanding of Flutter UI fundamentals and serves as a strong foundation for future feature enhancements.

---

<img width="700" height="2000" alt="Screenshot_20251215_170244" src="https://github.com/user-attachments/assets/6044164d-7dff-405b-9953-adcbf2717af5" /> 
<img width="700" height="2000" alt="Screenshot_20251215_170258" src="https://github.com/user-attachments/assets/29160a87-5e1d-4816-8c04-d83039d847be" /> 
<img width="700" height="2000" alt="Screenshot_20251215_170325" src="https://github.com/user-attachments/assets/537cc8cd-7fa6-4933-9f11-db09ce38a68c" />

---

## Session 7

What I've learned

CyberLog is a Flutter-based logging dashboard application designed to track actions or events with statuses such as Success, Failed, or Blocked. The app allows users to manually select the status of a log entry before adding it, while also supporting a default status set in the Settings screen. Logs are displayed in a dynamic, scrollable list with color-coded icons, timestamps, and a clear visual layout for easy identification. The Settings screen also provides options to toggle dark/light mode and update the default status.

This project is built using Flutter and Dart with Material Design 3. It uses essential Flutter widgets such as MaterialApp, Scaffold, AppBar, Column, Row, ListView, Card, ListTile, and ElevatedButton. State management is implemented using Provider, while ThemeData and ColorScheme are used to maintain a consistent and modern UI.

Through this project, I learned how to structure a Flutter app using StatelessWidget and StatefulWidget, manage state with Provider and setState, implement user-controlled status selection, and apply global theming for better design consistency. This project strengthened my understanding of Flutter UI fundamentals and serves as a strong foundation for building interactive and dynamic Flutter applications.

---

<img width="700" height="2000" alt="Screenshot_20251217_171503" src="https://github.com/user-attachments/assets/2673462f-4287-4def-8504-0bfa1162d469" />
<img width="700" height="2000" alt="Screenshot_20251217_171537" src="https://github.com/user-attachments/assets/ca19cdeb-e875-4258-aa61-dae4cb87ef04" />

---

## Session 8

What I've learned

Cyber Tip of the Day is a Flutter-based application designed to provide users with cybersecurity tips, both from an online API and a curated local list. The app fetches random tips from an external API whenever the user taps the “Get API Tip” button, while also offering a fallback option using over 100 pre-defined cybersecurity tips stored locally. Users can view tips in a clean, card-based UI, and a loading indicator shows when tips are being fetched from the API.

This project is built using Flutter and Dart with Material Design 3. It utilizes essential Flutter widgets such as MaterialApp, Scaffold, AppBar, Column, Container, Text, ElevatedButton, and CircularProgressIndicator. State management is handled using setState, and UI elements are styled with padding, rounded corners, and color differentiation to improve readability.

Through this project, I learned how to handle asynchronous API requests, implement fallback logic for offline support, manage state in Flutter apps, and design a user-friendly interface. This project strengthened my understanding of Flutter UI fundamentals, asynchronous programming, and creating reliable, interactive mobile applications

---

<img width="700" height="2000" alt="Screenshot_20251219_175226" src="https://github.com/user-attachments/assets/666e4c28-0d6f-4ddb-9d0c-e46f28ca184c" />


---
