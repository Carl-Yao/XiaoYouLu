//
//  allKGItem.h
//  kugou
//
//  Created by Yunsong on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "KGFont.h"

typedef enum
{
	Animation_TYPE_NONE = 0,   //无按键
	Animation_TYPE_TOP,       //返回
    Animation_TYPE_DOWN,        //正在播放
    Animation_TYPE_LEFT,           //取消
    Animation_TYPE_RIGHT,          //完成
    Animation_TYPE_CENTER
}AnimationType;

#define MYKUGOUVIEWID   1000001
#define NEWUSERLOGINVIEWID  1000003  //登录
#define NEWUSERREGISTERVIEWID  1000004  //注册
#define NEWUSERMESSAGE  100002   // 个人信息
#define CPSENDSONGSINGVIEW 1000005 //电脑传歌
#define USERFEEDBACKVIEW 1000006 //用户反馈
#define EDICTIONVIEWID 10000017 //版本信息
#define USERHELPVIEWID 10000015 //用户帮助
#define ADDALBUMLISTVIEWID 10000020 //添加专辑
#define ONELISTENANDONECASHVIEWID 10000018 //边听边存
#define SETINTRODUCTIONVIEID 10000016 //新功能介绍
#define USERCHANGEBGIMAGEVIEWID 10000014 //用户换肤
#define SINGEROWNVIEWID 1000009 //歌手个人主页
#define SINGERLISTSVIEWID 1000008 //歌手列表
#define MUSICSORTVIEWID 10000010 //歌曲分类主页
#define SINGERDETAIMGVIEWID 10000088 //歌手详细信息
#define NETMUSICLISTSVIEWID 10000011 //网络歌曲列表
#define SINGERSEARCHVIEWID 10000012 //歌手搜索
#define YUEKUSEARCHVIEWID 10000019 //乐库搜索
#define SEARCHRESULTSVIEWID 10000013 //搜索结果页面
#define PARATERSETVIEWITEMVIEW 1000007 //定时或者音质设置
#define GOODAPPRECOMMENDINDEXPAGE 1000018 //精品推荐主页
#define ONLINE_SEARCH 20000019 // 在线搜索
#define YUKUVIEWID      200000
#define DIANTAIVIEWID   300000
#define SETINGVIEWID    400000
#define weibologin      100001
#define NEWSINGERINDEXVIEW 20000022
#define NEWSINGERLISTSVIEW 20000023
#define NEWSINGERINDEXSVIEW 20000024
#define NEWSINGERSEARCHINDEXSVIEW 20000025
#define NEWRADIOINDEXSVIEW 20000026
#define NEWMUSICSORTSINDEXSVIEW 20000027
#define RECENT_PLAY_VIEWID      100113  // 最近播放
#define NOWPLAYVIEWID   111111   //正在播放
#define IPODMUSICVIEWID 100021   //ipod歌曲

#define QUICKSEARCHVIEWID 500001   //快速查找

#define CACHE_MUSIC_VIEWID  100004 //下载管理
#define SINGER_VIEWID   100005 //歌手分类

#define LOCALPLAYLISTVIEW  500002   //本地列表
#define EDITPLAYLISTVIEWID  500003   //编辑本地列表
#define SHOWPLAYLISTVIEWID  500004   //本地列表列表

#define OFFLINE_PROMPT_VIEWID  600000   //　离线提醒界面

#define CLOUD_COLLECTION_VIEWID  700000   //　网络收藏
#define CLOUD_COLLECTION_LIST_VIEWID  700001   //　网络收藏列表
#define SINGER_MUSICLIST_VIEWID 100006 //歌手歌曲列表
#define CACHE_MUSICSEARCH_VIEWID 100007 //下载歌曲搜索列表
#define SYNC_FILE_PROMPT_VIEWID 100008  //同步文件目录提示界面
#define PUSH_NOTIFICATION_VIEWID 8000001 //推送通知界面

int  g_Tabbar_Index_1;  //tabbar item 指向的viewid
int  g_Tabbar_Index_2;
int  g_Tabbar_Index_3;
int  g_Tabbar_Index_4;
NSData *g_headImageData;

int  g_Tabbar_NowIndex;   //tabbar 前一个选中指向的viewid
int  g_Tabbar_PreIndex;   //tabbar 选中指向的viewid
int  g_Tabbar_pre_select_tag;

Boolean isOutLineOrInline;

Boolean g_isRefreshRecentRadioTabelView;
BOOL    g_isYueKuLoading;

int g_NetPreViewId;

int g_yuekuSwitchIdTag;//乐库首页切换标识
int g_singerIndexSwitchIdTag;//歌手首页切换标识
int g_yuekuSortIndexSwitchIdtag;//分类切换标识
int g_longinSwitchIdTag;//登录页面切换标识

int g_mvSwitchIdTag;

int g_nowplayviewswitchindex;
int g_editpreindex;


NSString *g_singerSearchIndexName;//搜索列表中选择的歌手名字
NSString *g_singerIndexImageUrl;//歌手列表中选择的歌手头像url
int g_singerID;//歌手列表中选择的歌手id
UIImage *g_singerHeadImage;
NSString *g_newSingerId;
NSString *g_newSearchSingerId;

BOOL g_isLoadImageAndMessage;
BOOL g_isLoadSingerImageAndMessage;


int g_nowUsePicimageId;//当前使用的皮肤id
int g_yuekuOneMusicViewId;

NSString *g_searchKeyName;//搜索关键字
NSString *g_singerSearchKeyName;//歌手搜索关键字
//NSString *g_searchGameKeyUrl;//搜索关键字游戏url

int g_weiboSwitchIndex;  //新浪微博切换标识
int g_syncFileViewSwitchIndex; //同步文件目录引导界面切换标识
NSString *g_sigerName; //歌手名

BOOL g_cachSortTag; //下载排序标识

int g_addControlIndex; //添加标识 1 下载 2 本地 3 网络 4 最近
int g_cachtag;
int g_localtag;
int g_nettag;

int g_cachRow;//下载行
BOOL g_isMusicMoreOrOneAdd; //添加歌曲是多选yes 或者 单选no

#define RECENTADD_NOTIFICATION @"RECENTADD_NETLOAD" //检查最近添加通知
#define ADDVIEW_CREATLOCALLIST @"ADDVIEW_CREATLOCALLIST_NETLOAD" //添加页面创建本地列表通知
#define ADDVIEW_CREATCOLLECTIONLIST @"ADDVIEW_CREATCOLLECTIONLIST_NETLOAD" //添加页面创建网络收藏列表通知
#define OLD_RECENTADD_NOTIFICATION_VALUE @"OLD_VALUE" //最近旧值
#define NEW_RECENTADD_NOTIFICATION_VALUE @"NEW_VALUE" //最近新值
#define ISDELECTORRENAME_VALUE @"DELECT_ORNOT_VALUE" //是删除或者重命名

BOOL g_isnewStart;  //每次启动程序第一次显示动画
int g_sendMusicViewid;

int g_addAlbumViewBackId;
BOOL g_isChangePageId;

int g_collectionListNow;

BOOL g_isShowAnimotion;


NSString* g_SingerViewSelectedName;  //选中的歌手名
int g_singerViewSwitchIndex;    //歌手列表切换标识

int g_myKugouSelectedIndex;

NSString *g_oneMusicTitle;//单曲标题
NSString *g_singerListTitle;//歌手列表标题
NSString *g_netCollectionListTitle;//网络收藏列表标题

int g_localPlayListSelectedIndex; //本地收藏选择项标识
int g_localPlayListSwitchIndex;   //本地收藏切换标识
int g_netCollectionSelectedIndex; //网络收藏选择项标识
int g_netCollectionSwitchIndex;  //网络收藏切换标识
int g_myKugouSelectedIndex;     //我的酷狗选择项标识
int g_myKugouSwitchIndex;       //我的酷狗切换标识
int g_YueKuRecommendSelectedIndex;
int g_YueKuRecommendSwitchIndex;
int g_YueKuRangSelectedIndex;
int g_YueKuRangSwitchIndex;
int g_sortMoreSelectedIndex;
int g_sortMoreSwtichIndex;
int g_sortListenSelectedIndex;
int g_sortListenSwitchIndex;
int g_singerListSelectedIndex;
int g_singerListSwitchIndex;
int g_singerOwnMoreSelectedIndex;
int g_singerOwnMoreSwitchIndex;

int g_settingViewSelectedIndex;
int g_settingViewSelectedSection;
int g_settingViewSwitchIndex;

int g_YueKuMusicListSwitchIndex;
int g_SingerOneMusicSwitchIndex;

BOOL g_isNeedLoactionFromSearch; //快速搜索返回定位
BOOL g_isDownLoadingNeedLocation; //正在下载的歌曲定位

BOOL g_isNeedReloadSingerView;


int g_radioSwitchTag;//电台页面切换
int g_isNetCollectionlistPage;


AnimationType g_nowAnimationType;

BOOL g_isNowplayView;

int g_listpreviewid;


BOOL g_isMyKugouLoginBtnClicked;

NSString *singerContent;//歌手信息
NSString *searchSingerContent;//歌手信息

BOOL g_isGetSingerHeadImage;//是否获取歌手头像
BOOL g_isComeFromConectionPage;//是否来自网络收藏页面

BOOL g_isSyingCollection;//是否在同步云列表

UIImage *g_userHeadImage;

int g_selectRowOfTableView;//

BOOL g_isChangeUser;//是否切换用户

BOOL g_isRefressSingerMessageView;//是否刷新歌手信息页面

BOOL g_isChangeUserHeadImage;//是否切换用户头像

BOOL g_isChangLoginTag;


BOOL g_isDragging;


BOOL g_isFirlll;


AnimationType g_animationType;


UIView * g_nowview;


int g_comaddindex;

BOOL needx;

BOOL g_isTabBarChick;


BOOL g_isneedtoremove;

BOOL g_isautologiin;

NSString *g_userLonginName;//用户登录名字
NSString *g_userLonginPwd;//用户登录密码

BOOL g_searchKeyIsSinger;//搜索关键字是否为歌手

BOOL g_ispopshow;

BOOL g_isLaunchingFromPush;
int g_dianTaiSetlectItemId;
BOOL g_dianTaiScrollFlag;
NSString *g_pushTitle;
BOOL g_isPushViewNeedLoaction;


BOOL g_isCanSlide;  //控制页面是否可以拖动

BOOL g_isNowPlayCanSlide;  //控制播放页面是否可以拖动


int g_stackTag;
BOOL g_isCanEdit;//用户密码框是否可以点击

BOOL g_isBackFromSingerList; //从歌手歌曲列表返回到歌手分类列表，用于定位
BOOL g_isBackFromNetListToRecom; //从歌曲列表返回到推荐
BOOL g_isPreViewRecom;         //前一个列表是推荐
BOOL g_isBackFromNetListToRang; //从歌曲列表返回到排行
BOOL g_isPreViewRang;         //前一个列表是排行
BOOL g_isBackFromNetListToSortMore; //从歌曲列表返回到专辑
BOOL g_isPreViewSortMore;         //前一个列表是专辑
BOOL g_isBackFromNetListToSortListen; //从歌曲列表返回到精选集
BOOL g_isPreViewSortListen;         //前一个列表是精选集
BOOL g_isBackFromNetListToSingerMore; //从歌曲列表返回到歌手专辑
BOOL g_isPreViewSingerMore;         //前一个列表是歌手专辑
BOOL g_isBackFromSingerOwnToSngerList;
BOOL g_isSetViewNeedLocation;   //设置界面是否需要定位
BOOL g_isBackFromLocalPlayList; //从本地收藏是返回
BOOL g_isBackFromNetCollectionList; //从网络收藏返回

NSString *addTitle;//添加的默认名称

NSString *g_vipTime;//vip到期时间

BOOL g_isDismissFromAddList;

//强制版本更新
BOOL g_isForceUpdateVersion;

BOOL g_isiPodViewExist;
BOOL g_isMusicSearchViewFirstLoad;
BOOL g_isMVSearchLoad;

//登录注册入口标示
int g_loginOrRgFrom;//0为导航栏登录或者登录页面注册或者个人信息页面的注销　１为导航栏注册　２为高品音质的登录注册入口 3为vip情况下的登录入口
BOOL g_isVipDetailViewRegister;

int g_downLoadSongCount;

int g_grayviewid;

int g_isEnter;

BOOL g_isFirstEnter;   //mv第一次启动提示

