//
//  MamaViewController.m
//  babyry
//
//  Created by kenjiszk on 2014/05/16.
//  Copyright (c) 2014年 com.babyry. All rights reserved.
//

#import "MamaViewController.h"

@interface MamaViewController ()

@end

@implementation MamaViewController

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

// ボタンを押すとここが実行される
// OpenPhotoLibraryで開いて一枚チョイスしたらimagePickerControllerでs3に送りたい(けど今はやってない)
// 現状は、新しい画像はアプリ内のDocuments/newという所に突っ込んでいる。
// ファイル名はyyyymmddhhmmss.jpg (png対応もしないと)
- (IBAction)OpenPhotoLibrary:(id)sender {
    // インタフェース使用可能なら
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
        // UIImageControllerの初期化
		UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
		[imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		[imagePickerController setAllowsEditing:YES];
		[imagePickerController setDelegate:self];
		
        [self presentViewController:imagePickerController animated:YES completion: nil];
	}
	else
	{
		NSLog(@"photo library invalid.");
	}
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// オリジナル画像
	UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // JPEGのデータとしてNSDataを作成します
    NSData *data = UIImageJPEGRepresentation(originalImage, 0.8f);
    
    NSDate *datetime = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMddHHmmss";
    NSString *time = [fmt stringFromDate:datetime];  //表示するため文字列に変換する
    
    // 保存するディレクトリを指定します
    NSString *dir1 = [NSString stringWithFormat:@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/new"]];
    NSString *dir2 = [NSString stringWithFormat:@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/old"]];
    NSString *path = [NSString stringWithFormat:@"%@/%@.jpg", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/new"], time];
    NSLog(@"%@", path);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error1 = nil;
    BOOL created1 = [fileManager createDirectoryAtPath:dir1 withIntermediateDirectories:YES attributes:nil error:&error1];
    // 作成に失敗した場合
    if (!created1) {
        NSLog(@"failed to create directory. reason is %@ - %@", error1, error1.userInfo);
    }
    NSError *error2 = nil;
    BOOL created2 = [fileManager createDirectoryAtPath:dir2 withIntermediateDirectories:YES attributes:nil error:&error2];
    // 作成に失敗した場合
    if (!created2) {
        NSLog(@"failed to create directory. reason is %@ - %@", error2, error2.userInfo);
    }
    
    // NSDataのwriteToFileメソッドを使ってファイルに書き込みます
    // atomically=YESの場合、同名のファイルがあったら、まずは別名で作成して、その後、ファイルの上書きを行います
    if ([data writeToFile:path atomically:YES]) {
        NSLog(@"save OK");
    } else {
        NSLog(@"save NG");
    }
}

@end
