# SVNBasicMapViewController
A map with a large material button on it. Is a subclass of SVNModalViewController and is intended to be presented modally
Basic functionality includes finding a users location and allowing the user to confirm that location

To create an instance of this class call init(theme: model:) or init(nibName: bundleName: theme: model:)
Pass in a custom SVNTheme and SVNBasicMapViewModel instance or nil for default styling

If you haven't added location access to your info.plist:

    Key       :  NSLocationWhenInUseUsageDescription
    Value     :  $(PRODUCT_NAME) location use Description

  or

    Key       :  NSLocationAlwaysUsageDescription
    Value     :  $(PRODUCT_NAME) location use Description

## To install this framework

Add Carthage files to your .gitignore

    #Carthage
    Carthage/Build

Check your Carthage Version to make sure Carthage is installed locally:

    Carthage version

Create a CartFile to manage your dependencies:

    Touch CartFile

Open the Cartfile and add this as a dependency. (in OGDL):

    github "sevenapps/PathToRepo*" "master"

Update your project to include the framework:

    Carthage update --platform iOS

Add the framework to 'Linked Frameworks and Libraries' in the Xcode Project by dragging and dropping the framework created in

    Carthage/Build/iOS/pathToFramework*.framework

Add this run Script to your xcodeproj

    /usr/local/bin/carthage copy-frameworks

Add this input file to the run script:

    $(SRCROOT)/Carthage/Build/iOS/pathToFramework*.framework

If Xcode has issues finding your framework Add

    $(SRCROOT)/Carthage/Build/iOS

To 'Framework Search Paths' in Build Settings
