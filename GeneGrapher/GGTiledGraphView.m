//
//  GGTiledGraph.m
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//

#import "GGTiledGraphView.h"
#import "GGDataSet.h"
#import <QuartzCore/CoreAnimation.h>

@interface DSGraphTile : NSObject {
  int startX;
  UIImage *image;
}
@property (readwrite) int startX;
@property (readwrite, retain) UIImage *image;
@end

@implementation DSGraphTile
@synthesize startX;
@synthesize image;
@end

// This represents the Nth attempt to get a smoothly-scrolling graph of the
// gene diff data that we were working with in this hackathon.  It sort of
// works, but with big data sets the tiles still render slowly.  In a real app,
// I recommend rendering the tiles ahead of time on the server at a few
// usable zoom levels.

// This is quick-and-dirty hackathon code, it's not my best work!


@implementation GGTiledGraphView
@synthesize dataSet;

#define kMinDotSize 6
#define kTileWidth 100
#define kTileCacheSize 40

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      tiles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
  [super dealloc];
  [tiles release];
}

+ (Class)layerClass
{
  return [CATiledLayer class];
}


void GGRenderTile(CGContextRef context, GGDataSet* dataSet, CGRect bounds, float startX, float width) {
  CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.70].CGColor);
  float xscale = width / (dataSet.maxIndex - dataSet.minIndex);
  float yscale = bounds.size.height / (dataSet.maxValue - dataSet.minValue);
  
  for (int i = 0; i < [dataSet count]; i++) {
    GGDataPoint *point = [dataSet pointAtIndex:i];
    float startx = (point.startIndex - dataSet.minIndex) * xscale + bounds.origin.x;
    float endx = (point.endIndex - dataSet.minIndex) * xscale + bounds.origin.x;
    float y = (point.value - dataSet.minValue) * yscale + bounds.origin.y;
    CGContextFillEllipseInRect(context, CGRectMake(startx, y, MAX(kMinDotSize, endx - startx), kMinDotSize));
  }
}

- (UIImage *)generateNewTile:(int)startX {
	UIGraphicsBeginImageContext(CGSizeMake(kTileWidth, self.bounds.size.height));		
	CGContextRef context = UIGraphicsGetCurrentContext();		
	UIGraphicsPushContext(context);								
  
  CGContextTranslateCTM(context, -startX, 0);
  GGRenderTile(context, dataSet, self.bounds, 0, self.bounds.size.width);
  
	UIGraphicsPopContext();								
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
  return outputImage;
}

// Using my own MRU tile cache on top of the CATiledLayer cache, because I
// wasn't happy with the order/scope of the CATiledLayer tile generation.  Not a
// great way to do this in the long term.
-(UIImage *)tileForLocation:(int)x {
  DSGraphTile *resultTile = nil;
  for (id obj in tiles) {
    DSGraphTile *tile = (DSGraphTile *) obj;
    if (tile.startX == x) {
      resultTile = [[tile retain] autorelease];
      break;
    }
  }
  if (resultTile != nil) {
    [tiles removeObject:resultTile];
  } else {
    resultTile = [[DSGraphTile alloc] init];
    resultTile.startX = x;
    resultTile.image = [self generateNewTile:x];
  }
  [tiles addObject:resultTile];
  while ([tiles count] > kTileCacheSize) {
    [tiles removeObjectAtIndex:0];
  }
  return resultTile.image;
}


- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  int firstColIndex = floorf(CGRectGetMinX(rect) / kTileWidth);
  int lastColIndex = floorf((CGRectGetMaxX(rect) - 1) / kTileWidth);
  
  for (int col = firstColIndex; col <= lastColIndex; col++) {
    UIImage *tile = [self tileForLocation:col * kTileWidth];
    [[UIColor whiteColor] set];
    
    CGRect tileRect = CGRectMake(kTileWidth * col, 0, kTileWidth, self.bounds.size.height);
    tileRect = CGRectIntersection(self.bounds, tileRect);
    
    CGContextFillRect(context, tileRect);
    [tile drawInRect:tileRect];
  }
}

@end
