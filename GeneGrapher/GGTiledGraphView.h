//
//  GGTiledGraph.h
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//

#import <UIKit/UIKit.h>

@class GGDataSet;

@interface GGTiledGraphView : UIView {
  NSMutableArray *tiles;
}

@property (nonatomic, retain) GGDataSet *dataSet;

@end
