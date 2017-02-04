//
//  ApiRequest.h
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiRequest : NSObject

@property (strong, nonatomic) NSString *URL;
@property (strong, nonatomic) NSString *httpMethod;
@property (strong, nonatomic) NSDictionary *parameters;
@property (nonatomic, copy) void (^successHandler)(NSDictionary *jsonDictionary);
@property (nonatomic, copy) void (^failHandler)(NSString *error);

- (instancetype) initWithUrl: (NSString *)url
               andHttpMethod: (NSString *)httpMethod
              withParameters: (NSDictionary *)parameters
              successHandler: (void(^) (NSDictionary *))success
                 failHandler: (void(^) (NSString *))fail;

-(void) execute;

@end
