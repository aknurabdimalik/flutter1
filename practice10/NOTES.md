# Practice 10 — The Data Arrives Later

## Level 1: order of events
Predicted (before running):
A, C, fetchStudents #1, first frame of the app,
then after 2 seconds: B, then "6 students".

Actual (after running):
> D/FlutterJNI(17343): Sending viewport metrics to the engine.
I/flutter (17343): A
I/flutter (17343): C
I/flutter (17343): fetchStudents #1
D/FlutterJNI(17343): Sending viewport metrics to the engine.
D/InsetsController(17343): hide(ime())
I/ImeTracker(17343): com.example.practice10:10d7f9c3: onCancelled at PHASE_CLIENT_ALREADY_HIDDEN
I/flutter (17343): B
I/flutter (17343): 6 students


## Level 2: setState after dispose
First line of the error without the mounted guards:
setState() called after dispose(): __StudentsScreenState#5caa4(lifecycle state: defunct, not mounted) This error happens if you call setState() on a State object for a widget that no longer appears in the widget tree (e.g., whose parent widget no longer includes the widget in its build). This error can occur when code calls setState() from a timer, from an animation callback, or after an asynchronous operation (such as an awaited network request or other Future) completes after the widget has been removed from the tree._


## Level 4: countdown
Without _sub.cancel() (version B), Back at 7: setState() called after dispose(),
and the console kept printing tick 6, tick 5 ... tick 0 with nobody on screen (leak).
Version A (StreamBuilder), Back at 7: console stopped, StreamBuilder cancelled for me.


## Level 5: the error that vanished
The second tap popped the screen as if it worked, and the console said:
Unhandled Exception: Bad state: server rejected 6
The user saw a success.