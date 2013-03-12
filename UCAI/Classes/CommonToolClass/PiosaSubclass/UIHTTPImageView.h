//
//  UIHTTPImageView.h
//  JingDuTianXia
//
//  Created by Piosa on 11-10-24.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface UIHTTPImageView : UIImageView {
    ASIHTTPRequest *request;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

@end
