# cyberlog

# What I've learned (Session 2)

# Principles of JIT vs. AOT
JIT (Just-In-Time) Compilation

 -JIT compiles the Dart code while the app is running.

 -It makes development fast because it supports Hot Reload.

 -When you test your Even/Odd app in debug mode, Flutter uses JIT so changes in your code appear instantly.

AOT (Ahead-Of-Time) Compilation

 -AOT compiles the Dart code before the app runs.

 -This gives better performance and faster startup time.

 -When you build a release APK of your Even/Odd app, Flutter uses AOT so it runs smoothly on the device.

# How I used Dart's Conditionals to perform the Even / Odd check
In my app, I used an if–else statement to check whether the number is even or odd.
I applied the modulus operator % to see if the number is divisible by 2:

if (number % 2 == 0) {
  resultMessage = "The number $number is Even.";
} else {
  resultMessage = "The number $number is Odd.";
}

If the remainder is 0, it’s even; otherwise, it’s odd.

# String Interpolation
I used Dart’s string interpolation ($variable) to display the result message.
This allows me to insert the number directly inside the text:

resultMessage = "The number $number is Even.";


It makes the message dynamic and easy to format.
