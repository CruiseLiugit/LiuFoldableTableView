//
//  PTAttributeStringTool.m
//  PTLatitude
//
//  Created by CHEN KAIDI on 2/12/2015.
//  Copyright © 2015 PT. All rights reserved.
//

#import "PTAttributeStringTool.h"
//#import "PTDataSourceManager.h"

static NSString *PTNextLine = @"PTNextLine";
static NSString *PTModulus = @"PTModulus";
static NSString *PTExclam = @"PTExclam";
static NSString *PTBreak = @"PTBreak";
static NSString *PTStop = @"PTStop";
static NSString *PTSlash = @"PTSlash";
static NSString *PTBackSlash = @"PTBackSlash";
static NSString *PTMusicLeft = @"PTMusicLeft";
static NSString *PTMusicRight = @"PTMusicRight";
static NSString *PTBracketLeft = @"PTBracketLeft";
static NSString *PTBracketRight = @"PTBracketRight";
static NSString *PTColon = @"PTColon";
static NSString *PTSemiColon = @"PTSemiColon";
static NSString *PTQuestion = @"PTQuestion";
static NSString *PTPlus = @"PTPlus";
static NSString *PTDash = @"PTDash";
static NSString *PTUnderscore = @"PTUnderscore";
static NSString *PTEqual = @"PTEqual";
static NSString *PTStar = @"PTStar";
static NSString *PTAmp = @"PTAmp";
static NSString *PTPower = @"PTPower";
static NSString *PTDollar = @"PTDollar";
static NSString *PTHash = @"PTHash";
static NSString *PTAt = @"PTAt";
static NSString *PTTween = @"PTTween";
static NSString *PTQuoteLeft = @"PTQuoteLeft";
static NSString *PTQuoteRight = @"PTQuoteRight";



@implementation PTAttributeStringTool


//+(NSMutableAttributedString *)convertEmojiWithAttributedString:(NSAttributedString *)attributedString contentDictionary:(NSDictionary *)contentDictionary font:(UIFont *)font{
//    if (!attributedString || !contentDictionary) {
//        return nil;
//    }
//    NSString *regularExpression = @"\\[\\w+\\]"; //正则表达式 i.e. [大笑]
//    NSError *error = nil;
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:&error];
//    NSArray *matches = [regex matchesInString:attributedString.string
//                                      options:0
//                                        range:NSMakeRange(0, attributedString.string.length)];
//
//    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
//    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSRange matchRange = [obj rangeAtIndex:0];
//        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//        attachment.image = [UIImage imageNamed:[contentDictionary safeObjectForKey:[attributedString.string substringWithRange:matchRange]]];
//        attachment.bounds = CGRectMake(0, (font.pointSize-font.lineHeight)/2, font.pointSize, font.pointSize);
//        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
//        if (attachment.image != nil) {
//            [mutableAttributedString replaceCharactersInRange:matchRange withAttributedString:attachmentString];
//        }
//        
//    }];
//
//    return mutableAttributedString;
//}

+ (NSAttributedString *)highlightText:(NSString *)targetText inFullText:(NSString*) fullText font:(UIFont *)font highlightColor:(UIColor *)highlightColor{
    
    if (!targetText || !fullText) {
        return nil;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:targetText options:0 error:&error];
    NSArray *matches = [regex matchesInString:fullText
                                      options:0
                                        range:NSMakeRange(0, fullText.length)];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [attributedString length])];
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match rangeAtIndex:0];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:highlightColor
                                 range:matchRange];
    }
    
    return attributedString;
}

+ (NSAttributedString *)setLineSpacing:(CGFloat)lineSpace withAttributedText:(NSMutableAttributedString *)attributedText font:(UIFont *)font{
    if (attributedText.string.length == 0) {
        return nil ;
    }
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.string.length)];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpace;
    style.alignment = NSTextAlignmentJustified;
    [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.string.length)];
    return attributedText;
}

+ (CGFloat)getHeightForAttributedString:(NSAttributedString *)attributedString boundingRect:(CGSize)boundingRect{
    CGRect paragraphRect =
    [attributedString boundingRectWithSize:boundingRect
                                 options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 context:nil];
    return ceilf(paragraphRect.size.height);
}

+(NSArray *)decompositeHTMLCode:(NSString *)code{

    //特殊符号转译（为了避免正则表达式里的字符问题）
    code = [PTAttributeStringTool encodeStringByEscapingSymbols:code];
    //**********************Searching strings components**********************//
    NSArray *basicComponents = [code componentsSeparatedByString:@"<br>"];
    NSInteger index = 0;
    NSMutableArray *textComponents = [[NSMutableArray alloc] init];
    for(NSString *substring in basicComponents){
        NSArray *matches = [PTAttributeStringTool regexMatchString:substring withRegularExpression:@">\\w+<" matchRange:NSMakeRange(0, substring.length)];
        NSMutableArray *localTextGroup = [[NSMutableArray alloc] init];
        for (NSTextCheckingResult *match in matches){
            
            NSRange matchRange = [match rangeAtIndex:0];
            NSString *matchString = [substring substringWithRange:matchRange];
            matchString = [matchString stringByReplacingOccurrencesOfString:@"<" withString:@""];
            matchString = [matchString stringByReplacingOccurrencesOfString:@">" withString:@""];
            matchString = [matchString stringByReplacingOccurrencesOfString:@"bold" withString:@""];
            //特殊符号转译
            matchString = [PTAttributeStringTool decodeStringBySymbolCode:matchString];
           // NSLog(@"%@",matchString);
            [localTextGroup addObject:matchString];
        }
        [textComponents addObject:localTextGroup];
        
        index++;
    }
    // NSLog(@"Global Components :%@",textComponents);
    
    //**********************Searching font settings components**********************//
    NSMutableArray *fontComponents = [[NSMutableArray alloc] init];
    NSArray *matches = [PTAttributeStringTool regexMatchString:code withRegularExpression:@"<font .*?>" matchRange:NSMakeRange(0, code.length)];
    for (NSTextCheckingResult *match in matches){
        
        NSRange matchRange = [match rangeAtIndex:0];
        NSString *matchString = [code substringWithRange:matchRange];
        matchString = [matchString stringByReplacingOccurrencesOfString:@"<" withString:@""];
        matchString = [matchString stringByReplacingOccurrencesOfString:@">" withString:@""];
        NSString *colorValueString = @"";
        NSString *sizeValueString = @"";
        NSString *boldValueString = @"";
        NSArray *fontSettings = [matchString componentsSeparatedByString:@" "];
        for(NSString *fontSettingComponents in fontSettings){
            
            if ([fontSettingComponents rangeOfString:@"color="].location != NSNotFound) {
                colorValueString = [fontSettingComponents stringByReplacingOccurrencesOfString:@"color=" withString:@""];
            }
            if ([fontSettingComponents rangeOfString:@"size="].location != NSNotFound) {
                sizeValueString = [fontSettingComponents stringByReplacingOccurrencesOfString:@"size=" withString:@""];
            }
            if ([fontSettingComponents rangeOfString:@"bold"].location != NSNotFound) {
                boldValueString = fontSettingComponents;
            }
            
        }
        if (colorValueString.length == 0) {
            colorValueString = @"000000";
        }
        if (sizeValueString.length == 0) {
            sizeValueString = @"14";
        }
        NSDictionary *fontSettingsDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:colorValueString,@"color",sizeValueString,@"size",boldValueString,@"bold", nil];
        
        // NSLog(@"Font:%@",fontSettingsDictionary);
        [fontComponents addObject:fontSettingsDictionary];
    }
    
    //**********************Combining text with Settings**********************//
    NSInteger fontSettingIndex = 0;
    NSMutableArray *attributedStringGroupResult = [[NSMutableArray alloc] init];
    for(NSArray *textGroup in textComponents){
        NSMutableAttributedString *attributedStringComplete = [[NSMutableAttributedString alloc] init];
        for(NSString *text in textGroup){
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            NSDictionary *fontSetting = [fontComponents safeObjectAtIndex:fontSettingIndex];
            if (fontSetting == nil) {
                break;
            }
            if ([[fontSetting safeObjectForKey:@"bold"] isEqualToString:@"bold"]) {
                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2f){
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[[fontSetting safeObjectForKey:@"size"] floatValue] weight:UIFontWeightBold] range:NSMakeRange(0, [attributedString length])];
                }else{
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:[[fontSetting safeObjectForKey:@"size"] floatValue]] range:NSMakeRange(0, [attributedString length])];
                }
            }else{
                if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.2f){
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[[fontSetting safeObjectForKey:@"size"] floatValue] weight:UIFontWeightLight] range:NSMakeRange(0, [text length])];
                }else{
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:[[fontSetting safeObjectForKey:@"size"] floatValue]] range:NSMakeRange(0, [text length])];
                }
            }
            if ([fontSetting safeObjectForKey:@"color"]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:[fontSetting safeObjectForKey:@"color"]] range:NSMakeRange(0, [text length])];
            }else{
            
            }
            
            [attributedStringComplete appendAttributedString:attributedString];
            fontSettingIndex++;
        }
        [attributedStringGroupResult addObject:attributedStringComplete];
    }
    //NSLog(@"Attribute %@",attributedStringGroupResult);
    return attributedStringGroupResult;
}

+(NSString *)encodeStringByEscapingSymbols:(NSString *)string{
    string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:PTNextLine];
    string = [string stringByReplacingOccurrencesOfString:@"%" withString:PTModulus];
    string = [string stringByReplacingOccurrencesOfString:@"％" withString:PTModulus];
    string = [string stringByReplacingOccurrencesOfString:@"！" withString:PTExclam];
    string = [string stringByReplacingOccurrencesOfString:@"!" withString:PTExclam];
    string = [string stringByReplacingOccurrencesOfString:@"," withString:PTBreak];
    string = [string stringByReplacingOccurrencesOfString:@"，" withString:PTBreak];
    string = [string stringByReplacingOccurrencesOfString:@"。" withString:PTStop];
    string = [string stringByReplacingOccurrencesOfString:@"/" withString:PTSlash];
    string = [string stringByReplacingOccurrencesOfString:@"《" withString:PTMusicLeft];
    string = [string stringByReplacingOccurrencesOfString:@"》" withString:PTMusicRight];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:PTBracketLeft];
    string = [string stringByReplacingOccurrencesOfString:@"（" withString:PTBracketLeft];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:PTBracketRight];
    string = [string stringByReplacingOccurrencesOfString:@"）" withString:PTBracketRight];
    string = [string stringByReplacingOccurrencesOfString:@"：" withString:PTColon];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:PTColon];
    string = [string stringByReplacingOccurrencesOfString:@"；" withString:PTSemiColon];
    string = [string stringByReplacingOccurrencesOfString:@";" withString:PTSemiColon];
    string = [string stringByReplacingOccurrencesOfString:@"？" withString:PTQuestion];
    string = [string stringByReplacingOccurrencesOfString:@"?" withString:PTQuestion];
    string = [string stringByReplacingOccurrencesOfString:@"＋" withString:PTPlus];
    string = [string stringByReplacingOccurrencesOfString:@"+" withString:PTPlus];
    string = [string stringByReplacingOccurrencesOfString:@"－" withString:PTDash];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:PTDash];
    string = [string stringByReplacingOccurrencesOfString:@"——" withString:PTUnderscore];
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:PTUnderscore];
    string = [string stringByReplacingOccurrencesOfString:@"＊" withString:PTStar];
    string = [string stringByReplacingOccurrencesOfString:@"*" withString:PTStar];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:PTAmp];
    string = [string stringByReplacingOccurrencesOfString:@"……" withString:PTPower];
    string = [string stringByReplacingOccurrencesOfString:@"^" withString:PTPower];
    string = [string stringByReplacingOccurrencesOfString:@"¥" withString:PTDollar];
    string = [string stringByReplacingOccurrencesOfString:@"$" withString:PTDollar];
    string = [string stringByReplacingOccurrencesOfString:@"＃" withString:PTHash];
    string = [string stringByReplacingOccurrencesOfString:@"#" withString:PTHash];
    string = [string stringByReplacingOccurrencesOfString:@"@" withString:PTAt];
    string = [string stringByReplacingOccurrencesOfString:@"～" withString:PTTween];
    string = [string stringByReplacingOccurrencesOfString:@"~" withString:PTTween];
    string = [string stringByReplacingOccurrencesOfString:@"“" withString:PTQuoteLeft];
    string = [string stringByReplacingOccurrencesOfString:@"”" withString:PTQuoteRight];

    return string;
}

+(NSString *)decodeStringBySymbolCode:(NSString *)matchString{
    matchString = [matchString stringByReplacingOccurrencesOfString:PTNextLine withString:@"\n"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTModulus withString:@"％"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTSlash withString:@"/"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTExclam withString:@"！"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTBreak withString:@"，"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTStop withString:@"。"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTMusicLeft withString:@"《"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTMusicRight withString:@"》"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTBracketLeft withString:@"（"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTBracketRight withString:@"）"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTColon withString:@"："];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTSemiColon withString:@"；"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTQuestion withString:@"？"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTPlus withString:@"＋"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTDash withString:@"－"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTUnderscore withString:@"——"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTStar withString:@"＊"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTAmp withString:@"&"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTPower withString:@"……"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTDollar withString:@"¥"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTHash withString:@"＃"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTAt withString:@"@"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTTween withString:@"～"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTQuoteLeft withString:@"“"];
    matchString = [matchString stringByReplacingOccurrencesOfString:PTQuoteRight withString:@"”"];
    
    return matchString;
}

+(NSArray *)regexMatchString:(NSString *)string withRegularExpression:(NSString *)regularExpression matchRange:(NSRange)matchRange{

    if (string.length == 0) {
        return nil;
    }
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression options:0 error:&error];
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:matchRange];
    return matches;
}

@end
