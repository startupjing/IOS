//
//  ListController.h
//  ChineseMinusMinus
//
//  Created by Peiyun Zeng on 4/18/15.
//  Copyright (c) 2015 Azure Hu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "HomePageController.h"
@interface ListController : UIViewController <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet iCarousel *carousel;


@end
