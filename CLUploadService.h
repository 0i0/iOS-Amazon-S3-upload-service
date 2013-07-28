//
//  CLUploadService.h
//  iOSClishade
//
//  Created by 0i0 on 7/25/13.
//  Copyright (c) 2013 0i0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AmazonS3Client.h"

typedef void(^ProgressCallback)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);
typedef void(^SuccessCallback)(id responseObject);
typedef void(^FailureCallback)(NSError *error);

@interface CLUploadService : NSOperation<AmazonServiceRequestDelegate> {
@private BOOL        _doneUploadingToS3;
}

-(void)uploadFileWithData:(NSData *)data
                 fileName:(NSString *)fileName
                 progress:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;
                  
@end