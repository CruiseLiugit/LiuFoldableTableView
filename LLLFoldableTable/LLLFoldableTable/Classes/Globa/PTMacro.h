//
//  PTMacro.h
//  PTLatitude
//
//  Created by so on 15/11/27.
//  Copyright © 2015年 PT. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Screenwidth [UIScreen mainScreen].bounds.size.width
#define Screenheight [UIScreen mainScreen].bounds.size.height

#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define IsIOS9 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=9)
#define PADDING 8

#define HEIGHT_STATUS                   20
#define HEIGHT_NAV                      44
#define HEIGHT_BAR                      49

//主题色
#define THEME_COLOR                     [UIColor colorWithHexString:@"985ec9"]
//默认页面背景颜色
#define VIEW_BACKGROUND_COLOR           [UIColor colorWithHexString:@"EBEBEB"]
//输入框分隔线颜色
#define TEXT_INPUT_LINE_COLOR           [UIColor colorWithHexString:@"E1E1E1"]


