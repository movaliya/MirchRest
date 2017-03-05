//
//  SignUpView.h
//  MirchMasala
//
//  Created by Mango SW on 05/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpView : UIViewController
@property (weak, nonatomic) IBOutlet UIView *UsernamView;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *confrimPasswordView;
@property (weak, nonatomic) IBOutlet UIButton *SignUpBtn;

@end
