//
//  PTAttributeStringTool.h
//  PTLatitude
//
//  Created by CHEN KAIDI on 2/12/2015.
//  Copyright © 2015 PT. All rights reserved.
//

#import <Foundation/Foundation.h>



void PTEmojiAttributedStringSyncWithFaceItems(NSAttributedString *attributedString, UIFont *contentFont, void(^emojiBlock)(BOOL success, NSMutableAttributedString *emojiAttributedString));

@interface PTAttributeStringTool : NSObject

// 解析Emoji代码图文混排
// attributedString: Your attributedString input
// contentDictionary: Read dictionary file from "emoji.plist"
// plist dictionary format: (Key)[大笑]＝>(Value)002.png
//+(NSMutableAttributedString *)convertEmojiWithAttributedString:(NSAttributedString *)attributedString contentDictionary:(NSDictionary *)contentDictionary font:(UIFont *)font;

// 高亮局部特定字符副文本
+ (NSAttributedString *)highlightText:(NSString *)targetText inFullText:(NSString*) fullText font:(UIFont *)font highlightColor:(UIColor *)highlightColor;
// 设定文本间距
+ (NSAttributedString *)setLineSpacing:(CGFloat)lineSpace withAttributedText:(NSMutableAttributedString *)attributedText font:(UIFont *)font;
// 计算富文本总高度
+ (CGFloat)getHeightForAttributedString:(NSAttributedString *)attributedString boundingRect:(CGSize)boundingRect;

/*
 PTAchievementBoardStandard的标签代码解析。以<br>分组，每一组里的所有text为一个单独Label，每一段text和font设定一一对应。标签代码示范：
 <font color=646464 size=14>昨日30分钟拼完</font><br><font color=313131 size=30>100</font><font color=313131 size=14>个</font><font color=646464 size=14>\n七巧板</font><br><font color=959595 size=12>平均速度</font><font color=646464 size=12 bold>超越了90%</font><font color=959595 size=12>的孩子</font>
 */
+(NSArray *)decompositeHTMLCode:(NSString *)code;
+(NSArray *)regexMatchString:(NSString *)string withRegularExpression:(NSString *)regularExpression matchRange:(NSRange)matchRange;
+(NSString *)encodeStringByEscapingSymbols:(NSString *)string;
+(NSString *)decodeStringBySymbolCode:(NSString *)matchString;
@end
