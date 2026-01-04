# cybershield

CyberShield is a Flutter-based security application created to understand and apply real-world mobile security concepts. Instead of focusing only on UI, this project concentrates on how sensitive data should be securely stored, accessed, and protected inside a mobile app. The main goal of CyberShield is to build a secure vault that prevents unauthorized access, reduces data exposure, and follows practical cybersecurity principles.

While building CyberShield, I implemented a complete vault authentication system using device-level security such as system PIN, pattern, or biometric authentication. I learned how to restrict access to sensitive screens until authentication is successful and how critical it is to re-lock protected data when the application goes into the background, becomes inactive, or is left idle. This helped me understand session-based security and how real applications protect users even when they forget to lock the app manually.

The project taught me how sensitive information should be stored and displayed responsibly. Secrets inside the vault are masked by default and are only revealed temporarily during an active authenticated session. This reinforced the principle of least privilege and helped me understand why secure applications never expose sensitive data by default. Implementing visibility controls and automatic reset behavior showed me how small design decisions can significantly improve security.

By adding clipboard protection, I learned about indirect data leakage risks that are often ignored in basic applications. Copying secrets is allowed only with explicit user action, and the clipboard is automatically cleared after a short duration. This feature improved my understanding of real-world attack surfaces such as clipboard sniffing and how applications can reduce these risks even with platform limitations.

Auto-locking and inactivity timeout mechanisms helped me understand fail-safe security design. Any user interaction resets the session timer, while inactivity or lifecycle changes immediately lock the vault. Through this, I learned how secure systems assume user error and protect data proactively rather than relying on perfect user behavior.

---

<img width="600" height="2000" alt="Screenshot_20260104_194245" src="https://github.com/user-attachments/assets/9feca5fa-c06c-44b9-8bfe-1cb46f1340a8" />
<img width="600" height="2000" alt="Screenshot_20260104_194311" src="https://github.com/user-attachments/assets/377805dc-3c1c-4696-8738-19268034f13a" />


---

![WhatsApp Image 2026-01-04 at 19 35 18](https://github.com/user-attachments/assets/27655523-8ba1-4722-90c8-baf24683f198)

---

![WhatsApp Image 2026-01-04 at 19 35 17 (1)](https://github.com/user-attachments/assets/c272081d-91b5-4d02-933f-1e4e56c14154)

---

![WhatsApp Image 2026-01-04 at 19 35 17 (2)](https://github.com/user-attachments/assets/6a7838e5-6b54-419d-8429-0f83a215e4c6)

---
