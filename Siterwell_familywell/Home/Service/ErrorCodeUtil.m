//
//  ErrorCodeUtil.m
//  Siterwell_familywell
//
//  Created by TracyHenry on 2018/6/12.
//  Copyright © 2018年 iMac. All rights reserved.
//

#import "ErrorCodeUtil.h"

@implementation ErrorCodeUtil

+ (NSString *)getErrorMessageWithError:(ErrorModel *)model withDeviceTid:(NSString *)devTid{
    
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        
        if ([languageName isEqualToString:@"en"]) {
            return model.desc;
        }else{
            NSString *des = @"";
            if (model.code == 5400043 || model.code == 5400013) {
                des = [NSString stringWithFormat:@"%@ %@ %@",[self getMessageWithCode:model.code],devTid, model.userinfo];
            }else {
                des = [self getMessageWithCode:model.code];
            }
            return des;
        }
}

+ (NSString *)getMessageWithCode:(long) code{
    switch (code) {
        case 3400001:
            return NSLocalizedString(@"手机号码无效", nil);
        case 3400002:
            return NSLocalizedString(@"验证码错误", nil);
        case 3400003:
            return NSLocalizedString(@"验证码过期", nil);
        case 3400005:
            return NSLocalizedString(@"发送验证码次数过多", nil);
        case 3400006:
            return NSLocalizedString(@"无效的请求类型", nil);
        case 3400007:
            return NSLocalizedString(@"无效的旧密码", nil);
        case 3400008:
            return NSLocalizedString(@"用户已注册", nil);
        case 3400009:
            return NSLocalizedString(@"用户尚未验证", nil);
        case 3400010:
            return NSLocalizedString(@"账号或密码错误", nil);
        case 3400011:
            return NSLocalizedString(@"用户不存在", nil);
        case 3400012:
            return NSLocalizedString(@"无效的邮件token", nil);
        case 3400013:
            return NSLocalizedString(@"账户已认证", nil);
        case 3400014:
            return NSLocalizedString(@"账户已经关联了某个三方账号", nil);
        case 3400021:
            return NSLocalizedString(@"校验码不能匹配", nil);
        case 500:
        case 5200000:
            return NSLocalizedString(@"服务内部错误", nil);
        case 5400001:
            return NSLocalizedString(@"内部错误", nil);
        case 5400002:
            return NSLocalizedString(@"app重复登录", nil);
        case 5400003:
            return NSLocalizedString(@"appTid不能为空", nil);
        case 5400004:
            return NSLocalizedString(@"授权关系已存在", nil);
        case 5400005:
            return NSLocalizedString(@"授权关系不存在", nil);
        case 5400006:
            return NSLocalizedString(@"因网络原因绑定失败", nil);
        case 5400007:
            return NSLocalizedString(@"因超时原因绑定失败", nil);
        case 5400009:
            return NSLocalizedString(@"修改用户档案失败", nil);
        case 5400010:
            return NSLocalizedString(@"校验code失败", nil);
        case 5400011:
            return NSLocalizedString(@"设备授权次数达到上限", nil);
        case 5400012:
            return NSLocalizedString(@"因内部错误绑定失败", nil);
        case 5400013:
            return NSLocalizedString(@"因重复绑定绑定失败", nil);
        case 5400014:
            return NSLocalizedString(@"设备不属于用户", nil);
        case 5400015:
            return NSLocalizedString(@"没有这样的指令", nil);
        case 5400016:
            return NSLocalizedString(@"设备无法重复登录", nil);
        case 5400017:
            return NSLocalizedString(@"devTid不能为空", nil);
        case 5400018:
            return NSLocalizedString(@"创建定时预约次数达到上限", nil);
        case 5400019:
            return NSLocalizedString(@"授权的指令已过期", nil);
        case 5400020:
            return NSLocalizedString(@"不支持该指令", nil);
        case 5400021:
            return NSLocalizedString(@"不合法的邮件token", nil);
        case 5400022:
            return NSLocalizedString(@"不合法的旧密码", nil);
        case 5400023:
            return NSLocalizedString(@"不合法的校验code", nil);
        case 5400024:
            return NSLocalizedString(@"由于内部错误设备无法找到，请重连", nil);
        case 5400025:
            return NSLocalizedString(@"不存在该pid", nil);
        case 5400026:
            return NSLocalizedString(@"没有对该指令的权限", nil);
        case 5400027:
            return NSLocalizedString(@"指定模板不存在", nil);
        case 5400028:
            return NSLocalizedString(@"由于内部不正确的状态导致设备无法被找到", nil);
        case 5400035:
            return NSLocalizedString(@"指定任务不存在", nil);
        case 5400036:
            return NSLocalizedString(@"无法创建重复模板", nil);
        case 5400037:
            return NSLocalizedString(@"设备id 不匹配", nil);
        case 5400039:
            return NSLocalizedString(@"用户不存在", nil);
        case 5400040:
            return NSLocalizedString(@"校验code过期", nil);
        case 5400041:
            return NSLocalizedString(@"校验code发送失败", nil);
        case 5400042:
            return NSLocalizedString(@"校验code类型不合法", nil);
        case 5400043:
            return NSLocalizedString(@"设备无法强制绑定", nil);
        case 5500000:
            return NSLocalizedString(@"内部服务错误", nil);
        case 6400001:
            return NSLocalizedString(@"指定id的反向注册申请不存在", nil);
        case 6400002:
            return NSLocalizedString(@"不合法的反向授权请求", nil);
        case 6400003:
            return NSLocalizedString(@"只有属主可以授权设备给其他人", nil);
        case 6400004:
            return NSLocalizedString(@"指定devTid的设备不存在", nil);
        case 6400005:
            return NSLocalizedString(@"达到文件夹所能容纳设备数量的上限", nil);
        case 6400006:
            return NSLocalizedString(@"无法创建同名文件夹", nil);
        case 6400007:
            return NSLocalizedString(@"指定id的文件夹不存在", nil);
        case 6400008:
            return NSLocalizedString(@"达到创建文件夹数量上限", nil);
        case 6400009:
            return NSLocalizedString(@"无法删除根目录", nil);
        case 6400010:
            return NSLocalizedString(@"无法给根目录改名", nil);
        case 6400011:
            return NSLocalizedString(@"指定的规则不存在", nil);
        case 6400012:
            return NSLocalizedString(@"指定的定时预约任务不存在", nil);
        case 6400013:
            return NSLocalizedString(@"无法创建相同的规则", nil);
        case 6400014:
            return NSLocalizedString(@"无法创建相同的定时预约", nil);
        case 6400015:
            return NSLocalizedString(@"不合法的prodPubKey", nil);
        case 6400016:
            return NSLocalizedString(@"没有权限这样做", nil);
        case 6400017:
            return NSLocalizedString(@"请求参数错误", nil);
        case 6400018:
            return NSLocalizedString(@"指定的网盘文件不存在", nil);
        case 6400020:
            return NSLocalizedString(@"找不到这个红外码", nil);
        case 6400021:
            return NSLocalizedString(@"红外服务请求出错", nil);
        case 6400022:
            return NSLocalizedString(@"无法找到指令集", nil);
        case 6400023:
            return NSLocalizedString(@"参数不支持", nil);
        case 6400024:
            return NSLocalizedString(@"解析json失败", nil);
        case 6500001:
            return NSLocalizedString(@"删除网盘文件失败", nil);
        case 6500002:
            return NSLocalizedString(@"上传网盘文件失败", nil);
        case 6500003:
            return NSLocalizedString(@"http网络调用失败", nil);
        case 8200000:
            return NSLocalizedString(@"成功", nil);
        case 8400000:
            return NSLocalizedString(@"产品不存在", nil);
        case 8400001:
            return NSLocalizedString(@"协议模板不存在", nil);
        case 8400002:
            return NSLocalizedString(@"非法参数", nil);
        case 8400003:
            return NSLocalizedString(@"平台参数错误", nil);
        case 8400004:
            return NSLocalizedString(@"指定pid不存在", nil);
        case 9200000:
            return NSLocalizedString(@"成功", nil);
        case 9400000:
            return NSLocalizedString(@"错误", nil);
        case 9400001:
            return NSLocalizedString(@"非法参数", nil);
        case 9400002:
            return NSLocalizedString(@"action 不存在", nil);
        case 9400003:
            return NSLocalizedString(@"产品不存在", nil);
        case 9400004:
            return NSLocalizedString(@"超时", nil);
        case 9400005:
            return NSLocalizedString(@"方法不支持", nil);
        case 9500000:
            return NSLocalizedString(@"服务错误", nil);
        case 9500001:
            return NSLocalizedString(@"服务应答错误", nil);
        case 0:
            return NSLocalizedString(@"网络超时", nil);
        case 1:
            return NSLocalizedString(@"登录信息过期，请重新登录！", nil);
        case 2:
            return NSLocalizedString(@"未知错误！", nil);
        case 400016:
            return NSLocalizedString(@"操作过于频繁,请稍候再试", nil);
        case 400017:
            return NSLocalizedString(@"今日操作已达上限", nil);
            /*  case 400014:
             return "密码重置失败";*/
        default:
            // return String.valueOf(errorCode);
            return NSLocalizedString(@"服务器异常，请重新再试！", nil);
    }

}

@end
