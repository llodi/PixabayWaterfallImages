//
//  ApiRequest.m
//  WaterfallImages
//
//  Created by Ilya on 26.01.17.
//  Copyright © 2017 llodi. All rights reserved.
//

#import "ApiRequest.h"
#import "NSString+HttpUtils.h"
#import "NSDictionary+HttpHelper.h"

@interface ApiRequest()

@end

@implementation ApiRequest

- (instancetype) initWithUrl: (NSString *)url
               andHttpMethod: (NSString *)httpMethod
              withParameters: (NSDictionary *)parameters
              successHandler: (void(^) (NSDictionary *))success
              failHandler: (void(^) (NSString *))fail
{
    
    self = [super init];
    
    if(self) {
        _URL = url;
        _httpMethod = httpMethod;
        _parameters = parameters;
        _successHandler = success;
        _failHandler = fail;
    }
    
    return self;
}

-(void) execute {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = _httpMethod;
    
    NSString *requestURLString = _URL;
    if (!requestURLString) {
        NSLog(@"No url set for Api Request");
        _failHandler(@"No url set for Api Request");
        return;
    }
    
    if ([[self httpMethod]  isEqual: @"GET"]) {
        if ([self parameters]) {
            NSString *stringParams = [[self parameters] stringFromHttpParameters];
            NSString *requestUrlString = [NSString stringWithFormat:@"%@?%@",requestURLString,stringParams];
            NSURL *requestUrl = [[NSURL alloc] initWithString:requestUrlString];
            if (requestUrl) {
                request.URL = requestUrl;
            } else {
                return;
            }
        } else {
            NSURL *requestUrl = [[NSURL alloc] initWithString:requestURLString];
            request.URL = requestUrl;
        }
    } else {
        if ([self parameters]) {
            NSURL *requestUrl = [[NSURL alloc] initWithString:requestURLString];
            request.URL = requestUrl;
            
            NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithDictionary:[self parameters]];
            @try {
                NSError *err = nil;
                NSData *data = [NSJSONSerialization dataWithJSONObject:mutableDict options:NSJSONWritingPrettyPrinted error: &err];
                
                if (!data) {
                    NSLog(@"Error parsing JSON: %@", err);
                    _failHandler(err.localizedDescription);
                } else {
                    NSString *parameterValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSString *parameterNameWithValue = [parameterValue URLEncoded];
                    request.HTTPBody = [parameterNameWithValue dataUsingEncoding:NSUTF8StringEncoding];
                    
                }
            } @catch (NSException *error) {
                NSLog(@"Failed serializing parameters: %@", error.description);
            }
        } else {
            NSLog(@"Non-GET requests without parameters not supported");
            _failHandler(@"Non-GET requests without parameters not supported");
            return;
        }
    }
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error parsing JSON: %@", error.localizedDescription);
            _failHandler(error.localizedDescription);
            return;
        }
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if (!httpResponse) {
            _failHandler(@"Cannot connect to server");
            return;
        }
        
        if (httpResponse.statusCode == 200) {
            NSDictionary *jsonData = [self parseJSONData:data];
            if (jsonData) {
                _successHandler(jsonData);
            }
        } else {
            _failHandler([NSString stringWithFormat:@"Error from server- Status Code:  %ld",(long)httpResponse.statusCode]);
        }
    }];
    
    [task resume];
}

- (NSDictionary *) parseJSONData: (NSData*) data {
    @try {
        NSError *jsonError;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];
        if (jsonError != nil) {
            NSLog(@"Error parsing JSON: %@", jsonError);
            _failHandler(jsonError.localizedDescription);
            return nil;
        }
        if (json) {
            return json;
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Error parsing JSON: %@", jsonString);
            _failHandler(jsonString);
            return nil;
        }
    } @catch (NSException *error) {
        NSLog(@"Failed serializing parameters: %@", error.description);
    }
}

@end
