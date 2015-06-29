//
//  MisMascotas.h
//  Pet Locator
//
//  Created by Angel Rivas on 6/22/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MisMascotas : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    
    NSMutableArray *label_array;
    UIRefreshControl* refreshControl;
    
}

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end
