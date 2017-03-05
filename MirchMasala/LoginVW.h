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
- (IBAction)SignUp_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *Email_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Password_TXT;
@end
