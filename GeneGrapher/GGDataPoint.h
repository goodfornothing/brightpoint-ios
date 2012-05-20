//
//  GGDataPoint.h
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//
//  Represents a single point in the genetic diff data set.
//

#import <Foundation/Foundation.h>

@interface GGDataPoint : NSObject {
  NSInteger startIndex;
  NSInteger endIndex;
  float value;
}

@property (readwrite) int startIndex;
@property (readwrite) int endIndex;
@property (readwrite) float value;

@end
