//
//  LoginData.h
//  SameCity
//
//  Created by zengchao on 14-6-3.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "HttpService.h"
#import "JSONModel.h"

@interface RegiserItem :JSONModel

@property (nonatomic ,retain) NSString *Name;

@property (nonatomic ,retain) NSString *Email;

@property (nonatomic ,retain) NSString *IC;

@property (nonatomic ,retain) NSString *Phone;

@property (nonatomic ,retain) NSString *QQSkype;

@property (nonatomic ,retain) NSString *Password;

@property (nonatomic ,retain) NSString *MemType;

@property (nonatomic ,retain) NSString *City;

@end

@interface MemberData : HttpService

@property (nonatomic ,retain) NSString *deviceToken;

- (void)loginEmail:(NSString *)email andPassword:(NSString *)password;

- (void)regiserEmail:(RegiserItem *)registerItem;

- (void)getMemberDetail:(NSString *)userID;

- (void)updatePassword:(NSString *)newPassword;

- (void)updatePassword:(NSString *)newPassword andOldPassword:(NSString *)oldPassword;

- (void)checkHasAdmin:(NSString *)city;

- (void)bockUser:(NSString *)uid;

- (void)cancelBockUser:(NSString *)uid;

- (void)getMemberListByCity:(NSString *)city;

- (void)updateMemberDetailwithName:(NSString *)name withPhone:(NSString *)phone withQQSkype:(NSString *)qq withMemType:(NSString *)memType withDeviceToken:(NSString *)deviceToken;

@end
