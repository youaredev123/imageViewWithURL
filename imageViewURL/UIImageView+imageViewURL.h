//
//  UIImageView+imageViewURL.h
//  sampleImageFromURL
//
//  Created by Htain Lin Shwe on 14/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (imageViewURL)

- (void)imageFromURL:(NSURL *)url AndPlaceHolderImage:(UIImage *)placeholder;
- (void)imageFromURL:(NSURL *)url AndPlaceHolderImage:(UIImage *)placeholder completion:(void (^)(UIImage * image,NSError * error))completion;

@end
