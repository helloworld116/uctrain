//
//  UIHTTPImageView.m
//  JingDuTianXia
//
//  Created by Piosa on 11-10-24.
//  Copyright 2011 __JingDuTianXia__. All rights reserved.
//

#import "UIHTTPImageView.h"


#import "UIHTTPImageView.h"

@implementation UIHTTPImageView        

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [request setDelegate:nil];
    [request cancel];
    [request release];
	
    request = [[ASIHTTPRequest requestWithURL:url] retain];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
	
    if (placeholder)
        self.image = placeholder;
	
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)dealloc {
    [request setDelegate:nil];
    [request cancel];
    [request release];
    [super dealloc];
}

- (void)requestFinished:(ASIHTTPRequest *)req
{
	
    if (request.responseStatusCode != 200)
        return;
	
    self.image = [UIImage imageWithData:request.responseData];
}

@end
