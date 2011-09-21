//
//  HttpUploader.h
//  record
//
//  Created by 振江 张 on 11-9-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUploader : NSObject{
    NSURL *serverURL;
    NSString *filePath;
    NSString *remoteFile;
    NSData *fileData;
    id delegate;
    SEL doneSelector;
    SEL errorSelector;
    SEL progressSelector;
    
    BOOL uploadDidSucceed;
    NSInteger totalBytesWritten ,totalBytesExpectedToWrite;
}

@property (nonatomic) IBOutlet NSInteger totalBytesWritten;
@property (nonatomic) IBOutlet NSInteger totalBytesExpectedToWrite;

-   (id)initWithURL: (NSURL *)serverURL
           filePath: (NSData *)filePath
         remoteFile: (NSString *)remoteFile
           delegate: (id)delegate
       doneSelector: (SEL)doneSelector
      errorSelector: (SEL)errorSelector
   progressSelector: (SEL)progressSelector;

-  (id)initWithData: (NSURL *)serverURL
           fileData: (NSString *)fileData
         remoteFile: (NSString *)remoteFile
           delegate: (id)delegate
       doneSelector: (SEL)doneSelector
      errorSelector: (SEL)errorSelector
   progressSelector: (SEL)progressSelector;


-   (NSString *)filePath;
@end
