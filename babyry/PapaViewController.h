//
//  PapaViewController.h
//  babyry
//
//  Created by kenjiszk on 2014/05/16.
//  Copyright (c) 2014年 com.babyry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PapaViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
}
@property (strong, nonatomic) NSArray *array;

@end
