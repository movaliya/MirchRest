//
//  CheckOut_PaymentVW.h
//  MirchMasala
//
//  Created by Mango SW on 15/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MirchMasala.pch"
@interface CheckOut_PaymentVW : UIViewController
{
}
@property (strong, nonatomic) NSString *Discount;
@property (strong, nonatomic) NSString *OrderAmount;

@property (weak, nonatomic) IBOutlet UILabel *Discount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *OrderAmount_LBL;
@property (weak, nonatomic) IBOutlet UIButton *Collection_Radio_Btn;
@property (weak, nonatomic) IBOutlet UIButton *Delivery_Radio_Btn;
@property (weak, nonatomic) IBOutlet UIButton *CreditCard_Radio_Brn;
@property (weak, nonatomic) IBOutlet UIButton *PayOnCollection_Radio;
@property (weak, nonatomic) IBOutlet UILabel *CartNotification_LBL;
@property (weak, nonatomic) IBOutlet UIButton *ProcessOrder_Btn;
@property (strong, nonatomic) IBOutlet UIButton *Collection_CartBTN;
@end
