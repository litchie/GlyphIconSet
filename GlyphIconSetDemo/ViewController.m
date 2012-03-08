//
//  ViewController.m
//  GlyphIconSetDemo
//
//  Created by Li Chaoji on 3/8/12.
//  Copyright (c) 2012 Chaoji Li. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)glyphButton:(NSString*)name frame:(CGRect)frame
{
	UIButton *btn = [[UIButton alloc] initWithFrame:frame];
	btn.backgroundColor = [UIColor blackColor];
	UIImage *image = [_iconSet imageForGlyph:name size:frame.size color:[UIColor whiteColor]];
	[btn setImage:image forState:UIControlStateNormal];
	self.view.backgroundColor = [UIColor grayColor];
	[self.view addSubview:btn];
	[btn release];
}

#define USE_GLYPHISH 0
- (void)viewDidLoad
{
	
#if USE_GLYPHISH
	
	NSString *fontFile = @"glyphish.ttf";	
	NSString *icon1 = @"M";
	NSString *icon2 = @"N";
	NSString *icon3 = @"O";
	NSString *icon4 = @"P";
	CGAffineTransform xform = CGAffineTransformMake(1, 0, 0, 1, -5, 5);
#else
	NSString *fontFile = @"fontawesome-webfont.ttf";
	NSString *icon1 = @"uniF024";
	NSString *icon2 = @"uniF025";
	NSString *icon3 = @"uniF026";
	NSString *icon4 = @"uniF027";
	CGAffineTransform xform = CGAffineTransformMake(0.8, 0, 0, 0.8, 6, 8);

#endif
	_iconSet = [[GlyphIconSet alloc] initWithFontFile:[[[NSBundle mainBundle] bundlePath] 
							   stringByAppendingPathComponent:fontFile]];

	if (_iconSet == nil) {
		NSLog(@"No font file provided?\n");		
	}
	_iconSet.transform = xform;
	float x0 = 0;
	float y0 = 0;
	[self glyphButton:icon1 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	[self glyphButton:icon2 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	[self glyphButton:icon3 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	[self glyphButton:icon4 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	
	x0 = 0;
	y0 = 50;
	_iconSet.scale = 1;
	[self glyphButton:icon1 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	[self glyphButton:icon2 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	[self glyphButton:icon3 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	[self glyphButton:icon4 frame:CGRectMake(x0, y0, 44, 44)]; x0 += 50;
	
	
	x0 = 0;
	y0 = 100;
	_iconSet.scale = [[UIScreen mainScreen] scale];
	[self glyphButton:icon1 frame:CGRectMake(x0, y0, 60, 60)]; x0 += 70;
	[self glyphButton:icon2 frame:CGRectMake(x0, y0, 60, 60)]; x0 += 70;
	[self glyphButton:icon3 frame:CGRectMake(x0, y0, 60, 60)]; x0 += 70;
	[self glyphButton:icon4 frame:CGRectMake(x0, y0, 60, 60)]; x0 += 70;

	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

- (void)dealloc
{
	[_iconSet release];
	[super dealloc];
}

@end
