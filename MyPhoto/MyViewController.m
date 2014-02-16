//
//  MyViewController.m
//  MyPhoto
//
//  Created by dingql on 13-11-30.
//  Copyright (c) 2013年 dingql. All rights reserved.
//

#import "MyViewController.h"
#import "SDWebImage.framework/Headers/UIImageView+WebCache.h"
#import "Beauty.h"

#define kCellImageWidth 55
#define kCellImageHeight kCellImageWidth

/*
static NSString * MyCellIndentifier = @"MyCell";
@interface MyTableViewCell : UITableViewCell

@end

@implementation MyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCellIndentifier];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5, 5, 55, 55);
    self.textLabel.frame = CGRectMake(65, 5, 50, 20);
    self.detailTextLabel.frame = CGRectMake(65, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}

@end
*/

@interface MyViewController ()
@property(nonatomic, strong) NSMutableArray * contentArray;
@property(nonatomic, strong) UITableView * tableView;
@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"相册";
    
    self.tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.contentArray = [NSMutableArray array];
    /*
    // 加载Url方法一
    NSURL * url = [NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/w%3D2048/sign=2908f41a9045d688a302b5a490fa7c1e/a50f4bfbfbedab64e9ba70e9f536afc378311eca.jpg"];
    [self.urlArray addObject:url];
    url = [NSURL URLWithString:@"http://a.hiphotos.baidu.com/image/w%3D2048/sign=9927ed296509c93d07f209f7ab05f8dc/d50735fae6cd7b89ce619da40d2442a7d9330e83.jpg"];
    [self.urlArray addObject:url];
    url = [NSURL URLWithString:@"http://f.hiphotos.baidu.com/image/w%3D2048/sign=7c3ff04e7aec54e741ec1d1e8d009b50/574e9258d109b3dec1829918cdbf6c81800a4c84.jpg"];
    [self.urlArray addObject:url];
    url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/w%3D2048/sign=3eab5639950a304e5222a7fae5f0a686/80cb39dbb6fd526613a21e29a918972bd4073605.jpg"];
    [self.urlArray addObject:url];
    url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/w%3D2048/sign=1ad475115b82b2b7a79f3ec40595caef/b58f8c5494eef01f81b9f5d0e2fe9925bc317d72.jpg"];
    [self.urlArray addObject:url];
    url = [NSURL URLWithString:@"http://d.hiphotos.baidu.com/image/w%3D2048/sign=86d4aac191ef76c6d0d2fc2ba92efcfa/b03533fa828ba61ecbdab0cf4034970a304e591d.jpg"];
    [self.urlArray addObject:url];
    */
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"imageUrl" ofType:@"plist"];
    NSArray * array = [NSArray arrayWithContentsOfFile:path];
    
    for (NSDictionary * dict in array) {
        @autoreleasepool {
            Beauty * beauty = [Beauty beautyWithDictionary:dict];
            [self.contentArray addObject:beauty];
        }
    }
    
    [self.view addSubview:_tableView];
	
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark -
#pragma mark Delegate
// 动态适应cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:1000];
    return imageView.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    [imageView setImageWithURL:((Beauty *)[self.contentArray objectAtIndex:indexPath.row]).url];
    
    UIViewController * viewController = [[UIViewController alloc] init];
    [viewController.view addSubview:imageView];
    viewController.navigationItem.title = ((Beauty *)([self.contentArray objectAtIndex:indexPath.row])).name;
    
    [self.navigationController pushViewController:viewController animated:YES];
}
// 编辑模式，只要实现该函数就会出现滑动删除按钮
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle != UITableViewCellEditingStyleDelete) return;
    
    [_contentArray removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark -
#pragma mark DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"reuseCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        /*
        // 方法一：定义UITableViewCell的子类，重写layoutSubviews，自己定义cell中子视图的布局，直接使用子类的属性就可以取得cell的
        // 子视图，修改起来比较方便
        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyCellIndentifier];
        [cell.imageView setImageWithURL:[self.urlArray objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"114.png"]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIFont * font = [UIFont systemFontOfSize:15.0f];
        [cell.textLabel setFont: font];
        cell.textLabel.text = [NSString stringWithFormat:@"美女%d", indexPath.row + 1];
        //font = [UIFont fontWithName:@"AppleGothic" size:10.0f];
        cell.detailTextLabel.text = @"校花";
        //[cell layoutIfNeeded];
        //NSLog(@"%@", NSHomeDirectory());
        */
        
        
        // 方法二：自己定义UIImageView，然后设置其为cell的子视图，与方法一类似，缺点：如果后面需要对cell的子视图显示的内容进行修改
        // 会比较复杂
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UIImageView* photoView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, kCellImageWidth, kCellImageHeight)];
        [photoView setImageWithURL:((Beauty *)([self.contentArray objectAtIndex:indexPath.row])).url placeholderImage:[UIImage imageNamed:@"114.png"]];
        [photoView setTag:1000];
        [cell.contentView addSubview:photoView];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(photoView.frame.origin.x + photoView.frame.size.width + 10, photoView.frame.origin.y + 5, 100, 20)];
        [textLabel setFont:[UIFont systemFontOfSize:18.0f]];
        textLabel.text = ((Beauty *)([self.contentArray objectAtIndex:indexPath.row])).name;
        [cell.contentView addSubview:textLabel];
        
        UILabel * detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(textLabel.frame.origin.x, textLabel.frame.origin.y + 30, 200, 15)];
        [detailLabel setFont:[UIFont systemFontOfSize:12.0f]];
        detailLabel.text = ((Beauty *)([self.contentArray objectAtIndex:indexPath.row])).desc;
        [cell.contentView addSubview:detailLabel];
        
        //NSLog(@"subViews:%d", cell.subviews.count);
        
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
