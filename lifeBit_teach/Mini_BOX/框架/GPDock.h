//
//  GPDock.h
//  sideDemo
//
//  Created by 程党威 on 2017/8/22.
//  Copyright © 2017年 程党威. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GPTabItem.h"

@class GPDock;

@protocol GPDockItemDelegate <NSObject>

-(void)switchMainByTabItem:(GPDock*)gpdock originalTab:(int)start destinationTab:(int)end;

@end

@interface GPDock : UIView

{
    GPTabItem *selectedTabItem;
}
@property (nonatomic,weak) id<GPDockItemDelegate> dockDelegate;

-(void)jumpToViewByTag:(NSInteger)tag;

@end
