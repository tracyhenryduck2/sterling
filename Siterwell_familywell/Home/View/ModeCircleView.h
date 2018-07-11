//
//  ModeCircleView.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/7/11.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef ModeCircleView_h
#define ModeCircleView_h
#import "AutoScrollLabel.h"
#import "SystemSceneModel.h"

@interface ModeCircleView : UIView

-(void)setLabel:(SystemSceneModel *)sceneModel;
-(void)setText:(NSString *)text;
@end

#endif /* ModeCircleView_h */
