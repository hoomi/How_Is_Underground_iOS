//
//  Utils.m
//  CarValet
//
//  Created by Hooman Ostovari on 21/02/2014.
//  Copyright (c) 2014 Hooman Ostovari. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)localizeDouble:(double)dobuleValue
{
    return [self localizeDouble:dobuleValue precision:2];
}

+ (NSString *)localizeDouble:(double)dobuleValue precision:(NSInteger) precision
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.locale = [NSLocale currentLocale];
    [numberFormatter setMaximumFractionDigits:precision];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:dobuleValue]];
}

+ (NSString *)localizeLong:(long)longValue
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.locale = [NSLocale currentLocale];
    return [numberFormatter stringFromNumber:[NSNumber numberWithLong:longValue]];
}


+ (NSString *)localizeDateWithYear:(long)year month:(NSInteger)month day:(NSInteger)day format:(NSString*) format
{
    NSDateComponents *dateComponent = [[NSDateComponents alloc] init];
    [dateComponent setYear:year];
    [dateComponent setMonth:month];
    [dateComponent setDay:day];
    NSDate *date = [[NSCalendar currentCalendar]dateFromComponents:dateComponent];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:format options:0 locale:nil]];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)localizeDateWithYear:(long)year month:(NSInteger)month day:(NSInteger)day
{
    return [Utils localizeDateWithYear:year month:month day:day format:@"YYYY-MM-dd"];
}

+ (NSString *)localizeDateWithYear:(long)year month:(NSInteger)month
{
    return [Utils localizeDateWithYear:year month:month day:1 format:@"YYYY-MM"];
}

+ (NSString *)localizeDateWithYear:(long)year
{
    return [Utils localizeDateWithYear:year month:1 day:1 format:@"YYYY"];
}

+(NSInteger)getYearFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:date];
    return dateComponents.year;
}




@end

