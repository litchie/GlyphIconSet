/*******************************************************************************

 GlyphIconSet.h - Build icons from font file.
 
     DEDICATED TO PUBLIC DOMAIN.
 
 Author: Chaoji Li <chaojili@litchie.com>
 Date  : 2012

 Putting icon design in a font file has several great advantages over PNG
 images:
   a. Smaller foot print. 10% size of conventional method.
   b. One file to rule any device, any resolution.
   c. Customizable. Transform, colors.

 Some icon designers (Glyphish/FontAwesome) already ship their icons in a single
 font file. This implementation is just a small step ahead to make your life
 easier. It loads a font file, and builds an image object for a glyph upon 
 request. For retina display, it automatically returns a retina version.

 Sample
 =========================================================================
 1   NSString *file = @"???.ttf";
 2   GlyphIconSet *iconSet = [[GlyphIconSet alloc] initWithFontFile:file];
 3   iconSet.transform = CGAffineTransformMake(
 4       0.8,  // scale X
 5       0, 0,
 6       0.8,  // scale Y
 7       6,    // shift X
 8       8);   // shift Y
 9  
 10  UIImage *image = [iconSet imageForGlyph:@"A" size:CGSizeMake(40,40)
 11                                    color:[UIColor blackColor]];
 -------------------------------------------------------------------------

 Line 1: Specify the icon font file. Replace ??? with a valid path.

 Line 3: The icon is rendered with the origin at the left bottom of
         the image. so it is usually not centered, and the size may not
         look right for you. You can apply a transform with customized
         scale factor and position shift to correct the result.
         Different image sizes require different transform.
         The process is: try, bad, try, better.

 Line 10: You may ask, where does the glyph name come from?
         Well, either the icon designer is kind enough to provide a list,
         or you will need a font tool like Font Forge to help you examine
         glyphs.

 ******************************************************************************/

#import <Foundation/Foundation.h>

@interface GlyphIconSet : NSObject
{
	CGFontRef         _font;
	CGAffineTransform _xform;
	float             _scale;
}

@property (nonatomic, assign  ) CGAffineTransform transform;
@property (nonatomic, assign  ) float scale;

- (id)initWithFontFile:(NSString*)path;
- (UIImage*)imageForGlyph:(NSString*)name size:(CGSize)size color:(UIColor*)color;

@end
