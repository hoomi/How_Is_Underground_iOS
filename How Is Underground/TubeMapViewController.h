//
//  TubeMapViewController.h
//  How Is Underground
//
//  Created by Hooman Ostovari on 07/04/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "BaseViewController.h"

@interface TubeMapViewController : BaseViewController <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *tubeMapImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
