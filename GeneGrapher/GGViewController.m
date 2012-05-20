//
//  GGViewController.m
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//

#import "GGViewController.h"
#import "GGDataSet.h"
#import "GGTiledGraphView.h"

@implementation GGViewController

@synthesize scrollView;

// The screen will scroll horizontally this many times.
#define kScrollFactor 7

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Load the data set.  sample.tsv has about 6,000 data points, while
  // chr1.tsv has about 110,000 data points (an entire sample data set for
  // chromosome 1).  The latter is *much* slower.
  dataSet = [[GGDataSet alloc] init];
  NSString* path = [[NSBundle mainBundle] pathForResource: @"sample" ofType: @"tsv"];
  NSString* data = [self getTextFromFile:path];
  NSLog(@"Data: %d at path %@", [data length], path);
  [self parseTSVData:data];
  NSLog(@"Got %d data points", [dataSet count]);
  NSLog(@"Range: nucleotides %d to %d, values %f to %f", dataSet.minIndex, dataSet.maxIndex, dataSet.minValue, dataSet.maxValue);

  // Set up the content view.
  GGTiledGraphView *tiledGraphView = [[GGTiledGraphView alloc] initWithFrame:CGRectMake(0, 0, scrollView.bounds.size.width * kScrollFactor, scrollView.bounds.size.height)];
  tiledGraphView.dataSet = dataSet;
  
  [scrollView addSubview:tiledGraphView];
  [scrollView setContentSize:tiledGraphView.bounds.size];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)dealloc
{
  [super dealloc];
  [dataSet release];
}

- (NSString *) getTextFromFile:(NSString *)filePath {
  return [NSString stringWithContentsOfFile:filePath usedEncoding:nil error:nil];
}

- (void) parseTSVData:(NSString *)data {
  NSArray* lines = [data componentsSeparatedByString:@"\n"];
  for (id line in lines) {
    NSArray* elements = [line componentsSeparatedByString:@"\t"];
    if ([elements count] < 5) {
      continue;
    }
    GGDataPoint* point = [[[GGDataPoint alloc] init] autorelease];
    point.startIndex = [[elements objectAtIndex:1] intValue];
    point.endIndex = [[elements objectAtIndex:2] intValue];
    point.value = [[elements objectAtIndex:4] floatValue];
    [dataSet addDataPoint:point];
  }
}

@end
