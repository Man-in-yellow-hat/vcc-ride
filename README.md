# Table of Contents
1. [Description](#description)
2. [Getting started](#getting-started)
3. [Usage](#usage)
4. [Architecture](#architecture)
5. [Structure](#structure)
6. [Running the tests](#running-the-tests)
7. [Deployment](#deployment)
8. [Dependencies](#dependencies)
9. [Task board](#task-board)

# VCC Ride
An iOS app that helps members of the Vanderbilt Climbing Club organize rides to and from biweekly practices.

# Description
<p>The VCC Ride app is designed for Riders, Drivers, and Admins to get to practice each day.<br>
It is currently designed only for iOS, but hopefully can be expanded to support Android as well some day.<br> 
The project consists of three user roles: rider, driver, and admin. Each role has its own dashboard/set of features. Drivers fill the spots in their car, riders can see what cars are available, and admins can oversee all the realtime data as well as assign drivers, edit users, add/remove, practices, etc.</p>

The developers for this project are:
* Nathan King: [nathan.s.king@vanderbilt.edu](mailto:nathan.s.king@vanderbilt.edu)
* Karen Pu: [karen.c.pu@vanderbilt.edu](mailto:karen.c.pu@vanderbilt.edu)
* Aman Momin: [aman.momin@vanderbilt.edu](mailto:aman.momin@vanderbilt.edu)
* Junwon Lee: [junwon.lee@vanderbilt.edu](mailto:junwon.lee@vanderbilt.edu)

# Getting started
<p>
1. Make sure you have the Xcode version 14.0 or above installed on your computer.<br>
2. Download the VCC Ride project files from the repository.<br>
3. We do not use CocoaPods; be sure to download all dependencies (Firebase, GoogleSignIn). <br>
4. Open the project files in Xcode.<br>
5. Review the code.<br>
6. Run the VccRide scheme on a supported iOS device or simulator.<br>
You should see the login screen of the app.<br>

If you have any issues or need help, refer to the documentation or contact the developers for assistance.<br>

# Usage
In order to log in, you must create an account and go through the sign-in process. Although you can create your own account with Google or Apple, we have a setup Admin test account for development. Sign in with google using the following credentials:
* Username: vccride.test@gmail.com
* Password: dikjoks-4myRave-bofaQ%

Important: DEV and PROD enviroment are <strong>NOT WORKING</strong> on Friday from 00:00 - 01:00 GMT due to the server maintenance.

# Architecture
* Our project is generally implemented using the <strong>Model-View-Controller (MVC)</strong> architecture pattern. Note that due to the use of Firebase's Realtime Database, some of the components overlap.
* Model generally has all data and some necessary logic.
* View is responsible for displaying everything to the user, such as a list of practice dates.
* Controller handles any user input or interactions and update the Model and View as needed.
* The database used is Firebase's Realtime Database, found [here](https://console.firebase.google.com/u/0/project/vcc-ride-e61ed/overview). To access this database, please contact [Karen](mailto:karen.c.pu@vanderbilt.edu), [Nathan](mailto:nathan.s.king@vanderbilt.edu), [Aman](mailto:aman.momin@vanderbilt.edu), or [Junwon](mailto:junwon.lee@vanderbilt.edu).<br>

# Structure 
* <strong>NavBar:</strong> Files or resources that are shared across multiple parts of the project. Such as utility classes, global constants, or reusable UI elements.
* <strong>Rider:</strong> Files pertaining specifically to the "rider" role.
* <strong>Driver:</strong> Files pertaining specifically to the "driver" role.
* <strong>Admin:</strong> Files pertaining specifically to the "admin" role.
* <strong>Utilities:</strong> Files pertaining more generally to the app, models, or forms.
* <strong>Startup:</strong> Login/startup screen files.
* <strong>App:</strong> Fundamental application files such as app delegates, MainView, etc.<br><br>
Note: All of the above are within VccRide. The test suite is found in <strong>VccRideTests</strong>.

# Running the tests
To start unit testing the project, you will need to clone the repo and run the simulator. 

1. Log into vccride.test@gmail.com, as seen in the instructions above.
2. Make sure vccride.test@gmail.com is in ADMIN mode AND that there is practice today. If not, please contact [Karen](mailto:karen.c.pu@vanderbilt.edu)
3. Navigate to the test plan icon.
4. Run all two test bundles. Coverage should be around 60%.

Note: If you run the test more than once, testDriverPage() will fail due to changes in the backend. You 
will also have to login again for retesting.


# Deployment
Deploying an iOS app to the App Store requires having an Apple Developer account. Ours is held by [Nathan King](mailto:nathan.s.king@vanderbilt.edu), so reach out to him to get a provisioning profile, development key, and any other necessary requirements for development.

1. Click on the "Product" menu in Xcode and select "Archive." This will create an archive of your project.
2. Once validation is complete, click on the "Distribute" button and select "App Store and TestFlight" distribution. 
This will create a signed IPA file that can be installed on iOS devices.
3. Follow the prompts in the distribution wizard to complete the distribution process.
4. Once the distribution is complete, continue to the app store review process.

# Dependencies
We do not use a dependency manager, although CocoaPods is commonly used for iOS development.<br>
List of dependencies: 
* Firebase -> Firebase provides connection to realtime database, cloud messaging, etc.
* GoogleSignIn -> Our library that serves for authorization.<br>

<!-- # Workflow

* Reporting bugs:<br> 
If any issues are found, please report them by creating a new issue on the GitHub repository.

* Reporting bugs form: <br> 
```
App version: 1.2
iOS version: 17.1
Description: When I attempt to delete a practice, the app crashes.
Steps to reproduce: As an admin, open "Calendar", swipe to delete a date, press "delete".
```

* Submitting pull requests: <br> 
If you have a bug fix or a new feature you'd like to add, please submit a pull request. Before submitting a pull request, 
please make sure that your changes are well-tested and that your code adheres to the Swift style guide.

* Improving documentation: <br> 
If you notice any errors or areas of improvement in the documentation, feel free to submit a pull request with your changes.

* Providing feedback:<br> 
If you have any feedback or suggestions for the project, please let us know by creating a new issue or by sending an email to the project maintainer. -->

# Task board
* Task management tool for our teams is [Trello](https://trello.com/)<br>
* Link to the board is [here](https://trello.com/b/SakWen4h/vcc-transportation-app)<br>
