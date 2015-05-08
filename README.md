# Virus Spread iOS Client App #

Virus Spread provides users with live-maps, showing current infection rates and
common pathogen transfer places. iOS app is here to facilitate collection of such
information and to provide the data at hand.

## Description ##

App uses [BTLE](http://en.wikipedia.org/wiki/Bluetooth_low_energy) to discover
users with the same App around, but in the "ill" mode. "Healthy" users discover and
send data to the server (including the location of the contact and the unique id),
while those "ill" advertise through BTLE. iOS does a fairly good job in power
use optimization, so using BTLE doesn't drain battery a single bit.

## Installation ##

App will be available on the AppStore soon and is currently in private beta. The
version compiled from the sources is compatible with iPhones 4S through 6 Plus
having iOS version 8.1 and higher.

## Using sources ##

Obviously, you will need Xcode to compile the app yourself. Version used was 6.3.
Since there is some Swift code, using the same version is fairly important (Apple
guys don't really care about backward-compatibility). Also, the project uses
[CocoaPods](http://cocoapods.org). All the sources are integrated into the repository,
so obtaining CocoaPods installation on your system is only required if you wish to
update some of the pods.

## Current work ##

Current version is being refactored and redesigned for the 1.2 release. 

For the version 2.0 complete code reengineering is planned.

## Notes for contributors ##

There are some hacks in the CocoaPods usage and in some of the pods sources.
Those will be documented and contributed to the original developers ASAP. For now,
please refrain from updating Pods unless you know the consequences beforehand.


## Note on Beta Access ##

To request access to the current beta of the client app, send request to
i.mikhaltsov@blankpagelabs.com
