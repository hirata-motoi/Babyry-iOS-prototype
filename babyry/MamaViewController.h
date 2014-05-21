//
//  MamaViewController.h
//  babyry
//
//  Created by kenjiszk on 2014/05/16.
//  Copyright (c) 2014年 com.babyry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MamaViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
- (IBAction)OpenPhotoLibrary:(id)sender;
@property (nonatomic,retain)NSData *selectedImage;
@property (nonatomic,retain)NSMutableArray *quizes;
@property int selectedQuizIndex;

@end
