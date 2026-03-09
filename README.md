#Robotics Problem
## 1. Introduction
&nbsp;&nbsp;&nbsp;&nbsp;For this project, I was tasked with making a robot that would search a room for survivors by itself in a disaster-relief scenario. While I was working on the project, I was having a lot of fun and began testing things out outside of the normal project requirements. This repository has both my project for WGU and my personal, for-fun project.

## 2. The Original Problem
&nbsp;&nbsp;&nbsp;&nbsp;Scene 3 is the version of the project I submitted for my project at WGU. Scene 3 is a wall-following robot that traverses the environment, constantly sensing for survivors. If its "survivorDetector" catches sight of anybody, that person's location will be printed to the console and saved to a table, along with the person's object handle. The idea behind this robot is that it can operate independently, allowing the rescue team to speed up their process. Instead of searching each room for survivors, the robots would search the rooms and the rescue team would target the survivors. 

&nbsp;&nbsp;&nbsp;&nbsp;When I was developing this robot, I had it get stuck in a loop semi-frequently. I had to give it an easier way on when it came to the environment in a couple of spots, which I was not pleased to do. That's when I came up with the idea for the user to be able to control the robot.

## 3. My new idea
&nbsp;&nbsp;&nbsp;&nbsp;Scene 4 is where the user can control the robot. The bubbleRob tutorial code came with a lot of bells and whistles added in, one of those being a speed slider. I decided to change that speed slider into a steering wheel and to allow the user to tell bubbleRob what to do. This new robot's reverse function is so easy to use and can get the robot out of the tightest spots. 

## 4. Looking ahead
&nbsp;&nbsp;&nbsp;&nbsp;One thing I'd like to do is give the robot in scene 3 an override funtion so that it can be taken over and controlled if the need arose. Another feature I'd like to add would be a speed slider to the controlled robot. It would be really difficult to control with only a mouse, but it would be a blast to try out.
