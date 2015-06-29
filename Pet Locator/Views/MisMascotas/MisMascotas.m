//
//  MisMascotas.m
//  Pet Locator
//
//  Created by Angel Rivas on 6/22/15.
//  Copyright (c) 2015 tecnologizame. All rights reserved.
//

#import "MisMascotas.h"
#import "CustomCollectionViewCell.h"

@interface MisMascotas ()

@end

@implementation MisMascotas

- (void)viewDidLoad {
    [super viewDidLoad];
    label_array = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<23; i++){
        [label_array addObject:[NSString stringWithFormat:@"%d", i]];
    }
                   
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //CollectionCell
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    
  //  [self.collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell_iPhone6" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"CollectionCell"];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.collectionView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
}

-(void)refreshTable{
    [refreshControl endRefreshing];
}

#pragma mark - UICollectionView Datasource
// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [label_array count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"CollectionCell";
    CustomCollectionViewCell* cell;
    
    cell = (CustomCollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];

    cell.collectionLabel.text = [NSString stringWithFormat:@"%@", [label_array objectAtIndex:indexPath.row]];
    return cell;
    
  /*
    static NSString *simpleTableIdentifier = @"CollectionCell";
    
    
    
    CustomCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    cell.collectionLabel.text = [label_array objectAtIndex:indexPath.row];
    return cell;*/
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Clicked %d", indexPath.row);
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(150, 150);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.sdsadsdsad
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
