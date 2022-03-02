//
//  UIImageView+imageViewURL.m
//  sampleImageFromURL
//
//  Created by Htain Lin Shwe on 14/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import "UIImageView+imageViewURL.h"
#import <objc/runtime.h>

@interface imageDownloader : NSObject

@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *imageData;
@property (nonatomic,copy) void (^callback)(NSData *data);

- (void)downloadFile:(NSURLRequest *)urlRequest WithCompletion:(void(^)(NSData *data))completion;
@end

@implementation imageDownloader

- (void)downloadFile:(NSURLRequest *)urlRequest WithCompletion:(void (^)(NSData *))completion
{
    self.imageData = [[NSMutableData alloc] init];
    self.connection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    self.callback = completion;
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(self.callback)
    {
        self.callback(self.imageData);
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if(self.callback)
    {
        self.callback(nil);
    }
}

@end

@interface UIImageView ()<NSURLConnectionDataDelegate,NSURLConnectionDelegate>


@property (nonatomic,strong) imageDownloader *downloader;
@property (nonatomic,strong) NSMutableDictionary *imageCache;
@property (nonatomic,copy) void (^callback)(UIImage *image, NSError *err);

@end

@implementation UIImageView (imageViewURL)

-(imageDownloader *)downloader
{
   return objc_getAssociatedObject(self, @selector(downloader));
}

- (void)setDownloader:(imageDownloader *)downloader
{
    objc_setAssociatedObject(self, @selector(downloader), downloader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSMutableDictionary *)imageCache
{
    return objc_getAssociatedObject(self, @selector(imageCache));
}

- (void)setImageCache:(NSMutableDictionary *)imageCache
{
    objc_setAssociatedObject(self, @selector(imageCache), imageCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void (^)(UIImage *image, NSError *err))callback
{
    return objc_getAssociatedObject(self, @selector(callback));
}

- (void)setCallback:(void (^)(UIImage *, NSError *))callback
{
    objc_setAssociatedObject(self, @selector(callback), callback, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)imageFromURL:(NSURL *)url AndPlaceHolderImage:(UIImage *)placeholder
{
    [self imageFromURL:url AndPlaceHolderImage:placeholder completion:nil];
}


- (void)imageFromURL:(NSURL *)url AndPlaceHolderImage:(UIImage *)placeholder completion:(void (^)(UIImage * image,NSError * error))completion
{
  
    
    if(self.imageCache[url.absoluteString])
    {
        self.image = self.imageCache[url.absoluteString];
        [self setNeedsLayout];
        if (completion) {
            completion(self.imageCache[url.absoluteString],nil);
        }


    }
    else {
        
        
        self.image = placeholder;
        if(completion) {
            self.callback = completion;
        }
        
        
        
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
        
        self.downloader = [[imageDownloader alloc] init];
        
        __block NSURL *downloadURL = url;

        __weak UIImageView *weakImageView = self;
        
        [self.downloader downloadFile:urlRequest WithCompletion:^(NSData *data) {
           
        
            __strong UIImageView *strongImageView = weakImageView;
            
            dispatch_async(dispatch_get_main_queue(), ^{

                UIImage *img = [[UIImage alloc] initWithData:data];
                
                if(strongImageView.imageCache==nil)
                {
                    strongImageView.imageCache = [[NSMutableDictionary alloc] init];
                }
                
                strongImageView.imageCache[downloadURL.absoluteString] = img;
                
                strongImageView.image = img;
                
                [strongImageView setNeedsLayout];
                
                if(strongImageView.callback) {
                    strongImageView.callback(img,nil);
                }
            });

            
        }];
    }

}

@end
