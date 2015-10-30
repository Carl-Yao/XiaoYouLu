/*
 *  globalDef.h
 *  kugou
 *
 *  Created by apple on 11-4-28.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */





//newcontroller

#define MYMUSICVIEWID 1000000
#define IPODMUSICVIEW 100001
#define KUGOUMUSICVIEW 100002
#define SINGERMUSICVIEW 100003
#define MUSICLISTVIEW 100004
#define SINGERSONGLISTVIEW 100005
#define EDITPLAYLISTVIEW 100006
#define NETMUSICVIEW 100007
#define REGISTERPAGE 100008
#define RECENTLYPLAYEDVIEW 100009

//BOOL isNewInterFace;

//页面切换帮助文档

#define	VIEWID		10000
#define LOGINVIEWID		(VIEWID+10000)
#define TOPBARVIEW		(VIEWID+20000)
#define MAINVIEWID      (VIEWID+30000)
#define PLAYVIEWID      (VIEWID+40000)
#define TRYLISTONVIEWID (VIEWID+50000)
#define SEARCAERVIEWID  (VIEWID+60000)
#define SETVIEWID       (VIEWID+70000)
#define LISTENFORNICEGRIDVIEWID  100
#define SHOWTABLEVIEWID 110

#define MUSICPLAYERVIEWID (VIEWID+80000)
#define LOCALFILEMANGERID    (VIEWID+90000)
#define MUSICTYPEVIEWID 120
#define PLAYLISTSVIEWID 130
#define LOVERECORDSVIEWID 140
#define TESTVIEWID 150
#define SERCHLISTVIEWID 160
#define TOPICSMUSICVIEWID 170
#define TOPICSMUSICLISTVIEWID 175
#define TOPICSMUNSICSHOWVIEWID 180
#define LISTENSHOWVIEWID 190

#define FEEDBACKVIEWID 1000
#define SETINGVIEWIDd 1001
#define ABOUTKUGOUVIEWID 1002

#define MUSICTYPESHOWVIEWID 1003

#define SHOWMISICLISTVIEWID 1004


#define DOWNLOADMANGERVIEWID  1005

#define PLAYLISTSHOWVIEWID  1006


#define MUSICTYPEMANAGERVIEWID 1007

#define NETMUSICMANAGERVIEWID 1008


#define NEWSEARCHMUSICVIEWID 1009

#define EDITMUSICLISTVIEWID 1010

#define PAEAMETEROFSETVIEWID 1011

#define PAEAFEEDBACKFSETVIEWID 1012


#define configview 200

#define changTime 0.5 //定位时间


int  configindex;
int  Preindex;
int  view_index;

int tabar_1_index;
int tabar_2_index;
int tabar_3_index;
int tabar_4_index;


BOOL inBackon;
BOOL isSyn;
BOOL needSyn;
BOOL isbackup;

int searchview_backindex;

BOOL PlsyMusic;

BOOL isRandom;

BOOL isNetErr;

BOOL isNetMusic;

BOOL isListTo;

int NetPreIndex;

int NetNowIndex;

BOOL isNeedRef;

BOOL isTapBBack;

int NetPageIndex;

int NetMusicIndex;

BOOL inTab;
BOOL isSingerList;
int senderType;
int parmetertype;
int g_stopPlayLimitTime; // 定时停止播放
int g_curStopPlayLimitTime;
NSTimer* g_limitStopPlayTimer;
NSThread *g_limitStopPlayThread;

//本地播放时选择的项
int selectedsong;

BOOL isDataBack;


int downloadviewindex;
int tabviewindex;

//是否同步
BOOL isSyndata;
//是否为播放页面
BOOL isMusicPlay;
//是否为设置颜色页面
BOOL isColorSetting;

BOOL MidMore;
int MidPage;

BOOL InfoMore;
int InfoPage;

BOOL FuckOff;

BOOL reBack;


BOOL NetMusci;
BOOL NetMid;
BOOL NetInfo;

BOOL isSynIpodMusic;

int list;
int search;

int  SetIndex;


BOOL ismoreinfolist;
BOOL moreinfolist;

BOOL isNetInfoSend;

BOOL isNetView;  //当前页面是否是netview;

BOOL isLogin;

int isNetViewTag;

BOOL isLoginSucceed;

int CloudCollection;

BOOL CloudErro;

BOOL isAutoLogin;

int LoginAndRegister;

BOOL isdelegate;

BOOL isStartLogin;


BOOL isradioData;

int radiocount;

BOOL oldNetState;

int indexSection;
int indexRow;
BOOL mid_more_info;

int cloudMusicListIndexRow;

int downFinishiIndexRow;


BOOL isSynAuto;

BOOL isStartNetList;

//菜单功能btn个数：2为有两个btn，３为有三个btn；
int meNuTag;

int MenuRow;
int MenuSection;
int MenuViewHight;

//网络歌曲indexRow
int cachIndexRow;

//收藏列表区分重命名和新建列表
int reNameOrNewList;

//选择收藏夹列表
int collectionListIndex;

////添加或者删除网络收藏歌曲标识
int collectionIndexRow;
int collectionSection;

//新建行
int newRow;
BOOL isDataFFFFF;
//本地列表区分重命名和新建列表,0为添加，１为重名名
int LocalReNameOrAddList;
//网络收藏列表区分重命名和新建列表,0为添加，１为重名名
int NetCollectionReNameOrAddList;

int musicTableType;

//最近播放
int recentMusicRowIdex;
int recentMusicSectionIdex;
//ipod歌曲
int IpodMusicRow;
int IpodMusicSection;

//下载歌曲排序
BOOL isFirstOrTime;
//是否点击排序button
BOOL isClickSortBtn;

//我的音乐定位标识
int   myMusicRowIndex;
int   myMusicSectionIndex;
BOOL  isLocateForMyMusic;
BOOL  myMusicListIscroll;
BOOL isNewList;

//歌手列表定位标识
int  singerListRowIndex;
//int  singerListSectionIndex;
BOOL isLocateForSinger;

//网络收藏列表定位标识
int netCollectionListRowIndex;
int netCollectionListSectionIndex;
BOOL isLocateForNetCollectionList;
BOOL isScroll;
BOOL isNetlist;

//电台列表定位标识
int radioMusicListRowIndex;
int radioMusicListSectionIndex;
BOOL isLocateForRadioList;

//网络歌曲第一层列表定位标识
int netMusicListFirstRowIndex;
int isLocateForNetMusicList;

//网络歌曲第二层列表定位标识
int netMusicListTwoRowIndex;
int isLocateForTwoNetMusicList;

//网络歌曲第三层列表定位标识
int netMusicListTreeRowIndex;
int isLocateForTreeNetMusicList;

//搜索是否成功
BOOL isSearchSuccess;

//搜索状态
BOOL searchStatus;

//是否刷新搜索列表
BOOL isReloadSearchList;

//音乐列表是否在加载数据
BOOL g_isDataLoading;

//同步数据是否已经写入数据库
BOOL g_isFinishedWriteBase;

BOOL isback;

//乐库数据回调状态；
//LV1 ++
BOOL isMenuCallBack;
BOOL isListCallBack;
BOOL isMidCallBack;
BOOL isInfoCallBack;
BOOL isNetErro;
BOOL isOutNet;
BOOL isBreakNow;

//是否为已下载列表
BOOL isCashFinishList;

//是否在添加到下载
BOOL isAddCachItem;

//是否存在搜索页面
BOOL isHaveSearchListView;

//同步云音乐方式
BOOL isSynDragging;

// ipod歌曲是否发生了变化
BOOL g_isIpodSongChanged;

//0为反馈信息，１为本版信息
int isFeedBackOrEditon;

// 乐库界面是否销毁
BOOL g_isNetListViewFree;

// 当前内容页的标题
NSString *g_centerViewTitle;
BOOL g_isSliderToSwitch;

//是否滑动到home界面
//BOOL g_isSliderToHomeSwitch;

BOOL g_isForceChecked;


BOOL g_istopload;


BOOL g_isplaymv;

BOOL g_isVIPuser;

int g_viewTagLastExit;
BOOL g_isLastExitViewIpod;
int g_viewTagLastExitBackup;

int g_outLoginForToLastView;
BOOL g_isLoginFinishedButtonClicked;

BOOL g_isIpodSynding;
BOOL g_isStart;
BOOL g_isIpodSyndingForPlayView;

BOOL g_isFirstPlayLocalMusic;

//记忆歌曲填充之前，是否已经点击播放歌曲，如果已经点击播放歌曲，则记忆歌曲不再填充
BOOL g_isFirstClickPlaylMusic;

BOOL g_isAreadySenderLoginSuccessData;//是有已经发送登录成功数据

BOOL g_isFindMusicKeyBoard;

//BOOL isOnCall; 之前用于记住是否正在打电话，确定打电话过程中出现选择下一首歌曲的问题，对于ios7有bug，去掉。如果用户手多（在打电话过程中，选择播放）就让它边听音乐边打电话吧

BOOL isInterruption;

BOOL g_isHideIndexView;


BOOL isChooseAddMusicForPlayview;

//BOOL g_netCollectionIsAdding;//网络收藏的歌曲是否在添加

int g_verificationNumberType;

int g_phoneBindingViewTag;//0号码输入页面 1为验证页面

int g_pcSendMusicVietSelectTag;//电脑传歌页面选择的tag

BOOL g_isLoadFinishForAlert;//是否已经下载完成

NSString *g_hotSearchKeyUrl;

BOOL g_isautologiin;

//下载歌曲排序
//BOOL isFirstOrTime;

//本地列表区分重命名和新建列表,0为添加，１为重名名
//int LocalReNameOrAddList;
//网络收藏列表区分重命名和新建列表,0为添加，１为重名名
//int NetCollectionReNameOrAddList;


int g_downLoadSongCount;

//登录注册入口标示
int g_loginOrRgFrom;//0为导航栏登录或者登录页面注册或者个人信息页面的注销　１为导航栏注册　２为高品音质的登录注册入口 3为vip情况下的登录入口
BOOL g_isVipDetailViewRegister;