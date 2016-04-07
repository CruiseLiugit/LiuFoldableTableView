//
//  PTGameMapListHeaderView.m
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTGameMapListHeaderView.h"

//Controller
#import "PTAttributeStringTool.h"

//算用户姓名高度
CGSize operatePTGameMapListHeaderViewGameContentSizeWithContent(NSString *text,CGFloat textWidth){
    CGSize size = CGSizeMake(0.0f, 0.0f);
    if(text && text.length > 0) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];    //行间距
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"313131"] range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [attributedString length])];
        
        
         CGFloat textHeight = [PTAttributeStringTool getHeightForAttributedString:attributedString  boundingRect:CGSizeMake(textWidth, CGFLOAT_MAX)];
        
        size = CGSizeMake(textWidth, textHeight);
    }
    return (size);
}


static CGFloat const GameMapListHeaderViewHeight = 44.0f;
static CGFloat const GameMapListHeaderViewGameIconWH = 14.0f;
static CGFloat const GameMapListHeaderViewIconWH = 14.0f;
static CGFloat const GameMapListHeaderViewInset = 15.0f;


@interface PTGameMapListHeaderView ()
@property (nonatomic,strong) UIView *headerView;      //显示游戏理念、带点击操作、类似Table SectionHeader
@property (nonatomic,strong) UIView *gameContentView;  //显示游戏理念详情

@property (nonatomic,strong) UIImageView *gameIcon;
@property (nonatomic,strong) UILabel *gameTitle;
@property (nonatomic,strong) UIImageView *icon;        //箭头图标
@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UILabel *gameContent;
@end

@implementation PTGameMapListHeaderView{
    NSString *_tempGameContent;
}
@synthesize headerView = _headerView;
@synthesize gameContentView = _gameContentView;
@synthesize gameIcon = _gameIcon;
@synthesize gameTitle = _gameTitle;
@synthesize icon = _icon;
@synthesize btn = _btn;
@synthesize gameContent = _gameContent;

+ (CGFloat)getHeaderViewHeighWithItem:(PTGameMapListItem *)item{
    CGFloat height = 0.0f;
    height += GameMapListHeaderViewHeight;
    
    CGFloat width = Screenwidth-GameMapListHeaderViewInset*2;
    CGSize gameContentSize = operatePTGameMapListHeaderViewGameContentSizeWithContent(item.description_content,width);
    height += gameContentSize.height;
    
    height += GameMapListHeaderViewInset*2;  //文字上下间距
    
    return height;
}

- (void)dealloc {
    SORELEASE(_headerView);
    SORELEASE(_gameContentView);
    SORELEASE(_gameIcon);
    SORELEASE(_gameTitle);
    SORELEASE(_btn);
    SORELEASE(_gameContent);
    SORELEASE(_icon);
    SOSUPERDEALLOC();
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _tempGameContent = @"";
        
        [self addSubview:self.headerView];
        [self addSubview:self.gameContentView];
        
        [self.gameContentView addSubview:self.gameContent];
    }
    return (self);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.bounds)-GameMapListHeaderViewInset*2;
    CGSize gameContentSize = CGSizeMake(0.0f, 0.0f);
    if (_tempGameContent.length > 0) {
        gameContentSize = operatePTGameMapListHeaderViewGameContentSizeWithContent(_tempGameContent,width);
        self.gameContentView.frame = CGRectMake(0.0f, GameMapListHeaderViewHeight, self.width, gameContentSize.height+GameMapListHeaderViewInset*2);
    }else{
        self.gameContentView.frame = CGRectMake(0.0f, GameMapListHeaderViewHeight, self.width, gameContentSize.height);
    }
    
    self.gameContent.frame = CGRectMake(GameMapListHeaderViewInset, GameMapListHeaderViewInset, gameContentSize.width, gameContentSize.height);
}

#pragma mark - getter
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.width, GameMapListHeaderViewHeight)];
        _headerView.backgroundColor = [UIColor grayColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTap)];
        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

- (UIView *)gameContentView{
    if (!_gameContentView) {
        _gameContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _gameContentView.backgroundColor = [UIColor whiteColor];
    }
    
    return _gameContentView;
}

- (UILabel *)gameContent{
    if (!_gameContent) {
        _gameContent = [[UILabel alloc] initWithFrame:CGRectZero];
        _gameContent.backgroundColor = [UIColor clearColor];
        _gameContent.font = [UIFont systemFontOfSize:14.0f];
        _gameContent.numberOfLines = 0;
        _gameContent.textAlignment = NSTextAlignmentLeft;
    }
    return _gameContent;
}
#pragma mark -


#pragma mark - setter
- (void)setItem:(PTGameMapListItem *)item{
    _item = item;
    
    if (!_item) {
        return;
    }
    
    _tempGameContent = item.description_content;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:item.description_content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];    //行间距
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"313131"] range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedString length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [attributedString length])];
    self.gameContent.attributedText = attributedString;

    [self setNeedsLayout];
    
}

- (void)setExpand:(BOOL)expand{
    _expand = expand;
    
}
#pragma mark -


#pragma mark - action
- (void)headerViewTap{
    BOOL flag = !self.expand;
    if (!flag) {
        _tempGameContent = @"";
        [self setNeedsLayout];
    }else{
        _tempGameContent = self.item.description_content;
        [self setNeedsLayout];
    }
    //重新计算游戏理念高度
    if (self.actionBlock) {
        self.actionBlock(flag);
    }
    
}
#pragma mark -


@end
