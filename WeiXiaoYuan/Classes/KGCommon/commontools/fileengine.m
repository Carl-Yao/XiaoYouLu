//
//  fileengine.m
//  kugou
//
//  Created by apple on 11-5-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "fileengine.h"
#import "CommonTools.h"
//#import "SkinManager.h"
#import "KGFileMgrHelper.h"
#import "KGFileMgrDefs.h"

static NSString* s_szDocument = nil;

static NSString* s_szTemp;

static NSString* s_libraryCaches;
static NSString* s_lyric_path;
static NSString* s_image_path;
static NSString* s_netResourc_path;
static NSString* s_config_path;

#define LYRIC_PATH  @"kgLyric"
#define IMAGE_PATH  @"kgImage"

@implementation fileengine


+(void)InitPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (s_szDocument==nil) {
        NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [pathsArray objectAtIndex:0];
        
        s_szDocument= [[path stringByAppendingString:@"/"] retain];//[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]retain];
    }
    
	s_szTemp=[[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]retain];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: s_szTemp];
    
    s_libraryCaches = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]retain];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: s_libraryCaches];
    
    s_lyric_path =[[s_szDocument stringByAppendingString:@"Caches/kgLyric/"] retain];// [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgLyric"] retain];
    s_image_path =[[s_szDocument stringByAppendingString:@"Caches/kgImage/"] retain];// [[NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/Caches/kgImage/"]retain];
    [fileManager createDirectoryAtPath:s_image_path withIntermediateDirectories:YES attributes:Nil error:nil];
    s_netResourc_path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/kgNetResource"]retain];
    s_config_path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/kgConfig"]retain];
    
    
    [fileengine CreateDir: s_lyric_path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: s_lyric_path];
    
    [fileengine CreateDir: s_image_path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: s_image_path];
    
    [fileengine CreateDir: s_netResourc_path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: s_netResourc_path];
    
    [fileengine CreateDir: s_config_path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: s_netResourc_path];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Caches"];
    [fileengine CreateDir: path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: path];
    
    path = s_lyric_path;//[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Caches/kgLyric"];
    [fileengine CreateDir: path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: path];
    
    path = s_image_path;//[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Caches/kgImage"];
    [fileengine CreateDir: path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: path];
    
    path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Caches/kgBannerImage"];
    [fileengine CreateDir: path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: path];
    
    path = [fileengine splashPath];
    [fileengine CreateDir: path];
    [KGCommonTools addSkipBackupAttributeToItemAtPath: path];
}

+(NSString*)themeBackImageDir
{
    static NSString *dir = nil;
    if (dir == nil) {
        dir = [[[fileengine GetDocumentPath] stringByAppendingString:@"themes/backImages/"] retain];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ( [fileManager fileExistsAtPath:dir isDirectory:nil]==NO) {
            [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            [KGCommonTools addSkipBackupAttributeToItemAtPath: dir];
        }
    }
    return dir;
}
+(NSString*)splashPath
{
    //启动前就要用的到路径，不能改为用 s_szDocument
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [pathsArray objectAtIndex:0];
    NSString *patchDir = [documentPath stringByAppendingString:@"/splash4/"];
    return patchDir;
}
+(NSString*)GetDocumentPath
{
    if (s_szDocument==nil) {
//        s_szDocument=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"]retain];
        NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [pathsArray objectAtIndex:0];
        s_szDocument = [[path stringByAppendingString:@"/"] retain];
    }
	return s_szDocument;
}

+(NSString *)getSkinImagePath
{
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SkinImage/"];
    [fileengine CreateDir: path];
    return path;
}

+ (NSString*) tempDirPath
{
    return s_szTemp;
}

+ (NSString*) libraryCachesPath
{
    return s_libraryCaches;
}

+ (NSString*) lyricPath
{
    return s_lyric_path;
}

+ (NSString*) imagePath
{
    return s_image_path;
}

+ (NSString*) netResourcePath
{
    return s_netResourc_path;
}

+ (NSString*) configPath
{
    //return s_config_path;
    return s_szDocument;
}

+(void)CreateDir:(NSString*)szPath
{
	[[NSFileManager defaultManager] createDirectoryAtPath:szPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    [KGCommonTools addSkipBackupAttributeToItemAtPath: szPath];
}

+(int)IsDirEmpty:(NSString*)szPath files:(NSArray**)arFile
{
	NSArray* arList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:szPath error:nil];
	if(arFile!=nil)
		(*arFile)=arList;
	return arList.count;
}

+(NSString *)get_filename:(NSString *)name
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:name];
}

+(int)IsFileExist:(NSString*)name
{  
	
	NSFileManager *file_manager = [NSFileManager defaultManager];
	return [file_manager fileExistsAtPath:[self get_filename:name]];
}

+ (BOOL) isFileExistByFullPath: (NSString*)filePath
{
    BOOL isexist;
    NSFileManager *file_manager = [NSFileManager defaultManager];
	isexist = [file_manager fileExistsAtPath: filePath];
    return isexist;
}

+(BOOL)DeleteFileAtPath:(NSString*)szPath
{
    FM_QFLog1(@"delete:%@\r\n%@", szPath, [KGFileMgrHelper getCallStack]);

    NSError * error;
    BOOL deleteResult = [[NSFileManager defaultManager] removeItemAtPath:szPath error:&error];
	return deleteResult;
}

+(BOOL)CopyTo:(NSString*)szSrcpath target:(NSString*)szTarpath
{
	return [[NSFileManager defaultManager] copyItemAtPath:szSrcpath toPath:szTarpath error:nil];
}
+(void)WriteArrayFileForText:(NSMutableArray *)fileArray with:(NSString*)fileName{
    
    NSString *filePath=[[self GetDocumentPath] stringByAppendingPathComponent:fileName];
	[fileArray writeToFile:filePath atomically:YES];
}

+(void)WriteFileForData:(NSData* )file with:(NSString *)fileName{
	NSString *filePath=[[self GetDocumentPath] stringByAppendingPathComponent:fileName];
	[file writeToFile:filePath atomically:YES];
}

+(NSData*)ReadFileForData:(NSString *)fileName{

	NSString *filePath=[[self GetDocumentPath] stringByAppendingPathComponent:fileName];
	NSData *fileArray=[NSData dataWithContentsOfFile:filePath];   
	return fileArray;
}

+ (void)writeFileToLyricPath: (NSData*)data with: (NSString*)fileName
{
//    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgLyric/%@", fileName];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self lyricPath],fileName];
    DLog(@"wirte lyric to file: %@", filePath);
    BOOL isDel = [fileengine DeleteFileAtPath:filePath];
	BOOL isSave = [data writeToFile:filePath atomically:YES];
}

+ (NSData*)readDataFromLyricPath: (NSString*)fileName
{
//    NSString *filePath=[[self lyricPath] stringByAppendingPathComponent:fileName];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self lyricPath],fileName];
	NSData *fileArray=[NSData dataWithContentsOfFile:filePath];
	return fileArray;
}

+ (BOOL)writeFileToImagePath: (NSData*)data with: (NSString*)fileName
{
//    NSString *filePath =[[self imagePath] stringByAppendingPathComponent:fileName.lowercaseString];// [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgImage/%@", fileName.lowercaseString];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self imagePath],fileName.lowercaseString];
    DLog(@"wirte image to file: %@", filePath);
//	BOOL iswrite = [data writeToFile:filePath atomically:YES];
    BOOL iswrite = [data writeToFile:filePath options:NSDataWritingFileProtectionNone error:nil];
    if (iswrite==NO) {
        DLog(@"wirte image Error");
    }
    return iswrite;
}

+(NSString*)pathFromImagePath: (NSString*)fileName
{
//    NSString *filePath=[[self imagePath] stringByAppendingPathComponent:fileName];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self imagePath],fileName.lowercaseString];
    BOOL bEixst = [fileengine isFileExistByFullPath: filePath];
    if (!bEixst)
    {
        filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgImage/%@", fileName];
    }
    bEixst = [fileengine isFileExistByFullPath: filePath];
    if (!bEixst)
    {
        filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgImage/%@", fileName.lowercaseString];
    }
    bEixst = [fileengine isFileExistByFullPath: filePath];
    if (!bEixst) {
        filePath = @"";
    }
    
    NSDictionary *tDict = [NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey];
    [[NSFileManager defaultManager] setAttributes:tDict ofItemAtPath:filePath error:nil];
    return filePath;
}
+ (NSData*)readDataFromImagePath: (NSString*)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self imagePath],fileName.lowercaseString];
    BOOL bEixst = [fileengine isFileExistByFullPath: filePath];
    if (!bEixst)
    {
        filePath = [fileengine pathFromImagePath:fileName];
    }
	NSData *fileArray=[NSData dataWithContentsOfFile:filePath];   
	return fileArray;
}

+(void)writeFileToBannerImagePath:(NSData*)data with:(NSString*)fileName
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgBannerImage/%@", fileName];
    DLog(@"wirte image to file: %@", filePath);
    [data writeToFile:filePath atomically:YES];
}

+(NSData*)readDataFromBannerImagePath:(NSString*)fileName
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgBannerImage/%@", fileName];
    BOOL isExist = [fileengine isFileExistByFullPath: filePath];
    if (isExist == YES) 
    {
        NSData *fileArray=[NSData dataWithContentsOfFile:filePath];
        
        return fileArray;
    }
    
    return nil;
}

+(BOOL)isBannerFileExist:(NSString *)fileName
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgBannerImage/%@", fileName];
    
    return [fileengine isFileExistByFullPath:filePath];
}

+(BOOL)isKgImageFileExist:(NSString*)fileName
{
//    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgImage/%@", fileName];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[self imagePath],fileName.lowercaseString];
    return [fileengine isFileExistByFullPath:filePath];

}

+(void)writeFileToKgImagePath:(NSData*)data with:(NSString*)fileName
{
//    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgImage/%@", fileName];
//    DLog(@"wirte image to file: %@", filePath);
//    [data writeToFile:filePath atomically:YES];
    [fileengine writeFileToImagePath:data with:fileName];
}

+(NSData*)readDataFromKgImagePath:(NSString*)fileName
{
    return [fileengine readDataFromImagePath:fileName];
//    NSString *filePath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgImage/%@", fileName];
//    BOOL isExist = [fileengine isFileExistByFullPath: filePath];
//    if (isExist == YES) 
//    {
//        NSData *fileArray=[NSData dataWithContentsOfFile:filePath];
//        
//        return fileArray;
//    }
//    
//    return nil;
}

+(void)removeOutdateBannerimages:(NSArray*)arrNotToMoved
{
    NSArray *tempArr = [arrNotToMoved retain];
    NSError *err = nil;
    NSString *categoryPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgBannerImage/"];
    NSArray *filesArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:categoryPath error:&err];
    if (filesArray == nil || [filesArray count] < 30) 
    {
        [tempArr release];
        return;
    }
    
    for (int index = 0; index < [filesArray count]; index++) 
    {
        NSString *fileName = [filesArray objectAtIndex:index];
        if (![tempArr containsObject:fileName]) 
        {
            NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/Caches/kgBannerImage/%@", fileName];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    
    [tempArr release];
}

+ (void)writeFileToNetResourcePath: (NSData*)data with: (NSString*)fileName
{
    NSString *filePath=[[self netResourcePath] stringByAppendingPathComponent:fileName];
    //DLog(@"%@",filePath);
	[data writeToFile:filePath atomically:YES];
}

+ (NSData*)readDataFromNetResourcePath: (NSString*)fileName
{
    NSString *filePath=[[self netResourcePath] stringByAppendingPathComponent:fileName];
    //DLog(@"%@",filePath);
	NSData *fileArray=[NSData dataWithContentsOfFile:filePath];   
	return fileArray;
}

+(NSMutableArray *)ReadArrayFileForText:(NSString *)fileName{
    NSString *filePath=[[self GetDocumentPath] stringByAppendingPathComponent:fileName];
	NSMutableArray *fileArray=[NSMutableArray arrayWithContentsOfFile:filePath];   
	return fileArray;
}



+(int)EnumArchiveFileToObjs:(NSString*)szPath array:(NSMutableArray**)objs
{
	NSAutoreleasePool* pool=[NSAutoreleasePool new];
	int nResult=FALSE;
	
	//	NSArray* arList=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:szPath error:nil];
	
	NSArray* arList=nil;
	
	[self IsDirEmpty:szPath files:&arList];
	
	if(arList!=nil&&arList.count>0)
	{
		nResult=TRUE;
		(*objs)=[NSMutableArray new];
		for(int i=0;i<arList.count;i++)
		{
			NSString* p=[arList objectAtIndex:i];
			//模拟器上会出现
			if(0!=[p compare:@".DS_Store"])
			{
				NSString* pp=[szPath stringByAppendingPathComponent:p];
				[(*objs) addObject:[NSKeyedUnarchiver unarchiveObjectWithFile:pp]];
			}
		}
		//#endif
	}
	[pool release];
	return nResult;
}


@end
