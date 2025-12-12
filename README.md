# cyberlog

## Session 1

**What I've learned**

- > Native vs Cross-Platform -Native apps (Android → Kotlin/Java, iOS → Swift) are built separately for each platform, giving maximum performance but requiring two different codebases. -Cross-platform frameworks like Flutter, React Native, and Xamarin let developers use one codebase for multiple platforms, reducing development time and effort.
- >Why we use Flutter Flutter uses Dart and allows building apps for Android, iOS, Web, Windows, macOS, and Linux from a single codebase.It uses the Skia rendering engine, which draws its own UI instead of relying on native components—giving smooth, consistent, high-FPS performance across devices.Its widget-based architecture makes UI creation extremely flexible and customizable.
- >Hot Reload & Widgets Hot Reload instantly refreshes the UI after code changes without restarting the app, making development faster and more interactive . Flutter apps are built using a widget tree, where every element—text, buttons, layouts—is a widget.

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

<img width="700" height="2000" alt="Screenshot_20251212_173637" src="https://github.com/user-attachments/assets/4d3fb05e-e9f0-4283-9d4c-ba61d4dca819" />


---

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

Scaffold

 ├─ AppBar

 └─ Body
  
     └─ Column
     
          ├─ Text
          
          ├─ SizedBox
          
          └─ Button

<img width="700" height="2000" alt="Screenshot_20251211_164542" src="https://github.com/user-attachments/assets/a7dabe91-cbe9-4a01-818a-bceb7c6ca6f1" />


---

---

## Session 5

What I’ve learned
