//
//  UtilsTest.m
//  How Is Underground
//
//  Created by Hooman Ostovari on 18/03/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UtilsTest : XCTestCase

@end

@implementation UtilsTest

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Test localized dates

- (void) testLocalizeYear
{
    NSString* formattedYear = [Utils localizeDateWithYear:2013];
    NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages][0]];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedYear, @"2013");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedYear, @"٢٠١٣");
    } else {
        XCTAssertTrue(true);
    }
}

-(void) testLocalizedDateWithYearAndMonth
{
    NSString* formattedYear = [Utils localizeDateWithYear:2013 month:2];
    NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages][0]];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedYear, @"2013-02");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedYear, @"٢٠١٣-٠٢");
    } else {
        XCTAssertTrue(true);
    }
    
    formattedYear = [Utils localizeDateWithYear:2013 month:90];
    direction = [NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages][0]];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedYear, @"2020-06");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedYear, @"٢٠٢٠-٠٦");
    } else {
        XCTAssertTrue(true);
    }
}

-(void) testLocalizedDateWithYearAndMonthAndDay
{
    NSString* formattedYear = [Utils localizeDateWithYear:2013 month:2 day:20];
    NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages][0]];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedYear, @"2013-02-20");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedYear, @"٢٠١٣-٠٢-٢٠");
    } else {
        XCTAssertTrue(true);
    }
    
    formattedYear = [Utils localizeDateWithYear:2013 month:4 day:100];
    direction = [NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages][0]];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedYear, @"2013-07-09");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedYear, @"٢٠١٣-٠٧-٠٩");
    } else {
        XCTAssertTrue(true);
    }

}


#pragma mark - Test localizedDobules

- (void)testLocalizeDouble
{
    NSString* formattedDouble = [Utils localizeDouble:2012.34];
    NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages][0]];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedDouble, @"2,012.34");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedDouble, @"٢٠١٢٫٣٤");
    } else {
        XCTAssertTrue(true);
    }
    formattedDouble = [Utils localizeDouble:0.349382847824];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedDouble, @"0.35");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedDouble, @"٠٫٣٥");
    } else {
        XCTAssertTrue(true);
    }
    
    formattedDouble = [Utils localizeDouble:0];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedDouble, @"0");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedDouble, @"٠");
    } else {
        XCTAssertTrue(true);
    }


}

- (void)testLocalizeDoubleThreeFloatingPoint
{
    NSString* formattedDouble = [Utils localizeDouble:0.347682847824 precision:3];
    NSLocaleLanguageDirection direction = [NSLocale characterDirectionForLanguage:[NSLocale preferredLanguages][0]];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedDouble, @"0.348");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedDouble, @"٠٫٣٤٨");
    } else {
        XCTAssertTrue(true);
    }
    
    formattedDouble = [Utils localizeDouble:2342424.1 precision:3];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedDouble, @"2,342,424.1");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedDouble, @"٢٣٤٢٤٢٤٫١");
    } else {
        XCTAssertTrue(true);
    }
    
    formattedDouble = [Utils localizeDouble:0.0f precision:3];
    if ( direction == NSLocaleLanguageDirectionLeftToRight) {
        XCTAssertEqualObjects(formattedDouble, @"0");
    } else if (direction == NSLocaleLanguageDirectionRightToLeft) {
        XCTAssertEqualObjects(formattedDouble, @"٠");
    } else {
        XCTAssertTrue(true);
    }
}
@end
