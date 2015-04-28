//
//  MMCalendarCollectionViewCell.m
//  MealReport
//
//  Created by minami on 3/5/15.
//  Copyright (c) 2015 Minami Baba. All rights reserved.
//

#import "MMCalendarCollectionViewCell.h"
#import "MMColor.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation MMCalendarCollectionViewCell
{
    NSOperationQueue *_queue;
    NSCache *_cache;
}

- (void)awakeFromNib
{
    self.layer.borderWidth = 1.0f;
    self.mealCostLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)setPost:(NSString *)imageUrl key:(NSString *)key
{
    _mealPhotoImageView.image = nil;
    [self setPhotoImage:imageUrl key:key];
    [self setNeedsLayout];
}

- (void)setPhotoImage:(NSString *)imageUrl key:(NSString *)key
{
    //Queue,Cacheを作成
    if (!_queue){
        _queue = [[NSOperationQueue alloc] init];
    }
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    
    //既に実行されているスレッドがある場合はキャンセルする
    [_queue cancelAllOperations];
    
    //既にキャッシュされている画像なら表示して終了
    UIImage* image = [_cache objectForKey:key];
    if(image){
        [_mealPhotoImageView setImage:image];
        return;
    }
    
    //まだキャッシュされていない画像は別スレッドで取得する
    _indicator.hidden = NO;
    [_indicator startAnimating];
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    __weak NSBlockOperation *weakOperation = operation; // 循環参照を避ける
    __weak MMCalendarCollectionViewCell* weakSelf = self;
    [operation addExecutionBlock:^{
        
        NSURL *url = [NSURL URLWithString:imageUrl];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:url resultBlock:^(ALAsset *asset) {
            
            UIImage *image;
            if ([imageUrl isEqualToString:@"default"]) {
                self.mealPhotoImageView.contentMode = UIViewContentModeScaleAspectFit;
                switch (self.visibleTime) {
                    case 0:
                        image = [UIImage imageNamed:@"iconRed.png"];
                        break;
                    case 1:
                        image = [UIImage imageNamed:@"iconYellow.png"];
                        break;
                    case 2:
                        image = [UIImage imageNamed:@"iconBlue.png"];
                        break;
                    default:
                        break;
                }
                
            } else {
                self.mealPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                Byte *buffer = (Byte*)malloc((unsigned)rep.size);
                NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:(unsigned)rep.size error:nil];
                NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES]; //これが必要なデータ
                image = [UIImage imageWithData:data];
            }

            [_cache setObject:image forKey:key];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                //Queueがキャンセルされていたら画像を設定せずに終了
                if (weakOperation.isCancelled) return;
                
                //UIImageViewに画像をセット
                [_mealPhotoImageView setImage:image];
                [_indicator stopAnimating];
                _indicator.hidden = YES;
                
                [weakSelf setNeedsLayout];
            }];

        } failureBlock:^(NSError *error) {
        }];

    }];
    
    [_queue addOperation:operation];

}

@end
