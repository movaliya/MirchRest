//
//  OrderDetailView.h
//  MirchMasala
//
//  Created by Mango SW on 09/03/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailView : UIViewController
{
    NSString *StatusMsg;
  
}
@property (strong, nonatomic) NSString *StatusMsg;
@property (weak, nonatomic) IBOutlet UITableView *OrderDetailTableView;

@end
