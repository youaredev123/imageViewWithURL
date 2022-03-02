This code is a sample code for imageview with URL (async). Using HTTP cache and cache image on memory.

Add **UIImageView+imageViewURL.h** and **UIImageView+imageViewURL.m** that under imageViewURL to your project.

```objc
[self.img imageFromURL:[NSURL URLWithString:@"http://www.example.com/example.png"] AndPlaceHolderImage:[UIImage imageNamed:@"placeholderimage"]];
```

With Block

```objc
[self.img imageFromURL:[NSURL URLWithString:@"http://www.example.com/example.png"] AndPlaceHolderImage:[UIImage imageNamed:@"placeholderimage"] completion:^(UIImage *image, NSError *error) {     
        NSLog(@"DONE");
}];
```

In TableViewCell


```objc
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
```

You should check [SDWebImage](https://github.com/rs/SDWebImage).