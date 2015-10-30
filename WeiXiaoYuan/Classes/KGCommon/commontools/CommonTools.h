//
//  CommonTools.h
//  kugou
//
//  Created by Yunsong on 11-7-4.
//  Copyright 2011年 kugou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "mach/mach.h"
#import "KGFileMgrHelper.h"
#import "KGFileMgrDefs.h"

extern NSString *const kChinaUnicomProductKey;

@class SongInfo;
@class MusicInfo;

// 工具函数
@interface KGCommonTools : NSObject
+ (natural_t)getFreeMemory;

+ (NSString *) doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(CCOperation)encryptOrDecrypt;
+ (NSString *) encryptStr:(NSString *) str;
+ (NSString *) decryptStr:(NSString *) str;


#pragma mark Based64
+ (NSString *) encodeBase64WithString:(NSString *)strData;
+ (NSString *) encodeBase64WithData:(NSData *)objData;
+ (NSData *) decodeBase64WithString:(NSString *)strBase64;

//格式图片
+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;
+ (UIImage*)ImageFormat:(UIImage*)image;

+ (NSString*) md5ToString: (NSData*)md5;
+ (NSData*) stringToMd5: (NSString*)strMd5;
+ (NSString*) stringToMd5String:(NSString*) value;

// LABEL中多行文字置顶
+ (void) alignLabelWithTop: (UILabel*)label;

// 网络是否可用
+ (BOOL) connectedToNetwork; 

// 是否使用wifi
+ (BOOL) isUseWifi;

// 是否为国内用户
// 返回1为境内，2为境外，0为服务失败
+ (int) isChinaUser;

// 通过运营商判断是否国内用户
+ (BOOL)isChinaFromMobile;

// 返回带边框按钮
+ (UIButton*) frameButton: (int)width btnHeight: (int)height;

// 返回"10:01"，secCount以秒为单位
+ (NSString *)timeFormatString: (int) secCount;

// 返回是否为宽带网络
+ (BOOL) isWideNetWorkd;

// 取歌曲id3信息
+ (NSMutableDictionary*) id3Info: (NSString*) fullPathName;

// ipod文件是否存在
+ (BOOL) isIpodMusicExist: (NSString*) musicFullPathName;

//方法功能：判断是否是支持的媒体文件格式
+(BOOL)boolMediaFile:(NSString *)file;

//返回播放状态的图片
+(UIImageView*)PlayStat;
+(UIImageView*)Getlplaystat;

+(int) headerOrignY;
+(int)barOrignY;

//判断系统是否大于等于7
+(BOOL) isOSVersionGreaterThan_7;

// 判断系统是否为7.x
+ (BOOL) isOSVersion_7;

// 判断系统是否为5.x
+ (BOOL) isOSVersion_5;

// 判断系统是否为5.0.x
+ (BOOL) isOSVersion_5_0;

// 判断系统是否为6.x
+ (BOOL) isOSVersion_6;

// 判断系统是否为4.2
+ (BOOL) isOSVersion_4_2;

// 判断系统是否为4.1
+ (BOOL) isOSVersion_4_1;

// 判断系统是否为4
+ (BOOL) isOSVersion_4;

// 判断机型是否为3GS
+ (BOOL) isOSVersion_3GS;


+(int) SystemVersin;

//判断机型是否iPhone
+(BOOL)isDeviceIphone;

//检测是否联通卡
+(BOOL)checkChinaUnicom;

//检测是否有卡
+(BOOL)checkSimCard;

//检测是否中国版机器
+(BOOL)checkChinaPhone;

//检测是否是中国移动
+(BOOL)checkChinaMobile;

+(NSString *)createRandomNum:(int)count;
+(NSString *)createUnicomUnikey;

+ (NSString*)unincomHeaderValue;

+ (NSString*)unicomUserAgent;

+(NSString*)telecomUserAgent;

+ (NSString *)proxyHost;
+ (NSInteger)proxyPort;
+ (NSString *)proxyHeader;
+ (NSString *)proxyValue;

// 把文件（或文件夹）设置为不iCloud属性（避免在空间不足时被系统删除, 5.0.1有效）
+ (BOOL) addSkipBackupAttributeToItemAtURL: (NSURL*)url;
+ (BOOL) addSkipBackupAttributeToItemAtPath: (NSString*)path;

// 是否静音状态
+ (BOOL) isUserQuiet;

// 转MusicInfo为SongInfo
// 由外界释放
+ (SongInfo*) createSongInfoFromMusicInfo: (MusicInfo*)musicInfo;

// 转ManageAllMusic为SongInfo
// 由外界释放
// 此方法已放进SongInfo里
//+ (SongInfo*) createSongInfoFromManageAllMusic: (ManageAllMusic*)manageAllMusic;

// 复制一个新的SongInfo
// 由外界释放
+ (SongInfo*) cloneSongInfo: (SongInfo*)si;

// 根据文件hash返回SongInfo，只支持mp3
// 由外界释放
+ (SongInfo*) createSongInfoFromFileHash: (NSString*)fileHash fileName: (NSString*)fileName;

// 在本地文件存在时，播放本地文件
// 没有本地文件时返回NO
+ (BOOL) playLocalSongWhenExist: (SongInfo*)targetSong;

// 返回本地对应歌曲，外界释放
+ (SongInfo *)localSongInfoForHash:(NSString *)strHash;


// 返回ktv下载完成伴奏目录
+ (NSString *)cacheKTVAccompanyDir;

// 返回缓存路径
+ (NSString *)cacheFilePath:(NSString *)fileName;
+ (NSString *)cacheFileDir;

// 返回离线下载歌曲的目标路径
+ (NSString*) offlineFilePath:(NSString *)fileName;
+ (NSString*) offlineFileDir;
// 返回离线下载歌曲的临时路径
+ (NSString*) offlineTempFilePath:(NSString *)fileName;


// 返回下载歌曲的目标目录
+ (NSString*) targetFilePath: (NSString*)fileName;
+ (NSString*) targetFileDir;
// 返回下载歌曲的临时目录
+ (NSString*) tempFilePath: (NSString*)fileName;

// 返回下载mv的目标目录
+ (NSString*) MVFilePath:(NSString *)fileHash;
+ (NSString*) MVFileDir;
// 返回下载mv的临时目录
+ (NSString*) tempMVPath:(NSString *)fileHash;

// 根据SongInfo返回对应的文件名，由外界释放返回值
+ (NSString*) createFileNameFromSongInfo: (SongInfo*)songInfo;

//填充记忆播放队列
+(void)addRemmenberPlayList:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs;

//文件名数组排序 不分中英文
+(NSMutableArray *)sortStringArrayWithOnlyABC:(NSArray*)arry;
//文件名数组排序
+(NSMutableArray *)sortStringArray:(NSArray*)arry;

//数组（根据名字）排序
+(NSMutableArray *)sortArray:(NSArray *)arry and:(NSString *)keyString;

//数组（根据名字）排序,获取字母索引
+(NSMutableArray *)sortArrayAndForIndex:(NSArray *)arry and:(NSString *)keyString;

//编辑列表数组（根据名字）排序
+(NSArray *)sortEditListArray:(NSArray *)arry and:(NSString *)keyString;

//编辑列表本地数组（根据名字）排序
+(NSArray *)sortEditLocalListArray:(NSArray *)arry and:(NSString *)keyString;

//对于array里面有同样名字的标准和流畅音质歌曲，对musicTitle加序号
+(NSArray *)filterLocalSameSongNameInArray:(NSArray *)array;

// 比较两个hash字符串是否相等（忽略大小写）
+ (BOOL)isHashEqual: (NSString*)leftHash toOther: (NSString*)rightHash;

// 由十六进制字符串转化成颜色值
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert withAlpha:(float)alph ;

// 通知显示当前歌曲的标题
+ (void) notifyShowCurrentSongTitle: (NSString*)songTitle;

// messageBox
+ (void) msgBox: (NSString*) info;
+ (void)tipMsgBox:(NSString*)info title:(NSString*)title;

// 根据日期返回年月日等
// {年、月、日、时、分、秒}
// 外界释放返回值
+ (NSArray*) tokenDate: (NSDate*)date; 

// 从皮肤取歌词前景色
+ (NSString*) lyricFrontColorFromSkin;

// 从皮肤取歌词背景色
+ (NSString*) lyricBackColorFromSkin;

// 返回songInfo的真实fileURL
+ (NSString *)realFileURL:(SongInfo *)songInfo;

// 动画地移动特定view
// endX为终点时view的center.x值
+ (void)moveViewWithAnimations:(int)endX endY:(int)endY 
                          view:(UIView *)view;

// 动画地移动特定view
// endX为终点时view的x坐标值
+ (void)moveViewWithAnimationsOrigin:(int)endX endY:(int)endY 
                          view:(UIView *)view;


+ (void)moveViewWithAnimationsOrigin:(int)endX endY:(int)endY 
                                view:(UIView *)view time:(float)time;

+ (void)moveViewWithAnimationsOrigin:(CGRect)rect view:(UIView *)view time:(float)time;

+(NSMutableArray *)musicis:(int)ower Inmusics:(NSArray*)allmusic;

//// 播放乐库的歌曲
//+ (void)playNetListSong:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs;
//
//// 播放网络收藏的歌曲
//+ (void)playCloudSong:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs;
//
//// 播放本地的歌曲
//+ (void)playLocalSong:(int)row song:(SongInfo *)playSong allSongs:(NSArray *)songs;

// 稍后播放
+ (void)playLater:(SongInfo *)songInfo;
+ (void)playQueueLater:(NSArray *)selCellInfos;
/**
 *  设置歌曲的来源路径
 *
 *  @param songArray SongInfo NSArray
 */
//+ (void) setSongPagePath:(NSArray*) songArray;
//// 立即播放
//+ (void)playQueueAtOnce:(NSArray *)selCellInfos;

// 下载
+ (void)cacheSongs:(NSArray *)selCellInfos;

// 判断是否为正在播放的歌曲
+ (BOOL)isPlayingSong:(id)info;

// CloudListFile集合转SongInfo集合，由外界释放
+ (NSArray *)createSongsFromCloudListFile:(NSArray *)listFiles;

// 删除本地songInfo
+ (void)deleteLocalSongInfo:(SongInfo *)songInfo;

// 删除本地歌曲
+ (BOOL)deleteLocalSongInfoByPath:(NSString *)strPath;

// 批量删除本地songInfo
+ (void)deleteLocalSongInfoArray:(NSArray *)songs;

// 返回strSource中strKey的range集合
+ (NSArray *)rangesForKey:(NSString *)strSource key:(NSString *)strKey;

// 显示提示
+ (void)showTip:(NSString *)tipInfo showTime:(int)showSec;


+(UIImage *) screenImage:(UIView *)view rect:(CGRect)rect ;

+(UIImage *) windowImage:(UIWindow *)window rect:(CGRect)rect;

//没有选择列表提示框
+ (void)showChooseNothingAlert:(int )alertType;

// 根据url转为ip
int getIPbyDomain(const char* domain, char* ip);
+(int)getIpByDomainOC:(const char*)domain ip:(char*)ip;

// 返回歌曲的实际路径(在覆盖安装后安装目录会被修改)
+ (NSString *)realLocalSongPath:(NSString *)srcPath;

// 之前版本的保存路径
+ (NSString *)perVersionLocalSongPath:(NSString *)srcPath;

// 共享文件路径
+ (NSString*)shareMusicPathName: (NSString*)srcPathName;

// 当前使用的内存量
+ (vm_size_t)usedMemory;

// 当前可用内存量
+ (vm_size_t)freeMemory;

////1为经典蓝色 2为粉色心情 3为黑色心情
//+(int )getCurrentSkin;

// 取本地ip
// outIP为返回ip
// 返回0为成功
+ (int)localIP:(char*)outIP;

// 用户id
+ (int)userID;

// 当前时间
+ (NSString*)curDateTime;

//字符串表示的当前时间（精确到毫秒）
+(NSString*)curDateTimeMSec;

//字符串表示的当前时间（精确到天）
+(NSString*)curDateByDay;

// 全屏头像下载地址des解密
+ (NSString *)fullImageURLDecrypt:(NSString *)srcURL;
+ (NSString *)fullImageURLEncrypt:(NSString *)srcURL;

// 登录或注册协议加密
+ (NSData *)userInfoDecrypt:(NSData *)srcInfo;
+ (NSData *)userInfoEncrypt:(NSString *)srcInfo;
+ (NSData *)userInfoEncrypt2:(NSString *)srcInfo;
+ (NSData *)userInfoEncryptNew:(NSString *)srcInfo;

// des加解密
+ (NSString *)desEncrypt:(NSString *)srcContent key:(Byte *)key keySize:(int)keySize vector:(Byte *)iv;
+ (NSString *)desDecrypt:(NSData *)srcContent key:(Byte *)key keySize:(int)keySize vector:(Byte *)iv;

// 获取文件创建时间
+ (NSDate *)fileModifiedTime:(NSString *)filePathName;

// 时间字符串转date
+ (NSDate *)dateFromString:(NSString *)strDate;

//将nsnumber转化为nsstring
+(NSString *)changeNumberToString:(NSNumber *)str;

// 是否有HD标识
+ (BOOL)isHDFromSongPathName:(NSString *)songPathName;

// 本地文件是否存在（不含ipod）
+ (BOOL)isLocalFileExsit:(NSString *)songPath;

// 判断是否越狱
+ (BOOL)isJailBroken;

//判断越狱机器是否有appsync插件
+(BOOL)isPerfectJailBroken;
//判断是否出现AppStore的入口
+(BOOL) isSuppertAppstorePay;
// 是否联通代理
+(BOOL)isUnicomPorxy;

//是否电信卡
+(BOOL)checkChinaTelecom;

//剩余磁盘空间
+(NSString *)freeDiskSpaceInKBytes;

//文件大小
+ (long long)fileSizeAtPath:(NSString* )filePath;
//文件夹大小
+ (long long)folderSizeAtPath:(NSString *)folderPath;

//获取文件夹大小（纯C方法，据说效率高很多）
+ (long long) _folderSizeAtPath: (const char*)folderPath;

+(NSString *)offlineMusicPathName:(NSString*)srcPathName;

+(NSString *)cacheMusicPathName:(NSString*)srcPathName;
+(NSString*)getOperator;

+ (BOOL)isLowDevice;

+ (BOOL)isLRC:(NSString *)lyrics;

+(CGSize) sizeForString:(NSString*)string font:(UIFont*)font;
@end

// 播放线程参数
@interface PlayThreadParam : NSObject
{
    NSString* fileURL;
    SongInfo *songInfo;
    BOOL bOnline;
}
@property (nonatomic, retain) NSString* fileURL;
@property (nonatomic, retain) SongInfo *songInfo;
@property BOOL bOnline;
@end

// 播放
@interface PlayOperators: NSObject
// 直接同步到主线程，不启用新的线程
+ (void) playNextOnlineFileByThread;
// 直接同步到主线程，不启用新的线程
+ (void) playFileToMainThread: (SongInfo*)songInfo isOnline: (BOOL)bOnline;

+(float)getFileValue:(int)Size;
@end

// 计算时间差的宏
#define COMPUTE_TIME_INTERVAL(OPERATOR) \
{\
NSDate* date1 = [NSDate date]; \
{OPERATOR} \
NSDate* date2 = [NSDate date]; \
DLog(@"interval: %f", [date2 timeIntervalSinceDate: date1]); \
}

