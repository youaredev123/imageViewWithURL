//
//  ViewController.m
//  sampleImageFromURL
//
//  Created by Htain Lin Shwe on 14/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) NSArray *imageList;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageList = @[@"http://cl.ly/VXIU/1.png",
                       @"http://cl.ly/VXFg/2.png",
                       @"http://cl.ly/VWUo/3.png",
                       @"http://cl.ly/VWI9/4.png",
                       @"http://cl.ly/VWp7/5.png",
                       @"http://cl.ly/VWep/6.png",
                       @"http://cl.ly/VWzB/7.png",
                       @"http://cl.ly/VWDK/8.png",
                       @"http://cl.ly/VWTc/9.png",
                       @"http://cl.ly/VXJR/10.png",
                       @"http://cl.ly/VXIU/1.png",
                       @"http://cl.ly/VXFg/2.png",
                       @"http://cl.ly/VWUo/3.png",
                       @"http://cl.ly/VWI9/4.png",
                       @"http://cl.ly/VWp7/5.png",
                       @"http://cl.ly/VWep/6.png",
                       @"http://cl.ly/VWzB/7.png",
                       @"http://cl.ly/VWDK/8.png",
                       @"http://cl.ly/VWTc/9.png",
                       @"http://cl.ly/VXJR/10.png"
                       ];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.img imageFromURL:[NSURL URLWithString:@"http://fc01.deviantart.net/fs71/f/2013/004/5/c/chibi_luffy_lineart_colored_by_bryanaldrin-d5qe6vt.png"] AndPlaceHolderImage:[UIImage imageNamed:@"luffy"] completion:^(UIImage *image, NSError *error) {
        
        
        NSLog(@"DONE");
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];

    NSString *url = self.imageList[indexPath.row];
    
    cell.textLabel.text = url;

    __weak UITableViewCell *weakcell = cell;
    cell.imageView.image = nil;
    
    [cell.imageView imageFromURL:[NSURL URLWithString:url] AndPlaceHolderImage:[UIImage imageNamed:@"luffy"] completion:^(UIImage *image, NSError *error) {
        
        __strong UITableViewCell *strongCell = weakcell;
        dispatch_async(dispatch_get_main_queue(), ^{
            strongCell.imageView.image = image;
            [strongCell setNeedsLayout];
        });
        
    }];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

@end
