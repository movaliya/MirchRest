//
//  HomeView.h
//  MirchMasala
//
//  Created by Mango SW on 07/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"
@interface HomeView : UIViewController<CCKFNavDrawerDelegate>
{
    NSMutableDictionary *topCategoriesDic;
    BOOL CheckMenuBool;
    NSAttributedString *AboutMessage;
   
}
@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@property (weak, nonatomic) IBOutlet UITableView *CategoriesTableView;
@property (weak, nonatomic) IBOutlet UIView *MenuView;
@property (weak, nonatomic) IBOutlet UIButton *MenuBtn;
@property (weak, nonatomic) IBOutlet UILabel *menuLine;
@property (weak, nonatomic) IBOutlet UIButton *AboutMenuBtn;
@property (weak, nonatomic) IBOutlet UILabel *AboutLine;

@end
