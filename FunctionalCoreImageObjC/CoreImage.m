//
//  CoreImage.m
//  FunctionalCoreImageObjC
//
//  Created by Eric Trepanier on 2014-11-27.
//  Copyright (c) 2014 objc.io. All rights reserved.
//

#import "CoreImage.h"



Filter blur(CGFloat radius) {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{kCIInputRadiusKey: @(radius), kCIInputImageKey: image};
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" withInputParameters:parameters];
        return filter.outputImage;
    };
}

Filter colorGenerator(UIColor *color) {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{kCIInputColorKey: [CIColor colorWithCGColor:color.CGColor]};
        CIFilter *filter = [CIFilter filterWithName:@"CIConstantColorGenerator" withInputParameters:parameters];
        return filter.outputImage;
    };
}

Filter compositeSourceOver(CIImage *overlay) {
    return ^(CIImage *image) {
        NSDictionary *parameters = @{
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        };
        CIFilter *filter = [CIFilter filterWithName:@"CISourceOverCompositing" withInputParameters:parameters];
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
    return ^(CIImage *img) { return filter2(filter1(img)); };
}
