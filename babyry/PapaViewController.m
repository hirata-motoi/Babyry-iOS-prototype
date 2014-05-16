//
//  PapaViewController.m
//  babyry
//
//  Created by kenjiszk on 2014/05/16.
//  Copyright (c) 2014年 com.babyry. All rights reserved.
//

#import "PapaViewController.h"

@interface PapaViewController ()

@end

@implementation PapaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self getImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Documents/newに画像がある場合
//   fullscreen表示+クイズの表示
// Documents/newに画像が無い場合
//   Documents/oldの画像を並べて表示(右上に日付表示とかやりたい)
- (void)getImages
{
    NSLog(@"yeah");
    // ホームディレクトリを取得
    NSString *dir1 = [NSString stringWithFormat:@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/new"]];
    NSString *dir2 = [NSString stringWithFormat:@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/old"]];
 
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
 
    NSError *error;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:dir1 error:&error];
 
    NSString *fullpath1;
    NSString *fullpath2;
    if ([list count] != 0) {
        UIImage *newImage;
        // ファイルやディレクトリの一覧を表示する
        for (NSString *path in list) {
            fullpath1 = [NSString stringWithFormat:@"%@/%@", dir1, path];
            fullpath2 = [NSString stringWithFormat:@"%@/%@", dir2, path];
            [fileManager moveItemAtPath:fullpath1 toPath:fullpath2 error:&error];
            newImage = [UIImage imageWithContentsOfFile:fullpath2];
        }
        UIImageView *newImageView = [[UIImageView alloc] initWithImage:newImage];
        newImageView.frame = CGRectMake(0, 0, 320, 480);
        [self.view addSubview:newImageView];
        
        // 質問
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 400, 320, 50);
        label.backgroundColor = [UIColor yellowColor];
        label.textColor = [UIColor blueColor];
        label.font = [UIFont fontWithName:@"AppleGothic" size:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"もといくんの体重は何キロになったでしょうか？";
        [self.view addSubview:label];
        
        // 答え入力
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(0, 450, 320, 50)];
        [tf setDelegate:self];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.textColor = [UIColor blueColor];
        tf.placeholder = @"答えをにゅうりょくしてください";
        tf.clearButtonMode = UITextFieldViewModeAlways;
        // 編集終了後フォーカスが外れた時にhogeメソッドを呼び出す
        [tf addTarget:self action:@selector(hoge:)
            forControlEvents:UIControlEventEditingDidEndOnExit];
        [self.view addSubview:tf];
    } else {
        // newにimageが無ければこっちが表示される
        NSMutableArray *oldImages = [NSMutableArray array];
        list = [fileManager contentsOfDirectoryAtPath:dir2 error:&error];
        UIImage *oldImage;
        for (NSString *path in list) {
            fullpath2 = [NSString stringWithFormat:@"%@/%@", dir2, path];
            oldImage = [UIImage imageWithContentsOfFile:fullpath2];
            [oldImages addObject:oldImage];
        }
        self.array = oldImages;
    
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];

        [self.view addSubview:_collectionView];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.array count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.array objectAtIndex:indexPath.row]];
    imageView.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    [cell addSubview: imageView];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

// 呼ばれるhogeメソッド
-(void)hoge:(UITextField*)textfield{
    // ここに何かの処理を記述する
    // （引数の textfield には呼び出し元のUITextFieldオブジェクトが引き渡されてきます）
}

// キーボードのReturnボタンがタップされたらキーボードを閉じるようにする
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
