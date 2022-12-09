# Code build and run instructions

Flex Studio (Research Edition) was designed for iPad Pro (12.9-inch) running iPadOS 16.0 or later. In the study, the participants' device ran iPadOS 16.1.1.

For convenience, we are making the study build available via TestFlight. To run this version, [download TestFlight](https://itunes.apple.com/app/testflight/id899247664), register with your Apple ID, and send us the associated e-mail address via Discord (AlexLike#9999). You'll soon receive an invite and can test until the build expires in February.

To build and sign it yourself, [install Xcode](https://apps.apple.com/app/xcode/id497799835), register with a (free) Apple Developer Account, and open `Flex Studio.xcodeproj` by double-clicking. Next, set up signing by selecting your Delopment Team in `project.pbxproj`:
![Selecting the Development Team in Xcode.](/img/signing-instructions.png)
Attach your target device and press ⌘R to build and run Flex Studio (Research Edition).

Should you wish to collect logs from detached executions, proceed like in the last two lines of [`./runStudy`](/study/runStudy).
