//
//  NSString+extension.m
//  项目整理
//
//  Created by shengtian on 2017/6/23.
//  Copyright © 2017年 shengtian. All rights reserved.
//

#import "NSString+extension.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation NSString (extension)
+(NSString*)stringWithCurrentTime;{
    NSTimeInterval a=[[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    return timeString;
}

-(NSString*)timeToStringWithType:(timeType)type{
        
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:d];
    return locationString;
}

-(id)jsonStringToObject;{
    if (self == nil) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                             options:NSJSONReadingMutableContainers
                                               error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return object;
}

-(CGFloat)get:(widthORheight)type withFount:(CGFloat)fontFloat andFixed:(CGFloat)length;{
    UIFont * font = [UIFont systemFontOfSize:fontFloat];
    CGSize size ;
    switch (type) {
        case width:
        {
            size = CGSizeMake(MAXFLOAT, length);
        }
            break;
        case height:
        {
            size = CGSizeMake(length, MAXFLOAT);
        }
            break;
        default:
            break;
    }
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGSize actualSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    if (type ==  width) return actualSize.width;
    return actualSize.height;
}

-(BOOL)isPhoneNumber;{
    if (self.length==0) {
        return NO;
    }
    NSString *phoneRegex = @"^((13[0-9])|(15[0-9])|(18[0-9])|(14[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

-(BOOL)isPassWorld;{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:self];
}

-(BOOL)isEmail;{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+(instancetype)getIPString;{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
@end
