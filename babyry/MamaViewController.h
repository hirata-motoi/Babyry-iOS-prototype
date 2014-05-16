//
//  MamaViewController.h
//  babyry
//
//  Created by kenjiszk on 2014/05/16.
//  Copyright (c) 2014年 com.babyry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MamaViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
- (IBAction)OpenPhotoLibrary:(id)sender;

@end
