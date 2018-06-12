//
//  HekrServiceApi.h
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#ifndef HekrServiceApi_h
#define HekrServiceApi_h

#define Hekr_rid @"97844269618858723534"
#define Hekr_RESET_PASSWORD @"resetPassword"
#define Hekr_REGISTER @"register"
#define Hekr_Register_by_Phone @"%@/register?type=phone"
#define Hekr_Register_by_Email @"%@/register?type=email"
#define Hekr_Reset_by_Phone @"%@/resetPassword?type=phone"
#define Hekr_Reset_by_Email @"%@/resetPassword?type=email_verify_code"
#define Hekr_getImage @"%@/images/getImgCaptcha?rid=%@"
#define Hekr_getSmsVerifyCode @"%@/sms/getVerifyCode?phoneNumber=%@&pid=%@&type=%@&token=%@"
#define Hekr_getEmailVerifyCode @"%@/email/getVerifyCode?email=%@&pid=%@&type=%@&token=%@"
#endif /* HekrServiceApi_h */
