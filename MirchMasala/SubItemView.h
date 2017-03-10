//
//  SubItemView.h
//  MirchMasala
//
//  Created by Mango SW on 06/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubItemView : UIViewController
{
    NSString *CategoryId,*categoryName;
    NSMutableDictionary *subCategoryDic;
    
    NSInteger cellcount;
    NSInteger ButtonTag;
    NSUInteger chechPlusMinus;
    NSMutableArray *arrayInt;
}
@property (strong, nonatomic) NSString *CategoryId;
@property (strong, nonatomic) NSString *categoryName;
@property (weak, nonatomic) IBOutlet UILabel *CategoryTitleLBL;

@property (weak, nonatomic) IBOutlet UITableView *ItemTableView;
- (IBAction)BackBtn_action:(id)sender;

@end
