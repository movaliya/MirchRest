//
//  LoginVW.h
//  MirchMasala
//
//  Created by Mango SW on 04/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVW : UIViewController
@property (weak, nonatomic) IBOutlet UIView *EmailView;
@property (weak, nonatomic) IBOutlet UIView *PasswordView;
@property (weak, nonatomic) IBOutlet UIButton *SignInBtn;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;

@end
