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

+(NSString *)formatDate:(NSDate *)date
{
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"E, dd MMM YYYY HH:mm:ss z" options:0
                                                              locale:[NSLocale currentLocale]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatString];
    NSString* formattedString = [dateFormatter stringFromDate:date];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@" [AaPp][Mm] " options:NSRegularExpressionCaseInsensitive error:&error];
    if (error != nil) {
        [NSLogger log:[error localizedDescription]];
    }
    NSString *modifiedString = [regex stringByReplacingMatchesInString:formattedString options:0 range:NSMakeRange(0, [formattedString length] - 1) withTemplate:@" "];
    return modifiedString;
}

#pragma mark - TableView Utils
+(NSInteger)indexFrom:(NSIndexPath *)indexPath :(UITableView *)tableView
{
    if (tableView == nil || indexPath == nil) {
        return 0;
    }
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSInteger index = 0;
    for (NSInteger i = 0; i<section; i++) {
        index += [tableView numberOfRowsInSection:i];
    }
    index = index > 0 ? index - 1 : index;
    
    return index + row;
}

+ (NSIndexPath*)indexPathOf:(NSInteger) index :(UITableView*) tableView{
    NSInteger section  = 0;
    NSInteger row = 0;
    NSInteger maxSection = [tableView numberOfSections] - 1;
    NSInteger maxRows = [tableView numberOfRowsInSection:section];
    NSInteger totalRows = [self numberOfRowsInTotal:tableView];
    if (maxSection == 0) {
        row = index % maxRows;
    } else {
        for (NSInteger i = maxSection; i >= 0; i--) {
            totalRows = totalRows - [tableView numberOfRowsInSection:i];
            if (index > totalRows) {
                section = i;
                row = index-totalRows;
                break;
            }
        }
    }
    return [NSIndexPath indexPathForRow:row inSection:section];
}

+ (NSInteger)numberOfRowsInTotal :(UITableView*) tableView{
    NSInteger sections = [tableView numberOfSections];
    NSInteger cellCount = 0;
    for (NSInteger i = 0; i < sections; i++) {
        cellCount += [tableView numberOfRowsInSection:i];
    }
    return cellCount;
}




@end

