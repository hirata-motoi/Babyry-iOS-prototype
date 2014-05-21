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

@implementation MamaViewController {
    UIPickerView *quiz_picker;
}
@synthesize selectedImage;
@synthesize quizes;
@synthesize selectedQuizIndex;

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
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                             target:self action:@selector(submit)];
    self.navigationItem.rightBarButtonItem = btn;
    quizes = [NSMutableArray arrayWithObjects:
              @"りょうたくんの身長は何センチでしょう？",
              @"けんじくんの体重は何キロでしょう？",
              @"すなおくんの視力はいくつでしょう？",
              nil
              ];
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

// pickした画像を表示
// クイズを選択
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	// オリジナル画像
	UIImage *originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // JPEGのデータを保持
    selectedImage = UIImageJPEGRepresentation(originalImage, 0.8f);
    

    // imageをちょっと小さめに表示
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:[[UIScreen mainScreen]applicationFrame]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImage:originalImage];
    [self.view addSubview:imageView];
    // クイズ選択のpickerを表示
    // UIPickerのインスタンス化
    quiz_picker = [[UIPickerView alloc]init];
    
    // デリゲートを設定
    quiz_picker.delegate = self;
    
    // データソースを設定
    quiz_picker.dataSource = self;
    
    // 選択インジケータを表示
    quiz_picker.showsSelectionIndicator = YES;
    
    // UIPickerのインスタンスをビューに追加
    [self.view addSubview:quiz_picker];
    
}



-(void)imagePickerControllerOld:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
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

/**
 * ピッカーに表示する列数を返す
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

/**
 * ピッカーに表示する行数を返す
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

/**
 * 行のサイズを変更
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView
    widthForComponent:(NSInteger)component
{
    switch (component) {
        case 0: // 1列目
            return 200.0;
            break;
            
        default:
            return 0;
            break;
    }
}

/**
 * ピッカーに表示する値を返す
 */
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (row) {
        case 0: // 1行目
            return [ NSString stringWithFormat:@"%@", @"りょうたくんの身長は何センチでしょう？" ];
            break;
        case 1: // 2行目
            return [ NSString stringWithFormat:@"%@", @"けんじくんの体重は何キロでしょう？" ];
            break;
        case 2: // 3行目
            return [ NSString stringWithFormat:@"%@", @"すなおくんの視力はいくつでしょう？" ];
            break;
        default:
            return 0;
            break;
    }
}

/**
 * ピッカーの選択行が決まったとき
 */
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // 1列目の選択された行数を取得
    NSInteger val = [pickerView selectedRowInComponent:0];
    selectedQuizIndex = val;
    NSLog(@"%d", val);
}


// 画像とクイズの文面を送信する
//selectedImageとselectedQuizを送る
-(void)submit {
    NSLog(@"aaaaaaaaaaaaaaaaaaa");
    
    NSDate *datetime = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMddHHmmss";
    NSString *time = [fmt stringFromDate:datetime];  //表示するため文字列に変換する
    NSString *url  = @"http://localhost:5004/image/web/upload_execute.json";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"---------------------------168072824752491622650073";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // quiz
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"json\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: application/json; charset=UTF-8\r\n" dataUsingEncoding:NSUTF8StringEncoding]];[body appendData:[@"Content-Transfer-Encoding: 8bit\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *bodyString = [NSString stringWithFormat:@""
                            "{ \"quiz\": \"%@\" }", [quizes objectAtIndex:selectedQuizIndex] ];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", bodyString] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 画像
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"user.png\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:selectedImage]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", returnString);
}

@end
