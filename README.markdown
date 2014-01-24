# BKECircularProgressView

Easily create circular progress views. Include within the project is an example usage. I'm currently using this within my iPhone app, [kickit](http://www.getkickit.com).

![Screenshot](http://f.cl.ly/items/0J1G3s1Q3P0g0D1Z0Q1n/image.png)

## Example Usage

``` objective-c
_progressView = [[BKECircularProgressView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)];
[_progressView setProgressTintColor:[UIColor colorWithRed:224.0/255.0 green:80.0/255.0 blue:15.0/255.0 alpha:1]];
[_progressView setBackgroundTintColor:[UIColor colorWithRed:223.0/255.0 green:223.0/255.0 blue:223.0/255.0 alpha:1]];
[_progressView setLineWidth:3.0f];
[_progressView setProgress:0.2f];
[self.view addSubview:_progressView];
```

## Adding To Your Project

### CocoaPods

If you are using [CocoaPods](http://cocoapods.org) than just add next line to your `Podfile`:

``` ruby
pod 'BKECircularProgressView'
```

Now run `pod install` to install the dependency.

### Manually

Simply add the files `BKECircularProgressView.h` and `BKECircularProgressView.m` to your project.