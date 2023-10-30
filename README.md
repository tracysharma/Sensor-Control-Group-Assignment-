# Sensor-Control-Group-Assignment-
***
Assignment: Project Code
Group Name: Group 3
Project Name: Project 10 - 3D Control and path planning for the surgical robotics catheter in the aorta based on ultrasound
Group Members: Graceann Tathyaril (13227463), Tracy Sharma (13888223), Faezeh Albouhamdan (13711712), Aleisha Tran (14244103)
Subject: 41014 Sensors and Control for Mechatronic Systems - Spring 2023
Submission Date: 31 Oct 2023
***

*** BEFORE RUNNING ANY FILES, PLEASE ENSURE PHANTOM DATASETS FOLDERS ARE IN THE FOLDER PATH i.e. folder: Data2_Soft_pullback_1, folder: Data1_Soft_Insertion_2 ***

This project has several matlab files and a GUI. Please see below:
1. PullbackUltrasound.m - This file uses ultrasound images from pullback method in phantom datasets to find centrepoints. Run this file first.
2. Pullback.m - This file uses the pullback EM and contour data to find the centrepoints and shows the error of the cathedar or correction to reach the centreline for path planning.
   Run this file second.
4. Insersion.m - This file does the same as Pullback.m but for the insertion dataset. Run this file third.
