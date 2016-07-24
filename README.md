# Auxiliary.app

This is a small OSX utility I wrote to monitor when PleX player is launched
or quit, and make sure AU Lab.app is also launched and quit at the same time.

It is based on the AppleScript in the forum thread called
[Stereo Dynamic Range Compression (normalize audio levels) for PHT Mac
](https://forums.plex.tv/discussion/98756/stereo-dynamic-range-compression-normalize-audio-levels-for-pht-mac)
It did not work for me out of the box, nor do I particularly enjoy the
AppleScript language, so I decided to roll my own in plain Obj-C Cocoa.

You are free to use this utility as is, and to rework it as you see fit.

# Instructions:

It is given that you already have set up Soundflower and AU Lab as described
in the above referenced forum discussion.

Edit AppDelegate.m and look for the reference to the AU Lab .trak file.
Use a path that works on your system. Also make sure the correct Bundle ID
for your PleX player is used. I use OpenPHT.

You should also maybe set self.debug to YES to see some logging when you first
try it out.

When you build an run Auxiliary, a new icon of a megaphone should appear
in the menu bar. Clicking on it does nothing, except if you press the Control
key at the same time - then Auxiliary will quit.

Auxiliary is set up like a UIElement this way so you don't get any clutter
in the dock or in the task-switcher, but to see that it is running, you look
for the megaphone icon.

