//
//  WallTableViewCell.h
//  Tva
//
//  Created by Admin on 12/31/15.
//  Copyright © 2015 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property NSString* imageName;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
