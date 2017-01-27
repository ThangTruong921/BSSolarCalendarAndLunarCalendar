//
//  SunLunar.h
//  NotePro
//
//  Created by Nguyen Van Toan on 28/06/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TietKhiModel.h"

#define         TYS             @"Tý";
#define         SUU             @"Sửu";
#define         DAN             @"Dần";
#define         MAO             @"Mão";
#define         THIN            @"Thìn";
#define         TYJ             @"Ty.";
#define         NGO             @"Ngọ";
#define         MUI             @"Mùi";
#define         THAN            @"Thân";
#define         DAU             @"Dậu";
#define         TUAT            @"Tuất";
#define         HOI             @"Hợi";

#define PI M_PI

typedef struct
{
    int day;
    int month;
    int year;
    int hour;
    int minute;
    int namNhuan;
} TimeSL;


typedef struct
{
  __unsafe_unretained  NSString *tietkhi;
  __unsafe_unretained  NSString *nghia;
} TietKhi;


@interface SunLunar : NSObject

// Convert Sun calendar to Lunar
- (TimeSL) convertSunToLunar:(TimeSL)date timeZone:(int)timeZone;

// Convert Sun calendar to Lunar
- (TimeSL) convertSunToLunar:(int)day month:(int)month year:(int)year timeZone:(int)timeZone;

// Convert Lunar to Sun calendar
- (TimeSL) convertLunarToSun:(TimeSL)date timeZone:(int)timeZone;

// Convert Lunar to Sun calendar
- (TimeSL) convertLunarToSun:(int)day month:(int)month year:(int)year lunarLeap:(int)lunarLeap timeZone:(int)timeZone;

// Get Date Components
- (TimeSL) getDateComponentsBy:(NSDate*)date;

// Get Today
- (TimeSL) getToday;

// Get Next Day
- (TimeSL) getPreviousDayBy:(NSDate*)date;

// Get Next Day
- (TimeSL) getPreviousDayBy:(int)day month:(int)month year:(int)year;

// Get Next Day
- (TimeSL) getNextDayBy:(NSDate*)date;

// Get Next Day
- (TimeSL) getNextDayBy:(int)day month:(int)month year:(int)year;

// Get count day of a Month
- (int) getNumberDayOfMonth:(int)month year:(int)year;

// get NSDate by Time separated numbers
- (NSDate*) getDateTimeBy:(int)day month:(int)month year:(int)year hour:(int)hour minute:(int)minute second:(int)second;

// Get Day of Week, Sunday = 1
- (int) getWeekDayBy:(int)day month:(int)month year:(int)year;

// Get Day of Week, Sunday = 1
- (int) getWeekDayBy:(NSDate*)date;

// Get Week of Year,
- (int) getYearWeekBy:(int)day month:(int)month year:(int)year;

// get Week of Year,
- (int) getYearWeekBy:(NSDate*)date;

// Get Day of Year,
- (int) getYearDayBy:(int)day month:(int)month year:(int)year;

// get Day of Year
- (int) getYearDayBy:(NSDate*)date;

// Get Week of Month,
- (int) getMonthWeekBy:(int)day month:(int)month year:(int)year;

// get Week of Month,
- (int) getMonthWeekBy:(NSDate*)date;

// Add some days to a day
- (TimeSL) addSomeDaysTo:(int)day month:(int)month year:(int)year addDays:(int)addDays;

// Add some days to a day
- (TimeSL) addSomeDaysTo:(TimeSL)day addDays:(int)addDays;

// Add some Months to a Date
- (TimeSL) addSomeMonthsTo:(TimeSL)day addMonths:(int)addMonths;

// Add some Months to a Date
- (TimeSL) addSomeMonthsTo:(int)month year:(int)year addMonths:(int)addMonths;

// Get Current Local TimeZone
- (int) getLocalTimeZoneNumber;

// Get Lunar Next Day from Lunar day
- (TimeSL) getLunarNextDay:(int)day month:(int)month year:(int)year;

// Get Lunar Previous Day from Lunar day
- (TimeSL) getLunarPreviousDay:(int)day month:(int)month year:(int)year;

// Get Leap From Sun Date
- (int) getLunarLeapFromSunDate:(int)day month:(int)month year:(int)year timeZone:(int)timeZone;

- (int) getSunLongitude:(CGFloat)jdn timeZone:(int)timeZone;

- (long) jdFromDate:(int)day month:(int)month year:(int)year;

-(NSString *)calculatorNgayThutoDate:(int )d andMonth:(int)m andYear:(int)y;

-(NSString *)calculatorCantoDate:(int )d andMonth:(int)m andYear:(int)y;

-(NSString *)calculatorChitoDate:(int )d andMonth:(int)m andYear:(int)y;

-(NSString *)calculatorCANtoMonth:(int)m andYear:(int)y;

-(NSString *)calculatorCHItoMonth:(int)m;

-(NSString *)calculatorCANtoYear:(int)y;

-(NSString *)calculatorCHItoYear:(int)y;

-(NSString *)calculatorGioCanChifromGio:(int)hh andPhut:(int)mm;

- (NSString *)ngayLeAL: (int)ngay thang:(int)thang;

- (NSString *)ngayLeDL :(int )ngay thang:(int )thang;

- (BOOL )comepareDate:(int)day andMonth:(int)month anddayStart:(int)dayStart andmonthStart:(int)monthStart anddayEnd:(int)dayEnd andmonthEnd:(int)monthEnd andyear:(int)year;

//- (TietKhi *)getTietKhi:(int )ngay thang:(int )thang nam:(int )nam;

-(NSString *) checkNamNhuan:(int)y;

- (long) getLunarMonth11:(int)year timeZone:(int)timeZone;

- (int) getLeapMonthOffset:(CGFloat)a11 timeZone:(int)timeZone;

- (NSString *)calculatorHyThan:(int )d andMonth:(int)m andYear:(int)y;

- (NSString *)calculatorTaiThan:(int)d andMonth:(int)m andYear:(int)y;

- (long )getMonthNhuan:(int)day month:(int)month year:(int)year lunarLeap:(int)lunarLeap timeZone:(int)timeZone;

- (NSString *)getTietKhiSunLong:(int )d andMonth:(int)m andYear:(int)y;

- (StarModel *)getSao:(int)d andMonth:(int)m andYear:(int)y;

- (BOOL)isHoangDao:(NSInteger)thangAL andNgayChi:(NSString*)ngayChi;

- (BOOL)isHacDao:(NSInteger)thangAL andNgayChi:(NSString*)ngayChi;

- (NSString *)getViecLam:(int )x;

- (int)getSao:(int )x;

- (BOOL )calculatorNamNhuan:(int)y;

- (int)getThangNhuan:(int)day month:(int)month year:(int)year lunarLeap:(int)lunarLeap timeZone:(int)timeZone;

- (NSMutableArray *)getAllLunarDaysInSolarMonth:(int)solar_dd solar_mm:(int)solar_mm solar_yy:(int)solar_yy ;

-(NSMutableArray *)getAllLunarDaysInLunarMonth:(int)lunar_mm solar_mm:(int)lunar_yy solar_yy:(int)lunar_leap;

- (TietKhiModel *)getTietKhi:(int)day month:(int)month year:(int)year;

- (NSString *)tinhNgayTotXau:(int )x andCheck:(int)check;

- (NSString *)convertSaotoText:(int)x andCheck:(int)check;

- (int )getThu:(int )d andMonth:(int)m andYear:(int)y;

- (NSInteger )getDayFromDate:(NSDate *)date;

- (int) getSunLongitudeTietKhi:(CGFloat )jdn timeZone:(int)timeZone;

@end
