//
//  ViewController.m
//  FunctionalCoreImageObjC
//
//  Created by Eric Trepanier on 2014-11-27.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

#import "ViewController.h"
#import "CoreImage.h"

@interface ViewController ()

@property (weak) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CIImage *image = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"cover"]];
    CGFloat blurRadius = 5.0;
    UIColor *overlayColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
    
    Filter myFilter = composeFilters(blur(blurRadius), colorOverlay(overlayColor));
    CIImage *result = myFilter(image);
    
    self.imageView.image = [UIImage imageWithCIImage:result];
}

@end
