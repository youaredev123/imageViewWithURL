//
//  ViewController.h
//  sampleImageFromURL
//
//  Created by Htain Lin Shwe on 14/5/14.
//  Copyright (c) 2014 2c2p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+imageViewURL.h"

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,weak) IBOutlet UIImageView *img;

@property (nonatomic,weak) IBOutlet UITableView *tableView;
@end
