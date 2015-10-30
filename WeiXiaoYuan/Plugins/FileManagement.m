////
////  FileManagement.m
////  WeiXiaoYuan
////
////  Created by 姚振兴 on 14/12/23.
////  Copyright (c) 2014年 Dukeland. All rights reserved.
////
//
//#import "FileManagement.h"
//
//@implementation FileManagement
//
//// get file absolutely path in the caches directory
//NSString* pathInCacheDirectory(NSString *fileName)
//{
//    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [cachePaths objectAtIndex:0];
//    return [cachePath stringByAppendingPathComponent:fileName];
//}
//
//// create directory in the caches directory
//bool createDirInCache(NSString *dirName)
//{
//    NSString *imageDir = pathInCacheDirectory(dirName);
//    BOOL isDir = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
//    bool isCreated = false;
//    if ( !(isDir == YES && existed == YES) )
//    {
//        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    return isCreated;
//}
//
//// delete directory in the caches directory
//bool deleteDirInCache(NSString *dirName)
//{
//    NSString *imageDir = pathInCacheDirectory(dirName);
//    BOOL isDir = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
//    bool isDeleted = false;
//    if ( isDir == YES && existed == YES )
//    {
//        isDeleted = [fileManager removeItemAtPath:imageDir error:nil];
//    }
//    
//    return isDeleted;
//}
//
//// save Image to the caches directory
//+(bool)saveImageToCacheDir:(NSString*)directoryPath:(UIImage*)image:(NSString*)imageName:(NSString*)imageType
//{
//    BOOL isDir = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
//    bool isSaved = false;
//    if ( isDir == NO || existed == NO )
//    {
//        createDirInCache(directoryPath);
//    }
//        if ([[imageType lowercaseString] isEqualToString:@"png"])
//        {
//            isSaved = [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
//        }
//        else if ([[imageType lowercaseString] isEqualToString:@"jpg"] || [[imageType lowercaseString] isEqualToString:@"jpeg"])
//        {
//            isSaved = [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
//        }
//        else
//        {
//            NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", imageType);
//        }
//    
//    return isSaved;
//}
//
//// load Image from caches dir to imageview
//NSData* loadImageData(NSString *directoryPath, NSString *imageName)
//{
//    BOOL isDir = NO;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
//    if ( isDir == YES && dirExisted == YES )
//    {
//        NSString *imagePath = [directoryPath stringByAppendingString : imageName];
//        BOOL fileExisted = [fileManager fileExistsAtPath:imagePath];
//        if (!fileExisted) {
//            return NULL;
//        }
//        NSData *imageData = [NSData dataWithContentsOfFile : imagePath];
//        return imageData;
//    }
//    else
//    {
//        return NULL;
//    }
//}
//
//
//@end
