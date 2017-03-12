//
//  ProfileView.h
//  MirchMasala
//
//  Created by Mango SW on 11/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"

@interface ProfileView : UIViewController<CCKFNavDrawerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITextField *User_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Email_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Street_TXT;
@property (weak, nonatomic) IBOutlet UITextField *PostCode_TXT
;
@property (weak, nonatomic) IBOutlet UITextField *Mobile_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Country_TXT;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (weak, nonatomic) IBOutlet UIView *user_View;
@property (weak, nonatomic) IBOutlet UIView *Email_View;
@property (weak, nonatomic) IBOutlet UIView *Street_View;
@property (weak, nonatomic) IBOutlet UIView *PostCode_View;
@property (weak, nonatomic) IBOutlet UIView *Mobile_View;
@property (weak, nonatomic) IBOutlet UIView *Country_View;
@property (weak, nonatomic) IBOutlet UIButton *update_Btn;

@end