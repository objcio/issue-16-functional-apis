//
//  CoreImage.h
//  FunctionalCoreImageObjC
//
//  Created by Eric Trepanier on 2014-11-27.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CIFilter (FunctionalCoreImageObjC)

+ (instancetype)filterWithName:(NSString *)name parameters:(NSDictionary *)parameters;

@property (readonly) CIImage *outputImage;

@end

typedef CIImage *(^Filter)(CIImage *);

Filter blur(CGFloat radius);

Filter colorGenerator(UIColor *color);

Filter compositeSourceOver(CIImage *overlay);

Filter colorOverlay(UIColor *color);

Filter compose(Filter filter1, Filter filter2);
