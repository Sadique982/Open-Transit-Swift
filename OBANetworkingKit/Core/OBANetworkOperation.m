//
//  OBANetworkOperation.m
//  OBANetworkingKit
//
//  Created by Aaron Brethorst on 10/2/18.
//  Copyright © 2018 OneBusAway. All rights reserved.
//

#import <OBANetworkingKit/OBANetworkOperation.h>
#import <OBANetworkingKit/OBAOperation+Internal.h>

@interface OBANetworkOperation ()
@property(nonatomic,copy,readwrite) NSURLRequest *request;
@property(nonatomic,strong,nullable,readwrite) NSData *data;
@property(nonatomic,copy,nullable,readwrite) NSError *error;
@property(nonatomic,strong,nullable,readwrite) NSHTTPURLResponse *response;
@property(nonatomic,strong,nullable) NSURLSessionDataTask *dataTask;
@end

@implementation OBANetworkOperation

- (instancetype)initWithURLRequest:(NSURLRequest *)request {
    self = [super init];

    if (self) {
        _request = [request copy];
        self.name = _request.URL.absoluteString;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL*)URL {
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    return [self initWithURLRequest:request];
}

- (void)start {
    [super start];

    NSURLSession *session = [NSURLSession sharedSession];

    __weak __typeof__(self) weakSelf = self;
    self.dataTask = [session dataTaskWithRequest:[self request] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __typeof__(self) self = weakSelf;

        if (self.isCancelled) {
            return;
        }

        [self setData:data response:(NSHTTPURLResponse*)response error:error];

        [self finish];
    }];

    [self.dataTask resume];
}

- (void)setData:(NSData*)data response:(NSHTTPURLResponse*)response error:(NSError*)error {
    self.data = data;
    self.response = response;
    self.error = error;
}

#pragma mark - Cancel

- (void)cancel {
    [super cancel];
    [self.dataTask cancel];
    [self finish];
}

@end
