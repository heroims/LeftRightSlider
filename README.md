LeftRightSlider
===============

![Screenshot1](http://i.imgur.com/N6q2Uk8.gif "Screenshot1") 
![Screenshot2](http://i.imgur.com/98Gwauw.gif "Screenshot2")


网易 ios7 左右拉动框架

把LRNavigationController文件夹和LeftRightSlider文件夹拖入项目即可，支持arc和非arc

LeftRightSlider文件夹为左右滑动框架

LRNavigationController文件夹为视差推出框架

## Minimum Requirement
iOS 5.0

## Installation

### via CocoaPods
Install CocoaPods if you do not have it:-
````
$ [sudo] gem install cocoapods
$ pod setup
````
Create Podfile:-
````
$ edit Podfile
platform :ios, '5.0'
pod 'LRNavigationController',  '~> 1.0.0'
pod 'SliderViewController',  '~> 1.2.0'
$ pod install
````
Use the Xcode workspace instead of the project from now on.

If you want to use 'storyboard'.You must create MainViewController,LeftViewController and RightViewController
![Screenshot3](http://i.imgur.com/iLCbF0F.png "Screenshot3")
