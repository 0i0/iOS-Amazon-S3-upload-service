iOS-Amazon-S3-upload-service
============================

A class that wraps amazon ios sdk with callbacks and progress

The amzon sdk is not icluded here, I assume you have it

there is no mime type detection, you'll need an external lib for this

If you still want to use it

include like this
```objC
#import "CLUploadService.h"
#import "AmazonS3Client.h"
```

Use it like this
```objC
CLUploadService *uploadService = [[CLUploadService alloc]init];
    
[uploadService  uploadFileWithData:imgData 
                          fileName:fileName 
                          progress:^(NSInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    CGFloat precent = (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100);
    NSLog(@"Uploaded:%f%%", precent);
} success:^(id responseObject) {
    NSLog(@"Upload Completed");
} failure:^(NSError *error) {
    NSLog(@"Error: %@", error);
}];
```
