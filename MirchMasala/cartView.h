//
//  cartView.h
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface cartView : UIViewController<CCKFNavDrawerDelegate>
{
    NSInteger cellcount;
    NSInteger ButtonTag;
    NSUInteger chechPlusMinus;
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (weak, nonatomic) IBOutlet UITableView *cartTable;

@end
