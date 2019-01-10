//
//  NSString+JJ.h
//
//  Created by TracyHenry on 16/9/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JJ)

- (NSURL *)cy_URL;
+  (BOOL) isBlankString:(NSString *)string;
+(BOOL) isPhoneNumber:(NSString*) mobileNum;
-(NSArray *) arrayValue;
@end
