# SLParallaxController

Create a parallax effect between an UITableView and a MapView, like the view in FourSquare.

![demo](screenshots/demo.gif)

Sample usage is available in the `SLAppDelegate`.


## Requirements

`SLParallaxController` uses ARC and requires iOS 7.0+. Works for iPhone and iPad.

## Installation

### CocoaPods

`pod 'SLParallaxController'`

### Manual

Copy the files named `SLParallaxController` (_.h / .m_) which are in the folder `SLParallaxController` to your project.

### Usage

`SLParallaxController` is a subclass of `UIViewController` so you just need to instantiate a new one like this : `[SLParallaxController new]`

### Customization / SubClassing

To access to the MapView or TableView and customize them, you need to define those objects in your interface like this :

	@interface ParallaxSubClass ()

	@property (nonatomic, strong) UITableView 	*tableView;
	@property (nonatomic, strong) MKMapView 	*mapView;
	
	@end

And then you need to tell to the compiler that the getter and setter are defined by a superclass :
	
	@implementation ParallaxSubClass

	@dynamic 	tableView;
	@dynamic	mapView;
	
After that you will be able to customize them and adapt their behaviors.


##License
	Copyright (c) 2014 stefanlage

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
