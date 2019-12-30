# Medication Book

Prescription scanner, medicine manager and reminder app for Android and iOS.

## BUILD

### Requirements

- Flutter >= 1.12.13

### Instructions

```bash
$ flutter pub get
$ ...
```

## USAGE

1. Prescription Management
2. Medical Note Management
3. Medicine Reminder
4. Medicine Bill Scanner

----------------------------------------------------------------------------
# Medication Book - User Manual

Medication Book helps you store, manage your prescriptions, medical notes and remind medicine time. You have two ways to get your prescriptions: **scan QR Code** appears on the medicine bill or **create manually**.

## Note

! Recommend use app when internet is connected.

## Features

### **1. Login with Facebook or Google account**

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1214.PNG?raw=true" width="300">

Choose account you will use for app. It helps you store your data in cloud, so you can use app with many devices.

### **2. Reminders Dashboard**

After logging in successfully, reminders information will be displayed.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1215.PNG?raw=true" width="300">

It is filtered by "Date Slider" on the top of screen.
2 types of reminder are Daytime reminder and Nighttime reminder. Each one has different notification time, by default: 8:00 for Daytime, 20:00 for the other. You can also custom notification time appropriately as below by tapping the time displayed on Reminders screen.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1230.PNG?raw=true" width="300">

If the prescription is expired, It will be display like below. 

<img src="https://github.com/vanduong185/medication_book/blob/fix/resources/demo/IMG_1229.PNG?raw=true" width="300">

### **3. Scan QR code on medicine bill to get Prescription**

Tap "+" button to open quick menu. Choose "Scan Bill" to try this feature.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1216.PNG?raw=true" width="300">

To get the sample medicine bill, you should visit [Sample Bill Website](https://api-medical.teneocto.io/) to get the bill then use Medication Book app scan that bill. Or you can scan this one we created with our website as below.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/bill.png?raw=true" width="300">

Move camera focus on QR Code area on the bill. You will get your prescription.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1217.jpeg?raw=true" width="300">

Then, you will check the details of prescription. If correct, tap "Save & remind me" button to save and go to Reminder Settings Screen. If not, you can go back and re-scan again.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1218.jpeg?raw=true" width="300">

Reminder Settings Screen analyzes your prescription automatically. Now, you only setup the reminder time and prescription name if you want manage them easily. Tap "Done" to finish.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1219.jpeg?raw=true" width="300">

### **4. Reminder Notification**

*ting-ting* - "It's time to take your medicine !!!!", somethings like this.
 
<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1221.jpeg?raw=true" width="300">

### **5. Show Prescription List**

You can manage all your prescriptions in "Presc" Tab.
The green heart icon is a signal for you. That is the prescription you are taking. And the gray heart icon is expired prescription.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1220.jpeg?raw=true" width="300">

Tap "menu" icon floated at right to show some actions: View details, Remove.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1231.jpg?raw=true" width="300">

### **6. Add Prescription manually**

On Quick Menu, choose "Presc" to add new prescription.
You need to fill up some information like this.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1224.jpeg?raw=true" width="300">

To add drugs for it, tap "+" button. "Add drug" screen will be displayed.
You can choose type of drug: pill, capsule, drop, sirup, ...
Fill the drug name, amount, dosage, choose session you need to take.
Then tap "add drug" button to finish.

<img src="https://github.com/vanduong185/medication_book/blob/fix/resources/demo/IMG_1236.PNG?raw=true" width="300">

Drug created in previous step is displayed. You can add more or remove it.
Tap "Add prescription" to finish. Prescription will be save and remind to you at default time. 

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1226.jpeg?raw=true" width="300">

### **6. Add Notes**

On "Notes" Tab, you can create medical notes, set the time to remind and manage them easily.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1227.PNG?raw=true" width="300">

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1222.jpeg?raw=true" width="300">

### **7. User Profile**

On "User" Tab, you can setup your medical profile.
You can edit profile or log out by tap "menu" icon on the top right corner.

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1223.jpeg?raw=true" width="300">

<img src="https://github.com/vanduong185/medication_book/blob/update-readme/resources/demo/IMG_1228.PNG?raw=true" width="300">

*To be continued ...*
