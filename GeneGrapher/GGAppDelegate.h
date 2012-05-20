//
//  GGAppDelegate.h
//  GeneGrapher
//
//  Created by Joe Hughes on 2012-05-20 for a Cancer Research UK hack day.
//  Released under MIT License.
//

#import <UIKit/UIKit.h>

@class GGViewController;

@interface GGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GGViewController *viewController;

@end
