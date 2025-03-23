# Smart-Oven-using-8051-assembly-language
## **Project Overview**
This repository contains an assembly language program for an **AT89S52/AT89C51-based smart oven** prototype, designed for **Jurgen Oven Corporation**. The system features **keypad input, 7-segment display countdown, LCD messages, LED indicators, a buzzer, and an emergency stop function**.

## **Features**
- **Countdown Timer**: Accepts input (5-300 sec) via a keypad and displays countdown on **three 7-segment displays**.
- **LED Indicators**: Shows whether the oven is working.
- **Buzzer Alert**: Notifies when the countdown reaches **zero**.
- **LCD Messages**:
  - **If input ≤ 60 sec:** Displays **custom messages**.
  - **If input > 60 sec:** Displays **changing facts** every **20 sec**.
- **Emergency Stop**: Immediately **stops the oven** upon pressing.

## **Hardware Requirements**
- **AT89S52/AT89C51 Microcontroller**
- **Three 7-Segment Displays**
- **16x2 LCD Display**
- **4x4 Keypad**
- **Buzzer**
- **LED Indicators**
- **Push Buttons (Start & Emergency Stop)**

#Must use proteus 8.17/ above version.
