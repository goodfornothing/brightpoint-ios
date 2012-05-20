//
//  GGViewController.h
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//

#import <UIKit/UIKit.h>

@class GGDataSet;

@interface GGViewController : UIViewController {
  GGDataSet *dataSet;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@end
