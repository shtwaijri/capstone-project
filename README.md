# 🛒 Qaimati

Qaimati is a mobile application developed as a capstone project using **Flutter** and **Dart**. It offers an innovative solution for families, individuals, and groups to manage and organize their shopping lists efficiently.

---
## 📱 Project Summary

The app addresses the problem of unorganized and inefficient shopping by providing a platform that keeps all members up to date with what needs to be bought and what has already been purchased. It helps users avoid forgotten items, duplicate purchases, and lack of coordination during shopping trips.

**Key Features:**
- Shared shopping lists for families or teams
- Real-time collaboration and updates
- Monthly expense tracking and spending insights
- Smart notifications 

---

## 🧠 Problem Solving

Qaimati solves the problem by:
- Allowing users to create and share shopping lists that update instantly as items are added, edited, or removed.
 - Providing spending history and analytics to improve budgeting and planning.
- Improving shopping efficiency and coordination, reducing wasted time and money.

 
 
---
## 📝 Project Description

**Qaimati** is a collaborative mobile application designed to simplify shopping list management for families, individuals, and groups. Developed using the **Flutter** framework and **Dart** programming language, the project aims to showcase innovative problem-solving and technical creativity while addressing real-world challenges.

The app allows users to create, manage, and share shopping lists seamlessly, ensuring efficient coordination and organization. With features like real-time synchronization, role-based permissions, receipt tracking, and expense management, **Qaimati** transforms the shopping experience into a streamlined and stress-free process.

By leveraging **Supabase** for backend services and real-time databases, **Bloc** for state management, and **GetIt** for dependency injection, this app ensures high performance, scalability, and user satisfaction. It is designed to support both **Android** and **iOS** platforms, making it accessible to a wide range of users.

**Key Highlights:**
- Address a specific problem of disorganized shopping and lack of coordination.
- Provide value by enabling shared shopping lists, detailed expense tracking, and smart notifications.
- Explore innovative ideas like AI-powered item suggestions and receipt parsing for enhanced usability.
- Deliver a polished, user-friendly interface supporting both **Arabic** and **English**.

Whether it's grocery shopping with family, managing shared household purchases, or tracking office supply expenses, **Qaimati** ensures users stay organized, save time, and reduce unnecessary costs.



## 🔧 Project Properties

* **Name**: Qaimati
* **Platform**: Mobile (Android and iOS)
* **Language**: Dart
* **Framework**: Flutter
* **State Management**: Bloc Pattern
* **Backend & Database**: Supabase
* **Dependency Injection**: GetIt
* **Notifications**: OneSignal (integrated with Firebase)
* **Development Methodology**: Agile (Sprint-based)

---

## 🖼️ Pictures to Apply

 
---

## ✅ Features That Will Be Added

Qaimati is designed as a powerful **productivity and collaboration app** to simplify shopping for everyone. It comes packed with essential features to make managing your lists and purchases seamless.
  
## ✨ Core Functionalities

- **📝 List Creation & Management:**  
  Easily create, update, or remove multiple shopping lists and keep them organized.

- **🛍️ Item Management:**  
  Add, edit, or delete items in real time across devices with instant synchronization.

- **🔄 Real-time Synchronization:**  
  All changes sync automatically across users’ devices, ensuring everyone stays up-to-date.

- **👥 User Invitation & Access Management:**  
  Share lists via email. The list creator is the **Admin** and can invite others to join as **Members**.

  - **🔐 Role-Based Permissions:**  
    - **Admin:** Full control over list and items, including viewing and managing receipts and members.  
    - **Members:** Can only manage the items they added.

- **🧾 Receipt Management & Expense Tracking:**  
  Admins can upload and view receipts related to each list for expense tracking and monthly spending insights.

- **🌍 Language & Theme Customization:**  
  Fully supports **Arabic** and **English**, with theme color personalization.

- **🔔 Smart Notifications:**  
  Integrated with **OneSignal** and **Firebase** to send real-time alerts when:
  - Items are added or updated.
  
- **📦 API Integration for Receipts:**  
  Receipts can be parsed using a third-party API for auto-filling purchase details (store name, total amount, etc.).

- ## 🌟 Premium Subscription Service

### Unlimited Invoices  
Unlock the full potential of our platform with the **Premium Subscription**.

With this plan, you can:
- 🧾 **Create and manage unlimited invoices**
- ✅ Perfect for both **business and personal use**
- 🔓 No limitations, full access to all invoicing too
 
---

## 🚀 Features That Will Be Added in the Future

Qaimati is designed with scalability in mind. The following features are planned for future releases to expand its functionality and enhance the user experience:

- **🛒 Integration with Online Stores:**  
  Link lists with major online retailers to enable direct shopping or price comparison.

- **📡 Offline Mode:**  
  Full offline functionality allowing users to manage lists and items without internet access. Data will automatically sync when back online.

- **🔔 Smart Reminder Notifications:**  
  Send scheduled or context-based reminders for important or time-sensitive items (e.g., "Don't forget milk!" or "You’re running low on eggs").

- **🧾 Smart Receipt Parsing via API:**  
  Integrate with third-party receipt scanning APIs to auto-extract store name, date, and total from uploaded receipts.

- **📊 Advanced Analytics:**  
  Provide detailed insights into user spending, most purchased items, and budgeting trends.

- **🔍 Item Suggestions:**  
  Use AI/ML to suggest frequently or recently used items for faster list creation.

- **📷 Barcode Scanning:**  
  Quickly add products to a list by scanning their barcodes.

- **🌟 Premium Subscription Service:**  
  Unlock extended functionality including:
  - Unlimited list sharing
  - Additional storage and member roles

---


## 👥 Tasks or Division of Members in the Project

### **Team Members and Their Contributions**

1. **Bushra Aljuwair**  
     - **Implemented the **Completed Screen**.
     - **Worked on the sublist Lists screen (that with deal items )**.     
     - **Notifications**
     - **Custom listtile widget**
     - **Localization**.
     - **Wrote the README file.**


---
2. **Lamya Alsuhaibani**  
     - **Text Field Widget**.
     - **Dual Action Button Widget**.
     - **Button widget**
     - **App bar widget**
     - **Theme**
     - **Floating Button Widget**.
     - **Expenses Screen**.
     - **Receipt Screen**
     -**Created the presentation .**
     - **Localization**.


3. **Shatha Altwaijri**  
       - **Custom OTP Field Widget**.
       - **Navigation Bar**.
        - **Payment Screen**.
       - **Profile Screen**
       - **Authentication**
       - **List members Screen**
       - **Localization**.


   
## 📌 Minimum Requirements

The following are the minimum requirements that the project must fulfill to ensure a functional and user-friendly application:

1. **Core Functionalities**:
   - Users must be able to create, edit, and delete shopping lists.
   - Lists must support real-time updates and synchronization across devices.
   - Users should have the ability to invite members to shared lists via email.
   - Role-based permissions must be implemented:
     - **Admin**: Full control over the list (edit, delete, manage members, and view receipts).
     - **Members**: Limited control (add, edit, and delete their own items only).

2. **Authentication**:
   - Secure user login and sign-up functionality.
 
3. **Expense Tracking**:
   - Admins must be able to upload receipts and track expenses related to each list.
   - Provide a summary of monthly spending.

5. **Multi-Language Support**:
   - The app must support both **Arabic** and **English** to cater to a wider audience.

6. **UI/UX Design**:
   - A polished and user-friendly interface that is intuitive for users of all ages and technical backgrounds.
   - Clear navigation and accessible features.

7. **Platform Compatibility**:
   - The app must be compatible with both **Android** and **iOS** devices.

8. **Notifications**:
   - Real-time notifications for list updates, such as when a new item is added or a member joins the list.

9. **Security and Privacy**:
   - Ensure all user data is securely stored using **Supabase**.
   - Only the admin should have access to sensitive information like receipts.

10. **Development Framework**:
    - The app must be developed using **Flutter**, ensuring a consistent experience across platforms.

 ---

## 👤 Project Members

- **Bushra Aljuwair** - *[Role/Responsibility]*
- **Shatha Altwaijri** - *[Role/Responsibility]*
- **Amr Noorwali** - *[Role/Responsibility]*
- **Lamya Alsuhaibani** - *[Role/Responsibility]*
- **[Member 5 Name]** - *[Role/Responsibility]*

---

## 🔗 Project Member Accounts in GitHub

- **shtwaijri**: [[GitHub Profile URL] ](https://github.com/shtwaijri) 
- **BushraAljuwair**: [[GitHub Profile URL]](https://github.com/BushraAljuwair)  
- **[Member 3 GitHub Username]**: [GitHub Profile URL]  
- **[Member 4 GitHub Username]**: [GitHub Profile URL]  
- **[Member 5 GitHub Username]**: [GitHub Profile URL]

---

> 💡 Remember, this is an opportunity to showcase your skills and creativity, so feel free to explore innovative ideas and push your limits in creating a remarkable Flutter application!

**Good luck with your capstone project!**  
Don't hesitate to seek guidance from your bootcamp instructors if needed.
