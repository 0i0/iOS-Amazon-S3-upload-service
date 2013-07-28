//
//  CLUploadService.m
//
//  Created by 0i0 on 7/25/13.
//  Copyright (c) 2013 0i0. All rights reserved.
//

#import "CLUploadService.h"
#define kAWSAccessKeyID @"YOUR_KEY_GOES_HERE"
#define kAWSsecret @"YOUR_SECRET_GOES_HERE"
#define kAWSBucket @"YOUR_Bucket_GOES_HERE"
#define kAWSPath @"YOUR_PATH_GOES_HERE"

@implementation CLUploadService{    
    ProgressCallback progress;
    SuccessCallback success;
    FailureCallback failure;
}

-(void)uploadFileWithData:(NSData *)data
                 fileName:(NSString *)fileName
                 progress:(void (^)(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressCallback
                  success:(void (^)(id responseObject))successCallback
                  failure:(void (^)(NSError *error))failureCallback
{

    progress = progressCallback;
    success = successCallback;
    failure = failureCallback;
    
    _doneUploadingToS3 = NO;
    
    
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kAWSAccessKeyID withSecretKey:kAWSsecret];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
    NSString *pathToFile =  [NSString stringWithFormat:@"%@%@",kAWSPath,fileName];
    // Upload image data.  Remember to set the content type.
    S3PutObjectRequest *por = nil;
        por = [[S3PutObjectRequest alloc] initWithKey:pathToFile inBucket:kAWSBucket];
        por.cannedACL = [S3CannedACL publicRead];
        @try {
            
            por.delegate = self;
            por.contentType = @"image/jpeg";
            por.data = data;
            
            [s3Client putObject:por];
        }
        @catch (AmazonClientException *exception) {
            _doneUploadingToS3 = YES;
        }
        
        do {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        } while (!_doneUploadingToS3);
        
        por.delegate = nil;
    });

}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    _doneUploadingToS3 = YES;
    success(response);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    _doneUploadingToS3 = YES;
    failure(error);
}

-(void)request:(AmazonServiceRequest *)request didFailWithServiceException:(NSException *)exception
{
    _doneUploadingToS3 = YES;
     failure(nil);
}

- (void) request:(AmazonServiceRequest *)request didSendData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    // Do what you want
    progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    //NSLog(@"%f%% Uploaded", (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100));
}

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    // Do what you want
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    // Do what you want
}
@end
