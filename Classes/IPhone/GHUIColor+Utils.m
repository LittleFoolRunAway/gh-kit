//
//  UIColor+Utils.m
//  GHKitIPhone
//
//  Created by Gabriel Handford on 12/18/08.
//  Copyright 2008. All rights reserved.
//

#import "GHUIColor+Utils.h"

#import <math.h>

@implementation UIColor (GHUtils)

// From http://www.easyrgb.com/index.php?X=MATH&H=20#text20
- (GH_HSV)gh_hsvFromRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
	
	float min = fminf(fminf(red, green), blue);
	float max = fmaxf(fmaxf(red, green), blue);
	float delta = max-min;

	float hue = 0.0;
	float saturation = 0.0;
	float value = max;
	
	if (delta == 0) {
		hue = 0.0;
		saturation = 0.0;
	} else {
		saturation = delta / max;
		
		float deltaR = (((max - red) / 6.0) + (max/2.0)) / delta;
		float deltaG = (((max - green) / 6.0) + (max/2.0)) / delta;
		float deltaB = (((max - blue) / 6.0) + (max/2.0)) / delta;
		
		if (red == max) hue = deltaB - deltaG;
		else if (green == max) hue = (1.0/3.0) + deltaR - deltaB;
		else if (blue == max) hue = (2.0/3.0) + deltaG - deltaR;
		
		if (hue < 0) hue += 1;
		if (hue > 1) hue -= 1;
	}	
	
	GH_HSV hsv;
	hsv.hue = hue;
	hsv.saturation = saturation;
	hsv.value = value;
	return hsv;
}

- (GH_RGBA)gh_rgba {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	GH_RGBA color;
	color.red = components[0];
	color.green = components[1];
	color.blue = components[2];
	color.alpha = components[3];
	return color;
}

- (GH_HSV)gh_hsv {
	GH_RGBA rgba = [self gh_rgba];
	return [self gh_hsvFromRed:rgba.red green:rgba.green blue:rgba.blue];
}

- (void)gh_getComponents:(CGFloat *)components {
	memcpy(components, CGColorGetComponents(self.CGColor), CGColorGetNumberOfComponents(self.CGColor) * sizeof(CGFloat));
}

- (void)gh_getRed:(CGFloat *)red green:(CGFloat *)green blue:(CGFloat *)blue alpha:(CGFloat *)alpha {
	const CGFloat *components = CGColorGetComponents(self.CGColor);
	*red = *green = *blue = *alpha = 0.0;
	size_t num = CGColorGetNumberOfComponents(self.CGColor);
	if (num >= 3) {
		*red = components[0];
		*green = components[1];
		*blue = components[2];
	}
	if (num >= 4) *alpha = components[3];
}

@end
