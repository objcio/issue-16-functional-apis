//
//  CoreImage.m
//  FunctionalCoreImageObjC
//
//  Created by Eric Trepanier on 2014-11-27.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

#import "CoreImage.h"

@implementation CIFilter (FunctionalCoreImageObjC)

+ (instancetype)filterWithName:(NSString *)name parameters:(NSDictionary *)parameters {
    CIFilter *filter = [self filterWithName:name];
    [filter setDefaults];
    for (NSString *key in parameters) {
        [filter setValue:parameters[key] forKey:key];
    }
    return filter;
}

- (CIImage *)outputImage {
    return [self valueForKey:kCIOutputImageKey];
}

@end

Filter blur(CGFloat radius) {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{kCIInputRadiusKey: @(radius), kCIInputImageKey: image};
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" parameters:parameters];
        return filter.outputImage;
    };
}

Filter colorGenerator(UIColor *color) {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{kCIInputColorKey: [CIColor colorWithCGColor:color.CGColor]};
        CIFilter *filter = [CIFilter filterWithName:@"CIConstantColorGenerator" parameters:parameters];
        return filter.outputImage;
    };
}

Filter compositeSourceOver(CIImage *overlay) {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{kCIInputBackgroundImageKey: image, kCIInputImageKey: overlay};
        CIFilter *filter = [CIFilter filterWithName:@"CISourceOverCompositing" parameters:parameters];
        return [filter.outputImage imageByCroppingToRect:image.extent];
    };
}

Filter colorOverlay(UIColor *color) {
    return ^(CIImage *image) {
        CIImage *overlay = colorGenerator(color)(image);
        return compositeSourceOver(overlay)(image);
    };
}

Filter compose(Filter filter1, Filter filter2) {
    return ^(CIImage *image) {
        return filter2(filter1(image));
    };
}
