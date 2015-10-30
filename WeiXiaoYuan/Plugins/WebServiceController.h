//
//  WebServiceController+WebServiceController.h
//  WeiXiaoYuan
//
//  Created by 姚振兴 on 14/11/2.
//
//
typedef enum{
    GETSERVERADDR,
    LOGIN,
    Other
}METHOD_TYPE;
@protocol HttpCallbackDelegate

-(void)HttpSuccessCallBack:(NSString *)result;
-(void)HttpFailCallBack:(NSString *)errorMessage;
-(void)HttpSuccessDictionaryCallBack:(NSString *)result;
@end
typedef void (^successDictionaryBlock) (NSDictionary *responseDic);
@interface WebServiceController:NSObject
{
@private
    NSXMLParser *xmlParser;
    BOOL isReturnFlag;
    NSMutableString *tempString;
    UIView *currentView;
    NSString *appServiceUrl;
    successDictionaryBlock successDicBlock;
    id<HttpCallbackDelegate> delegate;
    NSString *name;
    NSString *password;
}
- (void)SetDalegate:id;
- (void)SendHttpRequestWithMethod:(NSString*)methodName argsDic:(NSDictionary*)argsDic success:(successDictionaryBlock)successBlock;
+ (WebServiceController*)shareController:(UIView*)view;

//Login
- (void)GetServerAddr:(NSString*)userID:(NSString*)passWord;
- (void)Login:(NSString*)userID:(NSString*)passWord;
- (NSString*)setChannel:(NSString*)channelid:(NSString*)baiduUserId;

//JsInstance
//校长使用
- (NSString*)SchoolsOfUser;
- (NSString*)getFirstGroupOfUser;
- (NSString*)getChildren;
- (NSString*)studentinfo:(NSString*)param;
- (NSString*)getFirstClassOfUser;
- (NSString*)getUserId;
-(NSString*)getClassesOfUser;
-(NSString*)getGroupsOfUser;
-(NSString*)getStudentByGroup:(NSString*)group_id;



//- (void)UserGetSchools:(NSString*)userID;
//- (void)GradesOfSchool:(NSString*)groupID;
//- (void)ClassesOfGrade:(NSString*)groupID;
//- (void)ClassesOfSchool:(NSString*)groupID;

//SchoolSummary
- (NSString*)Schoolintroduce:(NSString*)groupID;
- (NSString*)teachersintroduce:(NSString*)groupID;
- (NSString*)honerintroduce:(NSString*)groupID;
- (NSString*)recruitstudentslist:(NSString*)groupID;
- (NSString*)recruitstudentsinfo:(NSString*)groupID;
- (NSString*)dynamiclist:(NSString*)groupID;
- (NSString*)dynamicinfo:(NSString*)groupID;

//Attendance
- (NSString*)todayAttendance:(NSString*)param :(NSString*)param1;
- (NSString*)todayChildrenAttendance;
- (NSString*)searchAttendanceforstudents:(NSString*)groupId:(NSString*)studentNumber:(NSString*)studentName:(NSString*)attendanceType:(NSString*)xjh:(NSString*)beginDate:(NSString*)endDate;
- (NSString*)searchAttendanceForParent:(NSString*)student_id:(NSString*)attendanceType:(NSString*)beginDate:(NSString*)endDate;
- (NSString*)historyAttendance:(NSString*)group_id:(NSString*)cycle_code;
- (NSString*)todayAttendanceforstudents:(NSString*)group_id:(NSString*)attendanceType;
- (NSString*)vacationlist;
- (NSString*)getVacation_id;
- (NSString*)vacationinfo:(NSString*)vacation_id;
- (NSString*)vacationaudit:(NSString*)vacation_id:(NSString*)auditflag;
- (NSString*)vacationadd:(NSString*)student_id:(NSString*)start_date:(NSString*)start_time:(NSString*)end_date:(NSString*)end_time:(NSString*)reason;

//BodyTemp
- (NSString*)getBodyTemperaturesForParent:(NSString*)student_id: (NSString*)search_date;
- (NSString*)getBodyTemperatures:(NSString*)student_id: (NSString*)search_date;
- (NSString*)bodyTemperatureTrade:(NSString*)student_id;
- (NSString*)bodyTemperatureTradeParent;
- (NSString*)getAlarmBodyTemperatures:(NSString*)search_date;

//HomeWork
- (NSString*)lessonlist:(NSString*)group_id;
- (NSString*)homeworkPublish:(NSString*)group_id:(NSString*)lesson_id:(NSString*)homework_content:(NSString*)edit_date:(NSString*)imgPath;
- (NSString*)homeworksearch:(NSString*)groupId:(NSString*)esson_id:(NSString*)beginDate:(NSString*)endDate;
- (NSString*)homeworkinfo:(NSString*)homework_id;
- (NSString*)lessonlistForParent:(NSString*)group_id;
- (NSString*)todayChildrenHomework;

//Notify
- (NSString*)noticeadd:(NSString*)group_id:(NSString*)rangeValue:(NSString*)title:(NSString*)notice_info:(NSString*)imgPath;
- (NSString*)noticeinfo:notice_id;
- (NSString*)noticelist;

//FestivalGreeting
- (NSString*)jrzfinfo:jrzf_id;
- (NSString*)jrzflist;
- (NSString*)getUserSchoolAndName;
- (NSString*)hkList;
- (NSString*)jrzfadd:object:content:inscribe:rangeValue:greetingCard;

//BirthdayBlessing
-(NSString*)srzflist;
-(NSString*)srzfadd:(NSString*)student_id:(NSString*)student_name:(NSString*)birthday;
-(NSString*)srzftx;

//StudentManagement
-(NSString*)getStudents:(NSString*)group_id;
-(NSString*)searchStudents:(NSString*)group_id:(NSString*)studentName:(NSString*)xjh:(NSString*)studentNumber;
-(NSString*)studenttj:(NSString*)group_id:(NSString*)type;
-(NSString*)showInfo:(NSString*)Id;

//Teach
-(NSString*)getSemesterList:(NSString*)group_id;
-(NSString*)getSchedule:(NSString*)group_id:(NSString*)xq_id;
-(NSString*)teacherList:(NSString*)group_id;

//Score
-(NSString*)ksList:(NSString*)student_id;
-(NSString*)ksLessonListforGroup:(NSString*)group_id;
-(NSString*)getExaminationSubject:(NSString*)student_id;
-(NSString*)groupScoreFenxi:(NSString*)group_id:(NSString*)lesson;
-(NSString*)getWidth;
-(NSString*)getHeight;
-(NSString*)studentScoreFenxi:(NSString*)student_id:(NSString*)lesson;
-(NSString*)scoreInquiry:(NSString*)student_id:(NSString*)record_name;

//Health
- (NSString*)getExaminationTrade:(NSString*)student_id:(NSString*)examination_type;
- (NSString*)getExaminationDates:(NSString*)group_id;
- (NSString*)getExaminationRecords:(NSString*)group_id:(NSString*)search_date;
- (NSString*)getExaminationDatesForParent:(NSString*)student_id;
- (NSString*)getExaminationRecordsForParent:(NSString*)student_id:(NSString*)search_date;
- (NSString*)getExaminationType;

//GrowthTree
- (NSString*)getgrowtreepic:(NSString*)student_id;
- (NSString*)addgrowtree:(NSString*)student_id:(NSString*)title:(NSString*)content:(NSString*)treeDate:(NSString*)address:(NSString*)imgPath;
- (NSString*)getgrowtreeidallpic:(NSString*)studentId:(NSString*)treeId;
- (NSString*)addgrowtreepic:(NSString*)studentId:(NSString*)treeId:(NSString*)imgPath;

//Feedback
-(NSString*)feedbackadd:(NSString*)student_id:(NSString*)type:(NSString*)feedback_info;
-(NSString*)feedbackinfo:(NSString*)feedback_id;
-(NSString*)feedbackreply:(NSString*)feedback_id:(NSString*)content;
-(NSString*)feedbacklist;

-(NSString*)updatePassword:(NSString*)oldPassword:(NSString*)newPassword;

//查看推送给自己的消息
-(NSString*)xxrecordlist;
//标记消息未已读
-(NSString*)updatexxrecord:(NSString*)messageID;

//获取logo和学校名字
-(NSString*)getLogoAndSchoolName;
@end
