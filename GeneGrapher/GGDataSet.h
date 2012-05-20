//
//  DataSet.h
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//
//  Represents a complete genetic diff data set.
//

#import <Foundation/Foundation.h>
#import "GGDataPoint.h"

@interface GGDataSet : NSObject {
  NSMutableArray *dataPoints;
  int _minIndex;
  int _maxIndex;
  float _minValue;
  float _maxValue;
}

@property (readonly) int minIndex;
@property (readonly) int maxIndex;
@property (readonly) float minValue;
@property (readonly) float maxValue;

- (void)addDataPoint:(id)point;
- (int)count;
- (GGDataPoint *)pointAtIndex:(int)index;

@end
