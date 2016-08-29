//
//  ViewController.m
//  PYsousuokuang
//
//  Created by Apple on 16/7/23.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "UserDTO.h"
#import "NSString+pinyin.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *arr_1;//转拼音 市
@property (nonatomic, strong)NSMutableArray *arr_2;//搜索数据
@property (nonatomic, strong)NSMutableArray *arr_3; //省
@property (nonatomic, strong)NSMutableArray *arr_4;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, assign) BOOL isPYsousuo;//搜索状态
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *plistStr = [[NSBundle mainBundle] pathForResource:@"Province.plist" ofType:nil];
    self.dataArray = [[NSMutableArray array] initWithContentsOfFile:plistStr];
    [self PYjiazaiData];
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.navigationController.navigationBar.translucent = NO;

    //通知中心 1
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification  object:nil];
}
#pragma mark ====== 数据解析
- (void)PYjiazaiData {
    self.arr_1 = [NSMutableArray array];
    self.arr_2 = [NSMutableArray array];
    self.arr_3 = [NSMutableArray array];
    self.arr_4 = [NSMutableArray array];
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *array_1 = [NSMutableArray array];
    
    for (NSDictionary *dic_1 in self.dataArray) {
        [array_1 addObject:dic_1[@"province"]];
        for (NSDictionary *dic_2 in dic_1[@"citys"]) {
            [array addObject:dic_2[@"city"]];
        }
    }
    //转拼音  市
    for (int i = 0; i < array.count; i++) {
        UserDTO *userDTO = [[UserDTO alloc] init];
        
        //转拼音
//        NSString *Pinyin =[array[i] transformToPinyin];
//        //首字母
//        NSString *FirstLetter = [array[i] transformToPinyinFirstLetter];
        userDTO.name = array[i];
//        userDTO.namePinYin = Pinyin;
//        userDTO.nameFirstLetter = FirstLetter;
        
        [self.arr_1 addObject:userDTO];
    }
    
    [self.myTableView reloadData];
}

#pragma mark ====== textChange:
- (void)textChange:(NSNotification *)tion {
    UITextField *textField = (UITextField *)[tion object];
    [self srartSearch:textField.text];
}
- (void)srartSearch:(NSString *)string {
    if (self.arr_2.count > 0) {
        [self.arr_2 removeAllObjects];
    }
   
    //开始搜索
    NSString *key = self.myTextField.text.lowercaseString;//小写字母
    NSMutableArray *tempArr = [NSMutableArray array];
    
    if (![key isEqualToString:@""] && ![key isEqual:[NSNull null]] && key != nil) {
        
        [self.arr_1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UserDTO *userDTO = self.arr_1[idx];
            
            NSString *name = userDTO.name.lowercaseString;
//            NSString *namePinyin = userDTO.namePinYin.lowercaseString;
//            NSString *nameFirstLetter = userDTO.nameFirstLetter.lowercaseString;
            
            NSRange range_1 = [name rangeOfString:key];
            if (range_1.length > 0) {
                [tempArr addObject:userDTO];
            }
//            else { //拼音搜索,搜字母搜索
//                if ([nameFirstLetter containsString:key]) {
//                    [tempArr addObject:userDTO];
//                } else {
//                    if ([namePinyin containsString:key]) {
//                        [tempArr addObject:userDTO];
//                    }
//                }
//            }
        }];
        
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![self.arr_2 containsObject:tempArr[idx]]) {
                [self.arr_2 addObject:tempArr[idx]];
            }
        }];
        self.isPYsousuo = YES;
    } else {
        self.isPYsousuo = NO;
    }
    [self.myTableView reloadData];
}
#pragma mark ===== tab代理
//分区个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%lu", (unsigned long)self.dataArray.count);
    if (_isPYsousuo) {
        if (self.arr_2.count > 0) {
            return 1;
        } else {
            return 0;
        }
    } else {
        return self.dataArray.count;
    }
}
//分区行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //如果想自定义更多，就把noResultLab 换成一个大的BJView，里面再填充很多个小的控件
    
    UILabel *noResultLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    noResultLab.font = [UIFont systemFontOfSize:20];
    noResultLab.textColor = [UIColor lightGrayColor];
    noResultLab.textAlignment = NSTextAlignmentCenter;
    noResultLab.text = @"抱歉! 没有搜索到相关内容";
    tableView.backgroundView = noResultLab;

    if (_isPYsousuo) {
        if (self.arr_2.count > 0) {
            noResultLab.hidden = YES;
            NSLog(@"111");
            return self.arr_2.count;
        } else {
            return 0;
        }
        
    } else {
        return [self.dataArray[section][@"citys"] count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    UserDTO *userDTO = nil;
    if (_isPYsousuo) {
        userDTO = self.arr_2[indexPath.row];
        cell.textLabel.text = userDTO.name;

    } else {
//        userDTO = self.arr_1[indexPath.row];
        cell.textLabel.text = self.dataArray[indexPath.section][@"citys"][indexPath.row][@"city"];

    }
    return cell;
}
//页眉
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.arr_2 count] > 0) {
        return nil;
    }
    return self.dataArray[section][@"province"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
