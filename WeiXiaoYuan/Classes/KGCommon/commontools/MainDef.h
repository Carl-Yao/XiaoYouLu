//
//  MainDef.h
//  宏.枚举.变量等定义
//
//  Created by YZX on 2011/6/24.
//  Copyright 2011年 YZX. All rights reserved.
// 

#define SIMULATOR_DEBUG

#define ISGRAY

#define RELEASE_BOUNDARY            RELEASE_INTEGRATE_ALL

#define RELEASE_OFFICIAL            0
#define RELEASE_GRAY                1
#define RELEASE_INTEGRATE_ALL       2
#define RELEASE_INTEGRATE_LISTEN    3
#define RELEASE_INTEGRATE_WATCH     4
#define RELEASE_INTEGRATE_SING      5


#define _ISFREE

#define BETA_RELEASE

#define USING_P2P_DOWNLOAD

#define CASUAL_LISTEN_ROOT_PATH     @"Root\\新版V2\\随便听听\\"

#define TIP_PLAY_LIST_FINISH  @"   当前列表播放完毕"

#define ASSERT_RETURN(VAR) {assert((VAR)); if (!(VAR)) return;}
#define ASSERT_RETURN_VALUE(VAR, VALUE) {assert((VAR)); if (!(VAR)) return (VALUE);}
#define RELEASE_OBJECT(OBJ) {if ((OBJ)) {[(OBJ) release]; (OBJ) = nil;}}

//#warning 集成
//#define OUT // 标识参数为输出类型

#define DEFAULT_FONT_NAME   @"Trebuchet MS" 
#define LYRIC_FONT_NAME DEFAULT_FONT_NAME

// 试听缓存歌曲最大数量
#define CACHEMAXCOUNT  30

// 歌词可选择的大小
#define LYRIC_ONE_FONT_SIZE  14    
#define LYRIC_ONE_SEL_FONT_SIZE  17 
#define LYRIC_TWO_FONT_SIZE  16    
#define LYRIC_TWO_SEL_FONT_SIZE  20 

#define LYRIC_FONT_SIZE  18     // 歌词字体大小
#define LYRIC_SEL_FONT_SIZE  23 // 当前选中歌词的大小
#define LYRIC_DISAPPEAR_FONT_SIZE  14 // 即将消失歌词的大小
#define LYRIC_SHOW_COUNT  7     // 歌词显示的行数
#define LYRIC_TOP_CY     5      // 歌词view区域限制
#define LYRIC_BOTTOM_CY  (116 + 60)
#define LYRIC_SELECT_COLOR  @"#ee4901"
#define LYRIC_NORMAL_COLOR  @"#5d5d5d"

#define LYRIC_SMALL_ROW     9
#define LYRIC_MIDDLE_ROW    7
#define LYRIC_LARGE_ROW     5

#define TITLE_SONG_NAME_FONT_SIZE  16   // 歌曲名显示在标题上的大小
#define TITLE_ARTIST_NAME_FONT_SIZE 14
#define isIOS7   ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
#define isIOS8   ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
// iphone


#define APP_VERSION   @"7496"

#define APP_INNER_VERSION  @"7292"    // 程序内部版本

#define APP_CHANNEL   @"1009"
#define APPSTORE_CHANNEL @"1009"

// HD
#define HD_APP_VERSION  @"1020"    // 程序版本
#define HD_APP_INNER_VERSION  @"1020"    // 程序内部版本
#define HD_APP_CHANNEL  @"1009"    // 渠道号

/**
 * 播放状态
 */
typedef enum ENUM_PLAYSTATE
{
    PLAYSTATE_READY = 0,
    PLAYSTATE_BEGIN,   //1/
    PLAYSTATE_PLAYING,   //2
    PLAYSTATE_STOPED,  //3
    PLAYSTATE_PAUSE,  //4
    PLAYSTATE_PLAY_END,  //5
    PLAYSTATE_PLAY_END_NEXT, //6 播放器建议播放下一曲
    PLAYSTATE_IPOD_MUSIC_NOT_EXIST,  //7
    PLAYSTATE_LOCAL_MUSIC_NOT_EXIST,   //8
    PLAYSTATE_LOCAL_MUSIC_NOT_ENOUGH_MEMORY, //9
    PLAYSTATE_IPOD_MUSIC_NOT_FIND,  //10
    PLAYSTATE_NET_MUSIC_NOT_FIND,  //11
    PLAYSTATE_PLAY_ERROR,  //12
    PLAYSTATE_ONLINE_PLAYING,  //13
    PLAYSTATE_ONLINE_STOPED,  //14
    PLAYSTATE_ONLINE_BUFFERING, // 15 缓冲进度
    PLAYSTATE_ONLINE_BUFFERING_BEGIN, //16 开始缓冲
    PLAYSTATE_ONLINE_BUFFERING_ERROR, //17
    PLAYSTATE_ONLINE_BUFFERING_SIMULATE_BEGIN,  //18 模拟缓冲的情景
    PLAYSTATE_ONLINE_BUFFERING_SIMULATE,  //19
    PLAYSTATE_ONLINE_BUFFERING_END,  //20
    PLAYSTATE_PREPARE_PLAY,  //21
    PLAYSTATE_OPEN_FILE,  //22
    PLAYSTATE_ONLINE_USER_NEXT //23 在线歌曲用户切换下一首
}PLAYSTATE;

/**
 * 音乐来源
 */
typedef enum ENUM_MUSIC_FROM_FORMAT
{
    FROM_FORMAT_UNKNOWN,
    FROM_FORMAT_LOACAL,
    FROM_FORMAT_IPOD,
    FROM_FORMAT_NET,
    FROM_FORMAT_OTHERAPP
}MUSIC_FROM_FORMAT;

#define IPOD_MUSIC_PATH_PREFIX  @"ipod-library:"
#define OTHER_APP_MUSIC         @"file://localhost/private/var"
#define SINGER_IMAGE_SUFFIX     @"kgifull"


/**
 * 播放消息
 *
 */
// 播放状态
// 参数：dict[value:原播放状态(int),key:STR_PRE_STATE]
// [value:现在播放状态,key:STR_CUR_STATE]
#define NOTIFY_PLAY_STATE       @"PALY_STATE" 
#define STR_CUR_STATE           @"CurState"
#define STR_PRE_STATE           @"PreState"



//线控

#define LINE_CONTROLLER_PLAY_OR_PRESSED   @"playorstop"
#define LINE_CONTROLLER_NEXT  @"nextmusic"
#define LINE_CONTROLLER_PRE   @"premusic"

#define LINE_CONTROLLER_PLAY_OR_PRESSED   @"playorstop"
#define LINE_CONTROLLER_NEXT  @"nextmusic"
#define LINE_CONTROLLER_PRE   @"premusic"

// 播放进度
// 参数：dict[value:当前播放进度(double), key:CUR_DURATION]
// [value:总时长(double), key:TOTAL_DURATION]
#define NOTIFY_PLAY_PROGRESS    @"PLAY_PROGRSS" 
#define CUR_DURATION            @"CurDuration"
#define TOTAL_DURATION          @"TotalDuration"

// 播放相关的特殊信息
// 参数：NSNumber* (int)
#define NOTIFY_PLAY_INFO       @"PALY_INFO" 

// 播放相关信息标识
typedef enum 
{
    PLAY_INFO_DOWNLOAD_PROGRESS,  // 下载进度
    PLAY_INFO_SET_TITLE // 设置标题
}PLAY_INFO;


//// 播放模式
//// 最好的设计是界面无需知道这些值，只需要知道显示什么字符串即可
//typedef enum {
////    OrderPlay,          //顺序播放
//    RepeatList,          //列表循环
//    RandPlay,           //随机播放
//    RepeatOne          //单曲循环
//}PlayType;

#define CHECK_SONG_NAME_FLAG    @"CHECK_SONG_NAME"
#define SINGER_IMAGE_FLAG       @"SINGER_IMAGE_FLAG"
#define AUTO_SINGER       @"AUTO_SINGER"
#define AUTO_KRC       @"AUTO_KRC"
// 随便听听
#define CASUAL_SONG_COUNT_REQEUST    8  // 服务器约定请求数不能超过10首
#define CASUAL_REQUEST_RECEIVE_FLAG  @"CASUAL_RECEIVE"

// 列表类型
typedef enum
{
    LIST_TYPE_UNKNOW = 0,
    LSIT_TYPE_LOCAL = 1,
    LIST_TYPE_HISTORY,
    LIST_TYPE_CASUAL, // 随便听听
    LIST_TYPE_BILL,  // 榜单
    LIST_TYPE_SEARCH,    // 搜索结果
    LIST_TYPE_PLAYLIST,
    LIST_TYPE_CLOUDMUSIC, // 云音乐列表
}PLAY_LIST_TYPE;

// 数据库更新
#define NOTIFY_DB_UPDATE       @"DB_UPDATE" 

// 转后台
#define NOTIFY_BACK_GROUND     @"BACKGROUND" 

// 更改歌手名
#define NOTIFY_SINGER_NAME_CHANGE     @"SINGER_NAME_CHANGE" 

#define NOTIFY_USER_TOKEN_EXPIRE @"notify_user_token_expire" //用户token过期

// 请求随便听听歌曲
#define NOTIFY_REQUEST_CASUAL_SONGS     @"CASUAL_SONG_REQUEST"

// 下载任务信息
#define NOTIFY_DOWNLOAD_INFO    @"DOWNLOAD_INFO"
#define DOWNLOAD_INFO_FLAG      @"DOWNLOAD_NOTIFY_REASON"
#define DOWNLOAD_INFO_TASK_ID   @"DOWNLOAD_NOTIFY_TASK_ID"
#define DOWNLOAD_INFO_TASK_FROM_TYPE   @"DOWNLOAD_INFO_TASK_FROM_TYPE"

// 离线任务信息
#define NOTIFY_OFFLINE_FINISH @"OFFLINE_FINISH" // 完成
#define NOTIFY_OFFLINE_FAILED @"OFFLINE_FAIL"   // 失败
#define NOTIFY_OFFLINE_START  @"OFFLINE_START"  // 开始
#define NOTIFY_OFFLINE_PAUSE  @"OFFLINE_PAUSE"  // 停止

#define NOTIFY_GET_SHARE_INOF @"NOTIFY_GET_SHARE_INOF"
#define NOTIFY_GET_SHARE_FAILED @"NOTIFY_GET_SHARE_FAILED"
#define NOTIFY_SEND_SHAREO_INFO_FAILED @"NOTIFY_SEND_SHAREO_INFO_FAILED"
#define NOTIFY_SEND_SHAREO_INFO_SUCCESS @"NOTIFY_SEND_SHAREO_INFO_SUCCESS"
#define NOTIFY_GET_SHARE_RESP_FAILED @"NOTIFY_GET_SHARE_RESP_FAILED"
#define NOTIFY_SEND_RESP_INFO_FAILED @"NOTIFY_SEND_RESP_INFO_FAILED"
#define NOTIFY_SEND_RESP_INFO_SUCCESS @" NOTIFY_SEND_RESP_INFO_SUCCESS"

#define NOTIFY_LOCAL_MUSIC_COUNT_CHANGED @"LOCAL_MUSIC_COUNT_CHANGED"
#define NOTIFY_DOWNLOAD_COUNT_CHANGE @"download_count_change"
#define NOTIFY_DOWNLOADFINISH_REPLACE_NOTIFY @"downloadfinish_replace_notify"

#define NOTIFY_SINGER_MUSIC_DELETE @"SINGER_MUSIC_DELTE"

//自动下载歌手写真和歌词
#define NOTIFY_AUTO_DOWNLOAD_PIC_KRC @"NOTIFY_AUTO_DOWNLOAD_PIC_KRC"
// 下载相关信息标识

#define NOTIFY_RECENTLY_CONENT_CHANGE @"NOTIFY_RECENTLY_CONENT_CHANGE"
typedef enum 
{
    DOWNLOAD_INFO_PREPARE_ADD_ITEM,
    DOWNLOAD_INFO_QUALITY_ADD_COLLECT_ITEM,
    DOWNLOAD_UPGRADE_QUALITY_ADD_COLLECT_ITEM,
    DOWNLOAD_INFO_QUALITY_ADD_ITEM,
    DOWNLOAD_INFO_BATCH_QUALITY_ADD_ITEM,
    DOWNLOAD_INFO_ADD_ITEM, 
    DOWNLOAD_INFO_DEL_ITEM,
    DOWNLOAD_INFO_DOWN_FINISH = 5,
    DOWNLOAD_INFO_REPEAT_DOWN_FINISH = 6, // down again finished
    DOWNLOAD_INFO_DOWN_FAIL,
    DOWNLOAD_INFO_PROGRESS, 
    DOWNLOAD_INFO_PAUSE,
    DOWNLOAD_INFO_WAIT,
    DOWNLOAD_INFO_START,
    DOWNLOAD_INFO_LOAD_FROM_DB,
    DOWNLOAD_INFO_ALL_PASUE,
    DOWNLOAD_INFO_ALL_START,
    DOWNLOAD_INFO_DEL_FINISH_ITEM,
    DOWNLOAD_INFO_DEL_ALL_FINISH_ITEM,
    DOWNLOAD_INFO_FILE_EXIST,
    DOWNLOAD_INFO_TASK_EXIST, // 18
    DOWNLOAD_INFO_DOWNURL_NIL,
    DOWNLOAD_INFO_BATCH_DOWNLOAD_ADD_FIINISH,
    DOWNLOAD_INFO_FAIL_NOT_ENOUGH_SPACE,
    DOWNLOAD_INFO_ADDED_TO_CACHE_QUEUE,
    DOWNLOAD_INFO_ALL_CACHED_OR_CACHING,
    DOWNLOAD_INFO_NOT_CHINA,
}DOWNLOAD_INFO;

// 修改，提示任务信息
#define ALERT_NOTIFICATION    @"ALERT_INFO"
//修改，提示框出现
#define ALERT_NOTIFICATION_IN @"ALERT_IN"
//修改，提示框消失
#define ALERT_NOTIFICATION_OUT @"ALERT_OUT"

//修改，add等待加载中提示框信息
#define ADDLOADINGWAITVIEW_NOTIFICATION @"ADD_LOADINGWAIT_VIEW"
//修改，remove等待加载中提示框信息
#define REMOVELOADINGWAITVIEW_NOTIFICATION @"REMOVE_LOADINGWAIT_VIEW"

//修改，add等待加载中提示框信息  不禁止用户输入
#define ADDNETLOAD_NOTIFICATION @"ADD_NETLOAD_VIEW"
//修改，remove等待加载中提示框信息  不禁止用户输入
#define REMOVENETLOAD_NOTIFICATION @"REMOVE_NETLOAD_VIEW"

// 提示信息
#define TIP_IP_LIMIT    @"境外IP受限"
#define NOTIFY_IP_LIMIT  @"ip_limit"

#define TIP_ONLY_WIFI_CONNECT    @"只能在wifi下连网"
// 歌词显示颜色改变通知
#define NOTIFY_LYRIC_SHOW_COLOR_CHANGE       @"lyric_show_color_change" 

// 在线歌曲对应的url发生了改变
#define NOTIFY_SONG_INFO_URL_CHANGE         @"song_info_url_change"
#define NOTIFY_SONG_INFO_URL_CHANGE_PARAM   @"song_info_url_change_param"

// 删除本地文件通知
#define NOTIFY_LOCAL_FILE_DEL         @"local_file_delete"
#define NOTIFY_LOCAL_FILE_DEL_PARAM   @"local_file_delete_param"
#define NOTIFY_BATCH_LOCAL_FILE_DEL   @"batch_local_file_delete"

// 定时停止播放，剩余时间发生变化
#define NOTIFY_LIMIT_STOP_PLAY_TIME_CHANGE  @"limit_stop_play_time_change"

// 播放异常通知
#define NOTIFY_PLAY_FAIL_INFO       @"play_fail_info"
#define NOTIFY_PLAY_FAIL_INFO_URL_NULL  0


// 播放页面ipod音乐播放出错同步通知
#define NOTIFY_IPOD_SYN_FOR_PLAYVIEW       @"ipod_music_synch_for_playView"

// 播放页面ipod音乐播放出错同步完成通知
#define NOTIFY_IPOD_SYNFINISH_FOR_PLAYVIEW   @"ipod_music_synchfinish_for_playView"

// 播放页面ipod音乐播放出错同步完成去掉提示通知
#define NOTIFY_IPOD_SYNFINISH_ALERT_FOR_PLAYVIEW   @"ipod_music_synchfinish_alter_for_playView"

// 完成ipod音乐同步通知
#define NOTIFY_IPOD_SYN_FINISH       @"ipod_music_synch_finish"
// 完成download音乐同步通知
#define NOTIFY_DOWNLOAD_SYN_FINISH       @"download_music_synch_finish"
// ipod同步数据已经写入数据库通知
#define NOTIFY_IPOD_SYN_DATA_ALREADY_TO_DB       @"ipod_music_synch_data_already_to_db"

// 关键字匹配完成通知
#define NOTIFY_SEARCH_KEY_MATCH_FINISH  @"search_key_match_finish"

// 解析完歌词
#define NOTIFY_LYRIC_TOKEN_COMPLETE     @"lyric_token_complete"

// 电台歌曲请求失败
#define NOTIFY_RADIO_SONG_REQUEST_FAIL  @"radio_song_request_fail"

// 电台没有歌曲
#define NOTIFY_RADIO_SONGS_EMPTY    @"radio_songs_empty"

// 最近播放列表内容变化
#define NOTIFY_RECENT_PLAY_LIST_CHANGE  @"recent_play_list_change"

// MV缓存数量变化
#define NOTIFY_MV_CACHE_CHANGE   @"mv_cache_change"

// 我喜欢列表内容变化
#define NOTIFY_MY_FAVOR_LIST_CHANGE  @"my_favor_list_change"

#define NOTIFY_MY_FAVOR_LIST_COUNT_CHANGE @"my_favor_list_count_change"

// 歌词调整时间发生变化
// 参数：LyricShowerData*
#define NOTIFY_LYRIC_ADJUST_TIME_CHANGE @"lyric_adjust_time_change"

// 试听时下载完毕，并已写入文件
// 参数: DownTask*
#define NOTIFY_BUFFERED_WHEN_LISTEN     @"buffered_when_listen"

// 下载列表歌曲重新排序
// 参数：NSMutableArray {MusicInfo*}
#define NOTIFY_CACHE_SONG_SORT_AGAIN    @"cache_song_sort_again"
#define NOTIFY_BUFFERED_WHEN_LISTEN     @"buffered_when_listen"
#define NOTIFY_SONGBUFFERED_CACHE       @"songbuffered_cache"

#define NOTIFY_STREAM_DOWN_FINISH @"NOTIFY_STREAM_DOWN_FINISH"

// 用户登出
#define NOTIFY_USER_LOGIN_OUT       @"user_login_out"

// 用户登录
#define NOTIFY_USER_LOGIN       @"user_login"

// 取得用户权限信息
#define NOTIFY_GOT_USER_RIGHT          @"user_got_user_right"

// 查询该用户是否有权获取vip赠送
#define NOTIFY_QUERY_USER_VIP_GIFT        @"user_query_user_vip_gift"
#define NOTIFY_GOT_USER_VIP_GIFT          @"user_got_user_vip_gift"
#define NOTIFY_STATISTICS_LOG          @"user_statistics_log"
//用户由下载音质选择跳转登录
#define NOTIFY_USER_LOGINFROMDOWNLOAD    @"user_loginfromdownload"



// 用户注册成功
#define NOTIFY_USER_REGISTER       @"user_register"

// 用户注册成功跳转
#define NOTIFY_USER_REGISTER_CHANGE       @"user_register_change"

// 用户点击登录页面注册btn
#define NOTIFY_USER_CLICKLOGINVIEWREGISTERBTN       @"user_clickloginview_registerbtn"

// 用户点击注册页面返回btn
#define NOTIFY_USER_CLICKREGISTERVIEWBACKBTN       @"user_clickregisterview_backbtn"

// 查看会员详情
#define NOTIFY_USER_LOOKVIPDETAIL       @"user_look_uservipdetail"

// 个人信息
#define NOTIFY_USER_MESSAGE       @"user_message"

//数据加载完成通知
#define NOTIFY_MUSICLIST_LOADDATAFINISH       @"MUSICLIST_LOADDATAFINISH" 

// 设置下载进度完成
#define NOTIFY_CACHE_PROGRESS_FINISHED      @"cache_progress_finished"

// 显示当前歌曲标题
// 参数：NSString* 标题
#define NOTIFY_SHOW_CURRENT_SONG_TITLE      @"show_current_song_title"

// 共享目录文件有变化
#define NOTIFY_SHARE_SONG_DIR_CHANGE    @"share_song_dir_change"

// 共享目录扫描完毕
#define NOTIFY_SHARE_SONG_SCAN_COMPLETED    @"share_song_scan_completed"

// web传歌完毕，已经保存传送的文件
// 参数：NSMutableArray {NSString*}，{文件全路径}
#define NOTIFY_WEB_SONG_SEND_FINISH     @"web_song_send_finish"

// 播放队列内容发生变化
#define NOTIFY_PLAY_QUEUE_CONTENT_CHANGED    @"play_queue_content_changed"

// 离线模式切换
// 参数：NSNumber* (BOOL) 开启/关闭
#define NOTIFY_OFFLINE_MODE_CHANGED    @"offline_mode_changed"


//离线模式切换：OfflineMgr改变值后发出该通知
//参数：无
#define NOTIFY_ON_OFFLINE_MODE_CHANGED @"on_offline_mode_changed"


// 流量或播放数量发生变化
#define NOTIFY_FLOW_CHANGED     @"flow_play_changed"

//网络类型变化，当前为2G/3G
#define NOTIFY_NETCHANGE_WIDENET @"net_type_widenet"

#define NOTIFY_NETCHANGE_WIFI @"net_type_wifi"

#define NOTIFY_NETCHANGE_NO_NET @"net_no_net"

#define NOTIFY_ONLY_WIFI_SETTING_CHANGE @"NOTIFY_ONLY_WIFI_SETTING_CHANGE"

//皮肤更换通知
#define NOTIFY_SKIN_CHANGED     @"skin_is_changed"

//详细场景引蒙层引导图触摸结束
#define NOTIFY_DIRECTVIEW_TOUCHDEND  @"dierctView_touchend"

// 最近播放电台取得图片
#define NOTIFY_RECENT_RADIO_GOT_IMAGE  @"recent_radio_got_image"

// 是否联网
#define NOTIFY_IS_CONNECT_NET   @"is_connect_net"

// 当前是电台播放，不能稍后播放
#define NOTIFY_CANNOT_PALY_LATER_FOR_RADIO_PLAYING  @"cannot_play_later_for_radio_playing"
#define NOTIFY_AUTO_LOGIN @"auto_login" 
// 注销刷新页面通知
#define NOTIFY_NOTLOGIN_UPDATA    @"not_login_updata"

//#define NOTIFY_UPDATE_USER_RIGHT   @"update_user_right"


#define NOTIFY_UPTOVIP_SUCCESS @"NOTIFY_UPTOVIP_SUCCESS"

// 乐库子组件取消
#define NOTIFY_NOTLOGIN_NET_LIST_SUB_DISAPPEAR    @"net_list_sub_disappear"

// 乐库歌手主页导航
#define NOTIFY_NOTLOGIN_CHANGE_YUEKUNAVBUTTON    @"change_yuekunavbutton"

// 搜索歌手主页导航
#define NOTIFY_NOTLOGIN_SCSINGER_CHANGE_NAVBUTTON    @"change_shsinger_navbutton"


// 乐库子组件编辑状体时点击一行
#define NOTIFY_NOTLOGIN_NET_LIST_SUB_DISAPPEAR_EDIT    @"net_list_sub_disappear_edit"

// 搜索歌手主页子组件编辑状体时点击一行
#define NOTIFY_NOTLOGIN_SCSINGER_LIST_SUB_DISAPPEAR_EDIT    @"net_searchSinger_sub_disappear_edit"

//头像更换通知
#define NOTIFY_USERUPDATAHEADIMAGE_CHANGED     @"userHeadimage_is_changed"

//手机相册拍照页面
#define NOTIFY_USERPINKIMAGE    @"notify_userpickimage"

//歌手头像获取成功通知
#define NOTIFY_SINGERHEADIMAGE_GETSUCCESS     @"singerheadimage_get_success"

// 新功能介绍销毁
#define NOTIFY_NEW_ABOUT_DESTROY     @"new_about_destroy"

// 主界面已经显示
#define NOTIFY_MAIN_UI_DISPLAYED     @"main_ui_displayed"

// 电台启动联网
#define NOTIFY_RADIO_START_ON_LINET  @"radio_start_on_line"

// 乐库启动联网
#define NOTIFY_NET_LIST_START_ON_LINET  @"net_list_start_on_line"

// 在线搜索启动联网
#define NOTIFY_ONELINE_SEARCH_START_ON_LINET  @"net_online_search_start_on_line"

// 应用启动联网
#define NOTIFY_APP_RECOMMEND_START_ON_LINET  @"net_app_recommend_start_on_line"

// 歌手首页启动联网
#define NOTIFY_NEWSINGER_INDEXPAGE_START_ON_LINET  @"net_newsinger_indexpage_start_on_line"

// 歌手列表启动联网
#define NOTIFY_NEWSINGER_LISTS_START_ON_LINET  @"net_newsinger_lists_start_on_line"

// 歌手主页启动联网
#define NOTIFY_NEWSINGER_INDEX_START_ON_LINET  @"net_newsinger_index_start_on_line"

// 搜索歌手主页启动联网
#define NOTIFY_SEARCHNEWSINGER_INDEX_START_ON_LINET  @"net_searchnewsinger_index_start_on_line"

// 新电台主页启动联网
#define NOTIFY_NEWRADIO_INDEX_START_ON_LINET  @"net_newradio_index_start_on_line"
// 新歌曲分类主页启动联网
#define NOTIFY_NEWMUSICSORTS_INDEX_START_ON_LINET  @"net_newmusicsorts_index_start_on_line"

//收到推送消息
#define NOTIFY_RECEIVE_PUSH_NOTIFICATION @"receive_push_notification" 

// 启动后音乐记录读取完毕
#define NOTIFY_MUSIC_READ_FINISH_WHEN_APP_RUN @"music_read_finished_app_run"

//搜索结果页面点击多选通知
#define NOTIFY_CLICK_MOREOPTHION_NOTIFICATION @"click_moreopthion_notification" 
//搜索结果页面点击多选通知
#define NOTIFY_CANCELL_CLICK_MOREOPTHION_NOTIFICATION @"cancell_click_moreopthion_notification" 

//搜索结果通知
#define NOTIFY_SEARCHREASULT_NOTIFICATION @"searchreasult__notification" 
#define NOTIFY_SEARCHREASULT_KEY_NOTIFICATION @"searchreasult__key_notification"

#define NOTIFY_CACHEMUSIC_SCROLLED @"CacheMusicTableDidScrolled"

#define NOTIFY_PUSH_RECOMMEND @"notify_psuh_recommend"


#define NOTIFY_NOWPLAYVIEW_ADDPANG  @"nowplayviewaddnpanG"
#define NOTIFY_NOWPLAYVIEW_REMOVEPANG  @"nowplayviewremovepanG"


#define NOTIFY_SHOWVIEWS @"showviews"

//新歌手主页切换页面
#define NOTIFY_NEWSINGEVIEW_SWITCHVIEWTMORE @"newsigerview_switchview_tomore"

#define NOTIFY_NEWSINGEVIEW_SWITCHVIEWTONE @"newsigerview_switchview_toone"

#define NOTIFY_NEWSINGEVIEW_SWITCHVIEWTOMV @"newsigerview_switchview_tomv"

#define NOTIFY_SHOWVIEWS_FORLOGINVIEW @"showviews_forloginView"

#define NOTIFY_ISPLAYMUSIC @"isplaymusic"

//网络歌曲添加
#define NOTIFY_NETMUSIC_ADD @"netmusic_add"

#define NOTIFY_CLOUD_COLLECTION_MERGER  @"cloud_collection_merger"

//更新用户信息
#define NOTIFY_UPDATA_USER_INFO @"updata_user_info" 

//网络歌曲添加成功
#define NOTIFY_NETMUSIC_ADD_SUCCESS @"netmusic_add_success" 

// 播放模式不可用
#define NOTIFY_PLAY_MODE_DISABLE  @"play_mode_disable"

//　播放模式可用
#define NOTIFY_PLAY_MODE_ENABLE    @"play_mode_enable"

//　耳机插入
#define NOTIFY_Device_Available    @"DeviceAvailable"

//  播放MV时电话呼入
#define NOTIFY_Phone_Income  @"notify_phone_income"

//  播放MV时电话呼出
#define NOTIFY_Phone_Callout  @"notify_phone_callout"

//同步更新成功别人的歌单
#define NOTIFY_SYN_OTHER_LIST_SUCCESS  @"NOTIFY_SYN_OTHER_LIST_SUCCESS"

//　播放模式可用
#define NOTIFY_DISKSPACE_NOT_ENOUGH    @"not_enough_diskspace"

// 网络收藏空间限制
#define NOTIFY_NET_LIST_FIZE_SIZE_LIMIT  @"net_list_fize_size_limit"

// 同步收藏
#define NOTIFY_NET_LIST_UPDATE_LOADING  @"net_list_update_loading"

#define NOTIFY_CALL_SHARE_SEARCH_VIEW @"CALL_SHARE_SEARCH_VIEW"

// 同步收藏完成
#define NOTIFY_NET_LIST_UPDATE_FINISH  @"net_list_update_finish"

#define SYN_STATUS @"synStatus" //同步状态，是否成功

// 下载歌曲信息为空
#define NOTIFY_DOWNLOAD_REQUEST_RESPONSE_EMPTY  @"download_request_response_empty"

#define NOTIFY_DOWNLOAD_REPLACENOTIFY   @"batch_download_replceNotify"

//　
#define NOTIFY_ADD_COLLECTION_FINISH    @"add_collection_finished"

#define NOTIFY_ADD_COLLECTION_CANCEL    @"add_collection_cancel"

#define NOTIFY_LOGIN_ERROR_MESSAGE @"login_erron_message"

#define NOTIFY_IPOD_SYN_END @"ipod_syn_end"
#define NOTIFY_IPOD_ITOOLS_SENDDATAFINISH @"ipod_itools_senddatafinish"

#define NOTIFY_MUSIC_SEARCH_RETURN @"music_search_return"
#define NOTIFY_MV_SEARCH_RETURN @"mv_search_return"

#define NOTIFY_APP_ENTER_FOREGROUND @"app_enter_foreground"
#define NOTIFY_APP_WILL_TERMINATE @"app_will_terminate"

#define NOTIFY_SHOW_NEWSONG_EDITVIEW @"show_newsong_editView"
#define NOTIFY_SHOW_NEWSONG_HEADVIEW @"show_newsong_headView"

#define NOTIFY_UPDATE_HEADVIEW_IMAGE @"update_headview_image"

#define NOTIFY_PUSH_VIEW_NEED_SKIP @"push_view_need_skip"

#define NOTIFY_UPATE_NETCOLLECTION_COUNT @"update_netcollection_count"
#define NOTIFY_UPATE_LOCALCOLLECTION_COUNT @"update_localcollection_count"
#define NOTIFY_LOGIN_ONCOLLECTIONVIEW @"login_oncollectionView"

#define NOTIFY_CHANGE_NET_OFFLINE_STATE @"change_net_offline_state"
#define NOTIFY_GET_ALL_NET_LIST_INFO    @"get_all_net_list_info"
#define NOTIFY_ATTENTION_SINGER_CHANGED @"attention_singer_changed"

#define NOTIFY_UNICOM_RESET @"unicom_reset"
#define NOTIFY_UNICOM_EXPIRE @"unicom_expire"
#define NOTIFY_INC_FLOW @"notify_inc_flow"
#define NOTIFY_UNICOM_VIP @"unicom_vip_state"

#define NOTIFY_UNICOM_SUBPRODUCT @"unicom_subproduct"

#define NOTIFY_HD_CHANGE_PLAY_MODE @"change_play_mode"
#define NOTIFY_HD_SLIDER_VALUE_CHANGE @"slider_value_change"
#define NOTIFY_HD_SHOW_MUSIC_TITLE @"show_music_title"
#define NOTIFY_HD_REQUEST_AGAIN @"request_again"
#define NOTIFY_IPHONE_OUTPCSENDMUSICVIEW @"iphone_outPCsendmusicview"
#define NOTIFY_IPHONE_USERMESSAGE_RETURNFRESS @"iphone_userMessage_returnFress"
#define NOTIFY_IPHONE_BINDINGEMAIL_SUCCESS @"iphone_bindingEmail_success"
#define NOTIFY_IPHONE_BINDINGEMAIL_FAIL @"iphone_bindingEmail_fail"
#define NOTIFY_IPHONE_SENDPHONEVERIFICATION_SUCCESS @"iphone_sendPhoneVerification_success"
#define NOTIFY_IPHONE_SENDPHONEVERIFICATION_FAIL @"iphone_sendPhoneVerification_fail"
#define NOTIFY_IPHONE_BINDINGPHONE_SUCCESS @"iphone_binDingPhone_success"
#define NOTIFY_IPHONE_BINDINGPHONE_FAIL @"iphone_binDingPhone_fail"
#define NOTIFY_IPHONE_VERIFICATION_ACCOUNT_SUCCESS @"iphone_verification_account_success"
#define NOTIFY_IPHONE_VERIFICATION_ACCOUNT_FAIL @"iphone_verification_account_fail"

#define NOTIFY_IPHONE_MODIFY_USERNICKNAME_SUCCESS @"iphone_modify_usernickName_success"
#define NOTIFY_IPHONE_MODIFY_USERNICKNAME_FAIL @"iphone_modify_usernickName_fail"
#define NOTIFY_IPHONE_MODIFY_USERNICKNAME_REFRESHMESSAGE @"iphone_modify_usernickName_refreshmessage"

#define NOTIFY_REFRESH_VIEW @"iphone_refresh_view"

#define NOTIFY_QUICKSEARCH_BEGINDRAGGING @"QUICKSEARCH_BeginDragging"

#define NOTIFY_LOGINVIEWDISSMISS @"loginviewDismiss"

#define NOTIFY_IS_DOWNLOADVIEW_RESHOW @"is_downloadView_reshow"

#define NOTIFY_HD_TO_LOGIN_PAGE @"hd_to_login_page"

#define NOTIFY_PLAYMODE_CHANGED @"playmode_changed"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPadRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(2048, 1536), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define DEV_SCREEN_HEIGHT (int)([UIScreen mainScreen].bounds.size.height)

#define DEV_SCREEN_WIDTH (int)([UIScreen mainScreen].bounds.size.width)
#define HEIGHT_ADD (int)([UIScreen mainScreen].bounds.size.height-480)

#define SEND_PLAY_LOG_DURATION    20 //超过这个时间发送播放记录

#define SHARE_SONG_TABEL    @"ShareSong"
#define SHARE_SONG_DIR  @"Documents/ShareSongs"

#define DOWN_TARGET_DIR     @"kgmusic"
#define DOWN_MV_DIR         @"kgmv"
#define DOWN_TEMP_DIR       @"kgtemp"
#define CACHE_TARGET_DIR    @"kgcache"
#define SHARE_SONG_SAVE_DIR  @"ShareSongs"
#define DOWN_OFFLINE_TARGET_DIR @"kgofflinemusic"

#define OFFLINE_DOWN_TARGET_DIR     @"kgofflinemusic" // 离线文件夹
#define OFFLINE_DOWN_TEMP_DIR       @"kgofflinetemp"  // 离线缓存文件夹


#define UserDefineThemeBackImageName @"userdefinethemebackimagename"

#define WebPageUrlHashSuffix @"kugouvote2014" // iPhone客户端访问内嵌页增加发送加密串 加密后缀

#define UPDATE_PLAYVIEWLYRIC_CONTENT  @"UPDATE_PLAYVIEWLYRIC_CONTENT" //用户选择了新的预览歌词

#define NOTIFY_WIFIONLY_CANCEL_CLICKED @"offline_wifionly_clicked"  //仅wifi联网弹框点击了取消按钮
#define NOTIFY_WIFIONLY_OK_CLICKED  @"offline_wifionly_ok_clicked"  //仅wifi联网弹框点击了确定按钮

#define NOTIFY_EFFECT_STATE_CHANGE @"effect_state_change_notify" //音效变更
