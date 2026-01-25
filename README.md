FitTrack
FitTrack is a comprehensive fitness tracking app where you can check all the important data from your Apple's Fitness app, browse in-app exercises, create your own, add them to custom templates, track workouts in real-time, and see the history and statistics of your performance. The app's whole goal is to help you track your workout and know your progress to get better every day.

Main Technologies Used

Project Structure: Half SwiftUI, half UIKit
Architecture: MVVM + Clean Architecture
Reactive Programming: Combine
Backend: Firebase (stores 800+ exercises)
Dependency Injection: DI Container
Navigation: Coordinator Pattern
Health Integration: HealthKit for activity rings, workouts, and fitness data
Notifications: Local notifications with background support
Widgets: Live Activity for lock screen workout tracking


Features
Authentication

Login
Registration
Forgot password

Home Screen
Users can see:

Activity rings fetched from Fitness app with their goals
Recent activities and their times
Step counts
Recent workouts sorted by months
All exercises (both in-app and from Fitness)
Completed workouts automatically sync to Fitness app and Firebase

Templates Page

Create custom templates
Delete templates
Update templates
Start workouts from templates

Create Template / Exercise Selection

Add exercises into templates
Browse 800+ exercises with detailed information (videos, instructions, categories)
Filter exercises by muscle group and equipment
Create custom exercises
Set number of sets, reps, and weights for each exercise
Delete or reorder exercises as needed

Active Workout

Timer starts running when workout begins
Check off each set by tapping on checkbox
Rest timer automatically initiates after each set (customizable by user)
Rest timer sends notifications, even in background
Live Activity shows workout state on lock screen
Lock screen updates exercise-to-exercise and set-to-set
Add exercises during the workout
Minimize workout (pauses the exercise)
Dismiss or finish workout
Completed workouts sync to Firebase and Fitness app

History Page
Users can see detailed workout information:

Total volume
Duration
Sets completed
Exercise breakdown
Monthly workout view

Statistics Page
Users can see comprehensive statistics:

Weekly summary
Personal records (PRs)
Performance trends
Exercise-specific stats

Profile Page

Change name
Change profile picture
Contact/write to us
