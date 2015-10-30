//
//  fileengine.h
//  kugou
//
//  Created by apple on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface fileengine : NSObject {

}

+(void)InitPath;

+(NSString*)themeBackImageDir;
+(NSString*)splashPath;

+(NSString*)GetDocumentPath;

+ (NSString*) tempDirPath;

+ (NSString*) libraryCachesPath;

+(NSString *)getSkinImagePath;

+ (NSString*) lyricPath;
+ (NSString*) imagePath;
+ (NSString*) netResourcePath;
+ (NSString*) configPath;


+(void)CreateDir:(NSString*)szPath;

+(int)IsFileExist:(NSString*)name;

+ (BOOL) isFileExistByFullPath: (NSString*)filePath;

+(NSString *)get_filename:(NSString *)name;

+(BOOL)DeleteFileAtPath:(NSString*)szPath;

+(int)EnumArchiveFileToObjs:(NSString*)szPath array:(NSMutableArray**)objs;

+(int)IsDirEmpty:(NSString*)szPath files:(NSArray**)arFile;

+(BOOL)CopyTo:(NSString*)szSrcpath target:(NSString*)szTarpath;


+(void)WriteArrayFileForText:(NSMutableArray *)fileArray with:(NSString*)fileName;

+(void)WriteFileForData:(NSData* )file with:(NSString *)fileName;

+(NSData*)ReadFileForData:(NSString *)fileName;

+(NSMutableArray *)ReadArrayFileForText:(NSString *)fileName;

+ (void)writeFileToLyricPath: (NSData*)data with: (NSString*)fileName;
+ (NSData*)readDataFromLyricPath: (NSString*)fileName;

+ (BOOL)writeFileToImagePath: (NSData*)data with: (NSString*)fileName;
+(NSString*)pathFromImagePath: (NSString*)fileName;
+ (NSData*)readDataFromImagePath: (NSString*)fileName;

+ (void)writeFileToNetResourcePath: (NSData*)data with: (NSString*)fileName;
+ (NSData*)readDataFromNetResourcePath: (NSString*)fileName;

+(void)writeFileToBannerImagePath:(NSData*)data with:(NSString*)fileName;
+(NSData*)readDataFromBannerImagePath:(NSString*)fileName;
+(BOOL)isBannerFileExist:(NSString *)fileName;
+(void)removeOutdateBannerimages:(NSArray*)arrNotToMoved;

+(void)writeFileToKgImagePath:(NSData*)data with:(NSString*)fileName;
+(NSData*)readDataFromKgImagePath:(NSString*)fileName;
+(BOOL)isKgImageFileExist:(NSString*)fileName;

@end
