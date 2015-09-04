//
//  LoginData.m
//  SameCity
//
//  Created by zengchao on 14-6-3.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "MemberData.h"
#import "UserLogin.h"
#import "MemberItem.h"

@implementation RegiserItem

- (void)dealloc
{
    RELEASE_SAFELY(_Email);
    RELEASE_SAFELY(_Name);
    RELEASE_SAFELY(_Password);
    RELEASE_SAFELY(_Phone);
    RELEASE_SAFELY(_QQSkype);
    RELEASE_SAFELY(_IC);
    RELEASE_SAFELY(_MemType);
    RELEASE_SAFELY(_City);
    
    [super dealloc];
}

@end

@implementation MemberData

- (id)init
{
    if (self = [super init]) {
   
        self.deviceToken = @"";
    }
    return self;
}


- (void)loginEmail:(NSString *)email andPassword:(NSString *)password
{
    self.tag = LOGIN_DATA_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [params addObject:email forKey:@"Email"];
    [params addObject:[password MD5Sum] forKey:@"Password"];
    
    [self GetAsync:combineStr(LOGIN_SERVICE_URL, POST_LOGIN_URL) andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)regiserEmail:(RegiserItem *)registerItem
{
    self.tag = REGISTER_DATA_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
    [params addEntriesFromDictionary:[registerItem toDictionary]];
    [params addObject:self.deviceToken forKey:@"DeviceToken"];

    
    [self PostAsync:combineStr(LOGIN_SERVICE_URL, POST_REGISTER_URL) andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)getMemberDetail:(NSString *)userID
{
    self.tag = MEMBER_DETIAL_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];

    [params addObject:userID forKey:@"ID"];
    
    [self PostAsync:combineStr(LOGIN_SERVICE_URL, GET_MEMBER_DETAIL_URL) andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)updatePassword:(NSString *)newPassword
{
    self.tag = MEMBER_PASSWORD_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    [params addObject:[UserLogin instanse].uid forKey:@"ID"];
    [params addObject:[newPassword MD5Sum] forKey:@"Password"];
    
    [self PostAsync:combineStr(LOGIN_SERVICE_URL, POST_PASSWORD_URL) andParams:params Success:^(NSObject *response) {
        //
        
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)updatePassword:(NSString *)newPassword andOldPassword:(NSString *)oldPassword
{
    self.tag = MEMBER_PASSWORD_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [params addObject:[UserLogin instanse].uid forKey:@"ID"];
    [params addObject:[newPassword MD5Sum] forKey:@"Password"];
    [params addObject:[oldPassword MD5Sum] forKey:@"OldPassword"];
    
    [self PostAsync:combineStr(LOGIN_SERVICE_URL, @"ChangePasswordWithOldPassword") andParams:params Success:^(NSObject *response) {
        //
        
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)checkHasAdmin:(NSString *)city;
{

    self.tag = MEMBER_CHECK_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params addObject:city forKey:@"City"];

    [self GetAsync:combineStr(LOGIN_SERVICE_URL, GET_HAS_ADMIN_URL) andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)bockUser:(NSString *)uid
{
    self.tag = MEMBER_BOCK_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params addObject:uid forKey:@"ID"];
    
    [self GetAsync:combineStr(LOGIN_SERVICE_URL, POST_BOCK_MEMBER_URL) andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)cancelBockUser:(NSString *)uid
{
    self.tag = MEMBER_UNBOCK_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params addObject:uid forKey:@"ID"];
    [params addObject:@"1" forKey:@"MemType"];
    
    [self GetAsync:combineStr(LOGIN_SERVICE_URL, @"changeMemberType") andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)getMemberListByCity:(NSString *)city
{
    self.tag = MEMBER_CITYLIST_TAG;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params addObject:city forKey:@"City"];
    
    [self GetAsync:combineStr(LOGIN_SERVICE_URL, GET_CITY_USERS_MEMBER_URL) andParams:params Success:^(NSObject *response) {
        //
        NSMutableArray *items = [NSMutableArray array];
        
        if (response && [response isKindOfClass:[NSArray class]]) {
            for (NSDictionary *tmpDic in (NSArray *)response) {
                MemberItem *indexDto = [[MemberItem alloc] initWithDictionary:tmpDic error:nil];
                if (indexDto) {
                    [items addObject:indexDto];
                }
                RELEASE_SAFELY(indexDto);
            }
        }
        
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:items];
        }
        
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

- (void)updateMemberDetailwithName:(NSString *)name withPhone:(NSString *)phone withQQSkype:(NSString *)qq withMemType:(NSString *)memType withDeviceToken:(NSString *)deviceToken
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];

    [params addObject:[UserLogin instanse].uid forKey:@"ID"];
    [params addObject:name forKey:@"Name"];
    
    if (!isNull(qq)) {
        [params addObject:qq forKey:@"QQSkype"];
    }
    else {
        [params addObject:@"" forKey:@"QQSkype"];
    }
  
    if (!isNull(phone)) {
        [params addObject:phone forKey:@"Phone"];
    }
    else {
        [params addObject:@"" forKey:@"Phone"];
    }
    
    if (!isNull(memType)) {
        [params addObject:memType forKey:@"MemType"];
    }
    else {
        [params addObject:@"" forKey:@"MemType"];
    }

    [params addObject:@"" forKey:@"DeviceToken"];
    
    [self PostAsync:combineStr(LOGIN_SERVICE_URL, POST_UPDATE_MEMBER_URL) andParams:params Success:^(NSObject *response) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Succeed:)]) {
            [self.delegate httpService:self Succeed:response];
        }
        
    } falure:^(NSError *error) {
        //
        if ( self.delegate && [ self.delegate respondsToSelector:@selector(httpService:Failed:)]) {
            [self.delegate httpService:self Failed:error];
        }
    }];
}

@end
