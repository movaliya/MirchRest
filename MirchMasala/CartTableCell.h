//
//  CartTableCell.h
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *MinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *PlusBtn;
@property (weak, nonatomic) IBOutlet UILabel *Quatity_LBL;

@property (strong, nonatomic) IBOutlet UIView *PlushView;
@end
