//
//  DZWeatherTests.m
//  DZWeatherTests
//
//  Created by Ibokan on 15/11/16.
//  Copyright (c) 2015年 Zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Area.h"
#import "AreaFatory.h"
#import "TestDayWeather.h"



@interface DZWeatherTests : XCTestCase
{
    NSArray* searchKeyList;
    NSArray* testKeyList;
    NSMutableArray* testArray;
    NSString* encodePath;
}
@end

@implementation DZWeatherTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //searchKeyList = @[@"北",@"广",@"河"];
    testKeyList = @[@"北京",@"番禺",@"广元",@"上海",@"金湾",@"广州",@"哈尔滨"];
    testArray = [NSMutableArray new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
}

- (void)testExample {
    // This is an example of a functional test case.
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
