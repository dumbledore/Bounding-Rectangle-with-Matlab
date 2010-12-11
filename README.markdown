Finding the Bounding Rectangle with Minimum Area for a Set of Points
--------------------------------------------------------------------

There are a few possible ways of using the script

Using a set of 2D points
========================

Lets use the following list of 2D points:
    x = [1 2; 5 7; -2 0; 4 9];

All that's need is:
    brect(x)

The app will find the bounding rectangle for the specified poitns

Entering the points interactively
=================================

Just enter `brect` and the app would ask for the point count (it needs at least 3 points to build a rectangle).

After that the user can select the points in three ways:

- directly from the keyboard
- using the mouse
- using randomly generated points

Note: if one enters only three points and they lay on a common line, the app would throw an error.

At each step the script would show the found rectangle and its face. To proceed to the next step one needs to press a key.

At the end, the script shows the bounding rectangle with the smallest area and returns its coordinates and physical area.
