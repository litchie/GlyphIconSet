/*******************************************************************************
 
 GlyphIconSet.m - Build icons from font file.
 
     DEDICATED TO PUBLIC DOMAIN.
 
 Author: Chaoji Li <chaojili@litchie.com>
 Date  : 2012
 
 ******************************************************************************/

#import "GlyphIconSet.h"

#define DONE_IF(cond, msg) \
if (!(cond)) { NSLog msg; goto Done; } else {}

static CGContextRef CreateBitmapContextForBuffer(int width, int height, void **pBits)
{
	CGContextRef context       = NULL;
	CGColorSpaceRef colorSpace = NULL;
	CGImageAlphaInfo alphaInfo = kCGImageAlphaPremultipliedLast;
	int bitsPerComponent       = 8; 
	int bytes_per_row          = width * 4;
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	DONE_IF(colorSpace == NULL, (@"CreateBitmapContextForBuffer: colorSpace"));
	
	*pBits = calloc(1, bytes_per_row * height);
	DONE_IF(*pBits == 0, (@"CreateBitmapContextForBuffer: no bits"));
	
	context = CGBitmapContextCreate (*pBits, width, height, bitsPerComponent, 
					 bytes_per_row, colorSpace, alphaInfo);
	DONE_IF(context == NULL, (@"CreateBitmapContextForBuffer: bad context"));
Done:
	if (colorSpace)	CGColorSpaceRelease(colorSpace);
	return context;
}


@implementation GlyphIconSet

@synthesize transform = _xform;
@synthesize scale     = _scale;

- (id)initWithFontFile:(NSString*)path
{
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([path UTF8String]);
	_font = CGFontCreateWithDataProvider(fontDataProvider);
	CGDataProviderRelease(fontDataProvider);

	_xform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
	_scale = [[UIScreen mainScreen] scale];

	return _font ? self : nil;
}

- (UIImage*)imageForGlyph:(NSString*)name size:(CGSize)size color:(UIColor*)color
{
	UIImage *image     = nil;
	CGContextRef ctx   = NULL;
	void *bits         = 0;
	CGGlyph glyph      = 0;
	CGImageRef cgimg   = NULL;
	CGSize scaledSize  = {size.width * _scale, size.height * _scale};
	
	ctx = CreateBitmapContextForBuffer(scaledSize.width, scaledSize.height, &bits);
	DONE_IF(ctx == 0, (@"imageForGlyph: bad bitmap context"));
	
	glyph = CGFontGetGlyphWithGlyphName(_font, (CFStringRef)name);
	DONE_IF(glyph == 0, (@"imageForGlyph: `%@' not found", name));
	
	CGContextSetFont(ctx, _font);
	CGContextSetFontSize(ctx, size.height);
	CGContextSetFillColorWithColor(ctx, [color CGColor]);
	CGContextSetStrokeColorWithColor(ctx, [color CGColor]);
	CGContextConcatCTM(ctx, _xform);
	CGContextTranslateCTM(ctx, _xform.tx * (_scale - 1), _xform.ty * (_scale - 1));
	CGContextScaleCTM(ctx, _scale, _scale);
	CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
	CGContextShowGlyphsAtPoint(ctx, 0, 0, &glyph, 1);

	cgimg = CGBitmapContextCreateImage(ctx);
	DONE_IF(glyph == 0, (@"imageForGlyph: no CGImage"));
	
	image = [[[UIImage alloc] initWithCGImage:cgimg scale:_scale 
				      orientation:UIImageOrientationUp] autorelease];
Done:
	if ( cgimg ) CGImageRelease(cgimg);
	if ( ctx   ) CGContextRelease(ctx);
	if ( bits  ) free(bits);
	return image;
}

- (void)dealloc
{
	CGFontRelease(_font);
	[super dealloc];
}
@end
