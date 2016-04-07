//
//  PTGameMapListVC.m
//  PTLatitude
//
//  Created by LiLiLiu on 16/4/6.
//  Copyright © 2016年 PT. All rights reserved.
//

#import "PTGameMapListVC.h"

//Model
#import "PTGameMapListModel.h"
#import "PTGameMapListItem.h"
#import "PTGameMapLevelListItem.h"
#import "PTGameMapLevelItem.h"

//View
#import "PTGameMapListHeaderView.h"

static CGFloat const PTGameMapListVCTableSectionHeaderViewHeight = 44.0f;

static NSString * const PTGameMapListVCCellIdentifier = @"PTGameMapListVCCellIdentifier";

@interface PTGameMapListVC ()<UITableViewDataSource, UITableViewDelegate>{
    PTGameMapListModel *_model;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableSectionDatasource;
@property (strong, nonatomic) NSMutableArray *tableCellDatasource;

@property (strong, nonatomic) PTGameMapListHeaderView *tableHeaderView;

@property (strong, nonatomic) PTGameMapListItem *gameMapItem;    //服务器获取的关卡总数据
@end

@implementation PTGameMapListVC{
    //防止重复请求开关
    BOOL _modelRequest;
    
    //表的数据源数组
    NSMutableArray*_CurrentArray;
}
@synthesize tableView = _tableView;
@synthesize tableSectionDatasource = _tableSectionDatasource;
@synthesize tableCellDatasource = _tableCellDatasource;
@synthesize tableHeaderView = _tableHeaderView;
@synthesize gameMapItem = _gameMapItem;

- (void)dealloc {
    SORELEASE(_tableView);
    SORELEASE(_tableSectionDatasource);
    SORELEASE(_tableCellDatasource);
    SORELEASE(_tableHeaderView);
    SORELEASE(_gameMapItem);
    SOSUPERDEALLOC();
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        _modelRequest = NO;
        
        _tableView = nil;
        _tableSectionDatasource = [[NSMutableArray alloc]initWithCapacity:0];
        _tableCellDatasource = [[NSMutableArray alloc]initWithCapacity:0];
        //控制扩展的表数据源数组
        _CurrentArray = [[NSMutableArray alloc]initWithCapacity:0];
        
        _gameMapItem = nil;
        
        _model = [[PTGameMapListModel alloc] init];
    }
    return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"EBEBEB"];
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0.0f, HEIGHT_STATUS+HEIGHT_NAV, Screenwidth, Screenheight-HEIGHT_NAV-HEIGHT_STATUS);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self requestData];
}


#pragma mark - getter
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        UIEdgeInsets contentInsets = _tableView.contentInset;
        contentInsets.bottom = HEIGHT_BAR+HEIGHT_STATUS;
        _tableView.contentInset = contentInsets;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.separatorColor = [UIColor clearColor];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:PTGameMapListVCCellIdentifier];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView clearExtendCellLine];
    }
    return (_tableView);
}

- (PTGameMapListHeaderView *)tableHeaderView{
    if (!_tableHeaderView) {
        _tableHeaderView = [[PTGameMapListHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, Screenwidth, PTGameMapListVCTableSectionHeaderViewHeight)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
        _tableHeaderView.expand = NO;   //默认不展开
        
        __weak typeof(self) weak_self = self;
        _tableHeaderView.actionBlock = ^(BOOL isExpand){

            if (!isExpand) {
                weak_self.tableHeaderView.frame = CGRectMake(0.0f, 0.0f, Screenwidth, PTGameMapListVCTableSectionHeaderViewHeight);
                weak_self.tableHeaderView.expand = NO;
                [weak_self.tableView setTableHeaderView:weak_self.tableHeaderView];
            }else{
                CGFloat tableHeaderViewHeight = [PTGameMapListHeaderView getHeaderViewHeighWithItem:weak_self.gameMapItem];
                weak_self.tableHeaderView.frame = CGRectMake(0.0f, 0.0f, Screenwidth, tableHeaderViewHeight);
                weak_self.tableHeaderView.expand = YES;       //有数据设置为展开
                [weak_self.tableView setTableHeaderView:weak_self.tableHeaderView];
            }
            
            [weak_self.tableView reloadData];
        };
    }
    return _tableHeaderView;
}



#pragma mark - action
//点击区头按钮 修改数据源数组 展开区
- (void)expand:(UIButton*)btn
{
    NSInteger section = btn.tag;
    if([[_CurrentArray objectAtIndex:btn.tag] isEqualToArray:@[]])
    {
        NSArray *levels_list = nil;
        if (self.tableSectionDatasource && self.tableSectionDatasource.count > 0) {
            if ([[self.tableSectionDatasource safeObjectAtIndex:section] isKindOfClass:[PTGameMapLevelListItem class]]) {
                
                PTGameMapLevelListItem *levellList = (PTGameMapLevelListItem *)[self.tableSectionDatasource safeObjectAtIndex:section];
                
                if (levellList && levellList.levels_list && levellList.levels_list.count > 0) {
                    levels_list = levellList.levels_list;
                }
            }
        }
        
        
        [_CurrentArray replaceObjectAtIndex:btn.tag withObject:levels_list];
    }else
    {
        [_CurrentArray replaceObjectAtIndex:btn.tag withObject:@[]];
    }
    
    //只更新当前折叠的 Section
    NSIndexSet *sectionSet = [NSIndexSet indexSetWithIndex:section];
    [_tableView beginUpdates];
    [_tableView reloadSections:sectionSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [_tableView endUpdates];
}


- (void)requestData{
    NSMutableArray *data = [_model parseResponseData];
    _gameMapItem = (PTGameMapListItem *)[data safeObjectAtIndex:0];
    NSArray *levels = _gameMapItem.levels;
    
    //更新 tableHeaderView
    self.tableHeaderView.item = _gameMapItem;
    CGFloat tableHeaderViewHeight = [PTGameMapListHeaderView getHeaderViewHeighWithItem:_gameMapItem];
    self.tableHeaderView.frame = CGRectMake(0.0f, 0.0f, Screenwidth, tableHeaderViewHeight);
    self.tableHeaderView.expand = YES;   //有数据设置为展开
    [self.tableView setTableHeaderView:self.tableHeaderView];
    
    //折叠 Cell 创建对应Section数量的空数组
    for (int i = 0; i<levels.count; i++) {
        [_CurrentArray addObject:@[]];
    }
    
    //更新 table
    [self.tableSectionDatasource removeAllObjects];
    self.tableSectionDatasource = [NSMutableArray arrayWithArray:levels];
    [self.tableView reloadData];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.tableSectionDatasource && self.tableSectionDatasource.count > 0) {
        return _CurrentArray.count;
    }
    return (0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tableSectionDatasource && self.tableSectionDatasource.count > 0) {
        if ([[self.tableSectionDatasource safeObjectAtIndex:section] isKindOfClass:[PTGameMapLevelListItem class]]) {
            
            return [[_CurrentArray objectAtIndex:section]count];
        }
    }
    return (0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PTGameMapListVCCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = @"一个Cell";
    
    return cell;
}
#pragma mark -





#pragma mark - <UITableViewDelegate>
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, PTGameMapListVCTableSectionHeaderViewHeight)];
    view.backgroundColor = [UIColor yellowColor];
    
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, self.view.width,44);
    btn.backgroundColor=[UIColor clearColor];
    
    CALayer *btnLayer = btn.layer;
    btnLayer.borderWidth = 1.0f;
    btnLayer.borderColor = [UIColor redColor].CGColor;
    
    btn.tag = section;
    //带点击的头部、点击扩展 Section
    [btn addTarget:self action:@selector(expand:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PTGameMapListVCTableSectionHeaderViewHeight;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - <SOViewControllerProtocol>
- (void)setParameters:(id)parameters {
    [super setParameters:parameters];
    
}
#pragma mark -


#pragma mark - <SOModelDelegate>
/*
- (void)model:(SOBaseModel *)model didReceivedData:(id)data userInfo:(id)info {
    [self stopLoadAnimation];
    
    if (_model == model) {
        if (data && [data isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *addressList = (NSMutableArray *)data;
            
            _gameMapItem = (PTGameMapListItem *)[addressList safeObjectAtIndex:0];
            
            NSArray *levels = _gameMapItem.levels;
            
            
            //更新 tableHeaderView
            self.tableHeaderView.item = _gameMapItem;
            CGFloat tableHeaderViewHeight = [PTGameMapListHeaderView getHeaderViewHeighWithItem:_gameMapItem];
            self.tableHeaderView.frame = CGRectMake(0.0f, 0.0f, Screenwidth, tableHeaderViewHeight);
            self.tableHeaderView.expand = YES;   //有数据设置为展开
            [self.tableView setTableHeaderView:self.tableHeaderView];
            
            SOLog(@"tableHeaderView Frame : %@",NSStringFromCGRect(self.tableHeaderView.frame));
            
            //折叠 Cell 创建对应Section数量的空数组
            for (int i = 0; i<levels.count; i++) {
                [_CurrentArray addObject:@[]];
            }
            
            //更新 table
            [self.tableSectionDatasource removeAllObjects];
            self.tableSectionDatasource = [NSMutableArray arrayWithArray:levels];
            [self.tableView reloadData];
            
        }else{
            SOLog(@"gameMapItem nil");
        }
        
        return;
    }
}

- (void)model:(SOBaseModel *)model didFailedInfo:(id)info error:(id)error {
    [self stopLoadAnimation];
    
    NSString *msg = PT_RESPONSE_ERROR_MSG;
    if(info && [info isKindOfClass:[NSDictionary class]] && [info stringObjectForKey:@"msg"] && [info stringObjectForKey:@"msg"].length > 0) {
        msg = [info stringObjectForKey:@"msg"];
    }
    //    [SOAutoHideMessageView showMessage:msg inView:self.view];
}
 */
#pragma mark -
@end
