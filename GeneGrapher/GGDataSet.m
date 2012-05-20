//
//  DataSet.m
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//

#include <limits.h>
#import "GGDataSet.h"
#import "GGDataPoint.h"

@implementation GGDataSet
@synthesize minIndex = _minIndex;
@synthesize maxIndex = _maxIndex;
@synthesize minValue = _minValue;
@synthesize maxValue = _maxValue;

- (id) init
{
  if (self = [super init]) {
    dataPoints = [[NSMutableArray alloc] init];
    _minIndex = INT_MAX;
    _maxIndex = INT_MIN;
    _minValue = FLT_MAX;
    _maxValue = FLT_MIN;
  }
  return self;
}

- (void)dealloc {
  [dataPoints release];
  [self dealloc];
  [super dealloc];
}

- (void)addDataPoint:(GGDataPoint *)point {
  [dataPoints addObject:point];
  _minValue = MIN(_minValue, point.value);
  _maxValue = MAX(_maxValue, point.value);
  _minIndex = MIN(_minIndex, point.startIndex);
  _maxIndex = MAX(_maxIndex, point.endIndex);
}

- (int)count {
  return [dataPoints count];
}

- (GGDataPoint *)pointAtIndex:(int)index {
  return [dataPoints objectAtIndex:index];
}

@end
