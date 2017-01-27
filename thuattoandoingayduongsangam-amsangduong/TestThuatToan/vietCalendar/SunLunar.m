//
//  SunLunar.m
//  NotePro
//
//  Created by Nguyen Van Toan on 28/06/2013.
//  Copyright (c) 2013 Horical. All rights reserved.
//

#import "SunLunar.h"


@implementation SunLunar

- (id) init
{
    self = [super init];
    
    //[self test];
    return self;
}

- (void) test
{
    TimeSL t = [self convertSunToLunar:29 month:6 year:2013 timeZone:[self getLocalTimeZoneNumber]];
    NSLog(@"Lunar day : %d %d %d", t.day, t.month, t.year);
    
    t = [self convertLunarToSun:5 month:5 year:t.year lunarLeap:1 timeZone:[self getLocalTimeZoneNumber]];
    NSLog(@"Sun day : %d %d %d", t.day, t.month, t.year);
    
    t = [self getToday];
    NSLog(@"Today : %d %d %d", t.day, t.month, t.year);
    
    for(int i=1; i<37; i++)
    {
        t = [self addSomeMonthsTo:10 year:2013 addMonths:i];
        NSLog(@"Add Months %d, %d/%d", i, t.month, t.year);
    }
    
    for(int i=1; i<37; i++)
    {
        t = [self addSomeMonthsTo:10 year:2013 addMonths:-i];
        NSLog(@"Subtract Months %d, %d/%d", i, t.month, t.year);
    }
    
    for(int i=1; i<367; i++)
    {
        t = [self addSomeDaysTo:1 month:11 year:2013 addDays:i];
        NSLog(@"Add days %d, %d/%d/%d", i, t.day, t.month, t.year);
    }
    
    for(int i=1; i<367; i++)
    {
        t = [self addSomeDaysTo:1 month:11 year:2013 addDays:i];
        NSLog(@"Subtract days %d, %d/%d/%d", i, t.day, t.month, t.year);
    }
}

- (int) getYearWeekBy:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"w"];
    int d = [[df stringFromDate:date] intValue];
    
    return d;
}

- (int) getYearWeekBy:(int)day month:(int)month year:(int)year
{
    return [self getYearWeekBy:[self getDateTimeBy:day month:month year:year hour:0 minute:0 second:0]];
}

- (int) getYearDayBy:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"D"];
    int d = [[df stringFromDate:date] intValue];
    
    return d;
}

- (int) getYearDayBy:(int)day month:(int)month year:(int)year
{
    return [self getYearDayBy:[self getDateTimeBy:day month:month year:year hour:0 minute:0 second:0]];
}

- (int) getMonthWeekBy:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"W"];
    int d = [[df stringFromDate:date] intValue];
    
    return d;
}

- (int) getMonthWeekBy:(int)day month:(int)month year:(int)year
{
    return [self getMonthWeekBy:[self getDateTimeBy:day month:month year:year hour:0 minute:0 second:0]];
}

- (int) getWeekDayBy:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"c"];
    int d = [[df stringFromDate:date] intValue];
    
    return d;
}

- (int) getWeekDayBy:(int)day month:(int)month year:(int)year
{
    return [self getWeekDayBy:[self getDateTimeBy:day month:month year:year hour:0 minute:0 second:0]];
}

- (NSDate*) getDateTimeBy:(int)day month:(int)month year:(int)year hour:(int)hour minute:(int)minute second:(int)second
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"dd:MM:yyyy - HH:mm:ss"];
    NSDate *d = [df dateFromString:[NSString stringWithFormat:@"%d:%d:%d - %d:%d:%d", day, month, year, hour, minute, second]];
    
    return d;
}

- (int) getNumberDayOfMonth:(int)month year:(int)year;
{
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
    {
        return 30;
    }
    else if(month == 2)
    {
        if(year%4)
        {
            return 28;
        }
        
        return 29;
    }
    
    return 31;
}

- (TimeSL) addSomeDaysTo:(TimeSL)day addDays:(int)addDays
{
    return [self addSomeDaysTo:day.day month:day.month year:day.year addDays:addDays];
}

- (TimeSL) addSomeDaysTo:(int)day month:(int)month year:(int)year addDays:(int)addDays
{
    TimeSL t = {day+addDays, month, year};
    
    if(addDays != 0)
    {
        if(addDays > 0)
        {
            int numDayInMonth = [self getNumberDayOfMonth:t.month year:t.year];
            while(t.day > numDayInMonth)
            {
                t.month++;
                if(t.month > 12)
                {
                    t.month -= 12;
                    t.year++;
                }
                
                t.day -= numDayInMonth;
                numDayInMonth = [self getNumberDayOfMonth:t.month year:t.year];
            }
        }
        else
        {
            while(t.day < 1)
            {
                t.month--;
                if(t.month < 1)
                {
                    t.year--;
                    t.month = 12;
                }
                
                int numberInMonth = [self getNumberDayOfMonth:t.month year:t.year];
                t.day += numberInMonth;
            }
        }
    }
    
    return t;
}

- (TimeSL) addSomeMonthsTo:(TimeSL)day addMonths:(int)addMonths
{
    TimeSL t = day;
    int ads = addMonths;
    
    if(ads != 0)
    {
        if(ads > 0)
        {
            t.month += ads;
            t.year += (t.month-1)/12;
            t.month = ((t.month-1)%12)+1;
        }
        else
        {
            t.month += ads;
            
            if(t.month < 1)
            {
                t.year += (t.month/12 - 1);
                t.month = 12 + t.month%12;
            }
        }
    }
    
    return t;
}

- (TimeSL) addSomeMonthsTo:(int)month year:(int)year addMonths:(int)addMonths
{
    TimeSL t = {1, month, year};
    return [self addSomeMonthsTo:t addMonths:addMonths];
}

- (TimeSL) getNextDayBy:(NSDate *)date
{
    TimeSL t = [self getDateComponentsBy:date];
    return [self getNextDayBy:t.day month:t.month year:t.year];
}

- (TimeSL) getNextDayBy:(int)day month:(int)month year:(int)year
{
    TimeSL t = {++day, month, year};
    
    int numDayInMonth = [self getNumberDayOfMonth:t.month year:t.year];
    if(t.day > numDayInMonth)
    {
        t.day -= numDayInMonth;
        t.month++;
    }
    
    if(t.month > 12)
    {
        t.month -= 12;
        t.year++;
    }
    
    return t;
}

- (TimeSL) getPreviousDayBy:(NSDate *)date
{
    TimeSL t = [self getDateComponentsBy:date];
    return [self getPreviousDayBy:t.day month:t.month year:t.year];
}

- (TimeSL) getPreviousDayBy:(int)day month:(int)month year:(int)year
{
    TimeSL t = {--day, month, year};
    
    if(t.day <= 0)
    {
        t = [self addSomeMonthsTo:t addMonths:-1];
        t.day = [self getNumberDayOfMonth:t.month year:t.year];
        
        if(t.month <= 0)
        {
            t.month = 12;
            t.year--;
        }
    }
    
    return t;
}

- (TimeSL) getLunarNextDay:(int)day month:(int)month year:(int)year
{
    TimeSL sDay = [self convertLunarToSun:day month:month year:YES lunarLeap:1 timeZone:[self getLocalTimeZoneNumber]];
    TimeSL sNextDay = [self getNextDayBy:sDay.day month:sDay.month year:sDay.year];
    return [self convertSunToLunar:sNextDay.day month:sNextDay.month year:sNextDay.year timeZone:[self getLocalTimeZoneNumber]];
}

- (TimeSL) getLunarPreviousDay:(int)day month:(int)month year:(int)year
{
    TimeSL sDay = [self convertLunarToSun:day month:month year:YES lunarLeap:1 timeZone:[self getLocalTimeZoneNumber]];
    TimeSL sNextDay = [self getPreviousDayBy:sDay.day month:sDay.month year:sDay.year];
    return [self convertSunToLunar:sNextDay.day month:sNextDay.month year:sNextDay.year timeZone:[self getLocalTimeZoneNumber]];
}

- (TimeSL) getToday
{
    return [self getDateComponentsBy:[NSDate date]];
}

- (TimeSL) getDateComponentsBy:(NSDate*)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"dd:MM:yyyy:HH:mm:ss"];
    
    NSString *str = [df stringFromDate:date];
    NSArray *ar = [str componentsSeparatedByString:@":"];
    
    TimeSL t = {[[ar objectAtIndex:0] intValue], [[ar objectAtIndex:1] intValue], [[ar objectAtIndex:2] intValue], [[ar objectAtIndex:3] intValue], [[ar objectAtIndex:4] intValue]};
    return t;
}

- (int) getLocalTimeZoneNumber
{
    NSDate *d = [NSDate date];

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"Z"];
    int tz = [[[df stringFromDate:d] stringByReplacingOccurrencesOfString:@"0" withString:@""] intValue];
    
    return tz;
}

//- (CGFloat) jdFromDate:(int)day month:(int)month year:(int)year
//{
//    CGFloat a, y, m, jd;
//    
//    a = ((14 - month) / 12);
//    y = year + 4800 - a;
//    m = month+12*a - 3;
//    jd = day + (153*m+2)/5 + 365*y + y/4 - y/100 + y/400 - 32045;
//    
//    if (jd < 2299161)
//    {
//        jd = day + (153*m+2)/5 + 365*y + y/4 - 32083;
//    }
//    
//    return jd;
//    
//    
//}

- (long) jdFromDate:(int)day month:(int)month year:(int)year
{
    long a, y, m, jd;
    
    a = (int)((14 - month) / 12);
    y = year + 4800 - a;
    m = month+12*a - 3;
    jd = day + (int)((153*m+2)/5) + 365*y + (int)(y/4) - (int)(y/100) + (int)(y/400) - 32045;
    if (jd < 2299161)
    {
        jd = day + (int)((153*m+2)/5) + 365*y + (int)(y/4) - 32083;
    }
    
    return jd;
}




- (TimeSL)jdToDate:(long)jd
{
    long a, b, c, d, e, m, day, month, year;
    
    if (jd > 2299160)
    { // After 5/10/1582, Gregorian calendarr
        a = jd + 32044;
        b = (int)((4*a+3)/146097.0);
        c = a - (int)((b*146097)/4.0);
    }
    else
    {
        b = 0;
        c = jd + 32082;
    }
    
    d = (int)((4*c+3)/1461);
    e = c - (int)((1461*d)/4);
    m = (int)((5*e+2)/153);
    day = e - (int)((153*m+2)/5) + 1;
    month = m + 3 - 12*(int)(m/10);
    year = b*100 + d - 4800 + (int)(m/10);
    
    TimeSL t = {(int)day, (int)month, (int)year};
    return t;
}

- (int) getNewMoonDay:(CGFloat)k timeZone:(int)timeZone
{
    double T, T2, T3, dr, Jd1, M, Mpr, F, C1, deltat, JdNew;
    
    T = k/1236.85; // Time in Julian centuries from 1900 January 0.5
    T2 = T * T;
    T3 = T2 * T;
    dr = M_PI/180;
    Jd1 = 2415020.75933 + 29.53058868*k + 0.0001178*T2 - 0.000000155*T3;
    Jd1 = Jd1 + 0.00033*sin((166.56 + 132.87*T - 0.009173*T2)*dr); // Mean new moon
    M = 359.2242 + 29.10535608*k - 0.0000333*T2 - 0.00000347*T3; // Sun's mean anomaly
    Mpr = 306.0253 + 385.81691806*k + 0.0107306*T2 + 0.00001236*T3; // Moon's mean anomaly
    F = 21.2964 + 390.67050646*k - 0.0016528*T2 - 0.00000239*T3; // Moon's argument of latitude
    C1=(0.1734 - 0.000393*T)*sin(M*dr) + 0.0021*sin(2*dr*M);
    C1 = C1 - 0.4068*sin(Mpr*dr) + 0.0161*sin(dr*2*Mpr);
    C1 = C1 - 0.0004*sin(dr*3*Mpr);
    C1 = C1 + 0.0104*sin(dr*2*F) - 0.0051*sin(dr*(M+Mpr));
    C1 = C1 - 0.0074*sin(dr*(M-Mpr)) + 0.0004*sin(dr*(2*F+M));
    C1 = C1 - 0.0004*sin(dr*(2*F-M)) - 0.0006*sin(dr*(2*F+Mpr));
    C1 = C1 + 0.0010*sin(dr*(2*F-Mpr)) + 0.0005*sin(dr*(2*Mpr+M));
    
    if (T < -11)
    {
        deltat = 0.001 + 0.000839*T + 0.0002261*T2 - 0.00000845*T3 - 0.000000081*T*T3;
    }
    else
    {
        deltat= -0.000278 + 0.000265*T + 0.000262*T2;
    };
    
    JdNew = Jd1 + C1 - deltat;
    
    return (int)(JdNew + 0.5 + timeZone/24.0);
}

- (int) getSunLongitude:(CGFloat )jdn timeZone:(int)timeZone
{
    double T, T2, dr, M, L0, DL, L;
    //T = (jdn - 2451545.5 - timeZone/24) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    T = (jdn - 2451545.5 - timeZone / 24 ) / 36525;
    T2 = T*T;
    dr = PI/180; // degree to radian
    M = 357.52910 + 35999.05030*T - 0.0001559*T2 - 0.00000048*T*T2; // mean anomaly, degree
    L0 = 280.46645 + 36000.76983*T + 0.0003032*T2; // mean longitude, degree
    DL = (1.914600 - 0.004817*T - 0.000014*T2)*sin(dr*M);
    DL = DL + (0.019993 - 0.000101*T)*sin(dr*2*M) + 0.000290*sin(dr*3*M);
    L = L0 + DL; // true longitude, degree
    L = L*dr;
    L = L - PI*2*(floor(L/(PI*2))); // Normalize to (0, 2*PI)
    return floor(L / PI * 6);
    
//    double T, T2, dr, M, L0, DL, L;
//    
//    T = (jdn - 2451545.5 - timeZone/24.0) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
//    T2 = T*T;
//    dr = M_PI/180; // degree to radian
//    M = 357.52910 + 35999.05030*T - 0.0001559*T2 - 0.00000048*T*T2; // mean anomaly, degree
//    L0 = 280.46645 + 36000.76983*T + 0.0003032*T2; // mean longitude, degree
//    DL = (1.914600 - 0.004817*T - 0.000014*T2)*sin(dr*M);
//    DL = DL + (0.019993 - 0.000101*T)*sin(dr*2*M) + 0.000290*sin(dr*3*M);
//    L = L0 + DL; // true longitude, degree
//   L = L - 0.00569 - 0.00478 * sin(M_PI*(125.04 - 1934.136*T));
//   
//    L = L*dr;
//  //   L = L - 360.0 * (int)(L/360.0);
//    L = L - M_PI*2*((int)(L/(M_PI*2))); // Normalize to (0, 2*PI)
//    
//    int Long = (int)(L / M_PI * 6);
//    return Long;
}

- (CGFloat) jdFromDateTietKhi:(int)day month:(int)month year:(int)year
{
    CGFloat a, y, m, jdn;
    
    a = ((14 - month) / 12);
    y = year + 4800 - a;
    m = month+12*a - 3;
    jdn = day + floor((153*m+2)/5) + 365*y + floor(y/4) - floor(y/100) + floor(y/400) - 32045;
    CGFloat jd = jdn - 0.5 + (22 - 7)/24.0 +59 /1440.0;
    if (jd < 2299161)
    {
        jd = day + (153*m+2)/5 + 365*y + y/4 - 32083;
    }
    
    return jd;
    
    
}

- (int) getSunLongitudeTietKhi:(CGFloat )jdn timeZone:(int)timeZone
{
    double T, T2, dr, M, L0, DL, L;
    
    T = (jdn - 2451545.5 - timeZone/24.0) / 36525; // Time in Julian centuries from 2000-01-01 12:00:00 GMT
    T2 = T*T;
    dr = M_PI/180; // degree to radian
    M = 357.52910 + 35999.05030*T - 0.0001559*T2 - 0.00000048*T*T2; // mean anomaly, degree
    L0 = 280.46645 + 36000.76983*T + 0.0003032*T2; // mean longitude, degree
    DL = (1.914600 - 0.004817*T - 0.000014*T2)*sin(dr*M);
    DL = DL + (0.019993 - 0.000101*T)*sin(dr*2*M) + 0.000290*sin(dr*3*M);
    L = L0 + DL; // true longitude, degree
    L = L - 0.00569 - 0.00478 * sin(M_PI*(125.04 - 1934.136*T));
    
    //   L = L*dr;
    int X = floor(L/360.0);
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    [formatter setMaximumFractionDigits:0];
//    [formatter setRoundingMode: NSNumberFormatterRoundDown];
//    
//    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:X]];
    
    L = L - (360.0 * X);
    int L1 = L;
    
    if ((L - L1) >= 0.5) {
        L = L + 0.5;
    }
    //    L = L - M_PI*2*((int)(L/(M_PI*2))); // Normalize to (0, 2*PI)
    
    //  int Long = (int)(L / M_PI * 6);
    return L;
}

- (long) getLunarMonth11:(int)year timeZone:(int)timeZone
{
    long k, off, nm, sunLong;
    
    off = [self jdFromDate:31 month:12 year:year] - 2415021;
    k = (int)(off / 29.530588853);
    nm = [self getNewMoonDay:k timeZone:timeZone];
    sunLong = [self getSunLongitude:nm timeZone:timeZone]; // sun longitude at local midnight
    
    if (sunLong >= 9)
    {
        nm = [self getNewMoonDay:k-1 timeZone:timeZone];
    }
    
    return nm;
}

- (int) getLeapMonthOffset:(CGFloat)a11 timeZone:(int)timeZone
{
    int k, last, arc, i;
    
    k = (int)((a11 - 2415021.076998695) / 29.530588853 + 0.5);
    last = 0;
    i = 1; // We start with the month following lunar month 11
    arc = [self getSunLongitude:[self getNewMoonDay:k+i timeZone:timeZone] timeZone:timeZone];
    
    do {
        last = arc;
        i++;
        arc = [self getSunLongitude:[self getNewMoonDay:k+i timeZone:timeZone] timeZone:timeZone];
    } while (arc != last && i < 14);
    
    return i-1;

}


- (int) getLunarLeapFromSunDate:(int)day month:(int)month year:(int)year timeZone:(int)timeZone
{
    long k, dayNumber, monthStart, a11, b11, lunarLeap;
    
    dayNumber = [self jdFromDate:day month:month year:year];
    
    k = (int)((dayNumber - 2415021.076998695) / 29.530588853);
    monthStart = [self getNewMoonDay:k+1 timeZone:timeZone];
    if (monthStart > dayNumber)
    {
        monthStart = [self getNewMoonDay:k timeZone:timeZone];
    }
    
    a11 = [self getLunarMonth11:year timeZone:timeZone];
    b11 = a11;
    if (a11 >= monthStart)
    {
        a11 = [self getLunarMonth11:year-1 timeZone:timeZone];
    }
    else
    {
        b11 = [self getLunarMonth11:year+1 timeZone:timeZone];
    }
    
    lunarLeap = 0;
    int diff = (int)((monthStart - a11)/29);
    if (b11 - a11 > 365)
    {
        CGFloat leapMonthDiff = [self getLeapMonthOffset:a11 timeZone:timeZone];
        if (diff >= leapMonthDiff)
        {
            if (diff == leapMonthDiff)
            {
                lunarLeap = 1;
            }
        }
    }
    
    return (int)lunarLeap;
}

- (TimeSL) convertSunToLunar:(TimeSL)date timeZone:(int)timeZone
{
    return [self convertSunToLunar:date.day month:date.month year:date.year timeZone:timeZone];
}

- (TimeSL) convertSunToLunar:(int)day month:(int)month year:(int)year timeZone:(int)timeZone
{

    long k, monthStart, a11, b11, lunarDay, lunarMonth, lunarYear, lunarLeap, dayNumber;
    
    dayNumber = [self jdFromDate:day month:month year:year];
    
    k = (int)((dayNumber - 2415021.076998695) / 29.530588853);
    
    monthStart = [self getNewMoonDay:k+1 timeZone:timeZone];
    if (monthStart > dayNumber)
    {
        monthStart = [self getNewMoonDay:k timeZone:timeZone];
    }
    
    a11 = [self getLunarMonth11:year timeZone:timeZone];
    b11 = a11;
    if (a11 >= monthStart)
    {
        lunarYear = year;
        a11 = [self getLunarMonth11:year-1 timeZone:timeZone];
    }
    else
    {
        lunarYear = year+1;
        b11 = [self getLunarMonth11:year+1 timeZone:timeZone];
    }
    
    lunarDay = dayNumber-monthStart+1;
    int diff = (int)((monthStart - a11)/29);
    int x = 0;
    lunarLeap = 0;
    lunarMonth = diff+11;
    if (b11 - a11 > 365)
    {
        CGFloat leapMonthDiff = [self getLeapMonthOffset:a11 timeZone:timeZone];
        if (diff >= leapMonthDiff)
        {
            lunarMonth = diff + 10;
            if (diff == leapMonthDiff)
            {
                lunarLeap = 1;
                x = 1;
            }
        }
    }
    
    if (lunarMonth > 12)
    {
        lunarMonth = lunarMonth - 12;
    }
    
    if (lunarMonth >= 11 && diff < 4)
    {
        lunarYear -= 1;
    }
    
  //  NSLog(@"%d",(int)lunarLeap);
    
    TimeSL t = {(int)lunarDay, (int)lunarMonth, (int)lunarYear ,nil,nil,x};
    return t;
}

- (TimeSL) convertLunarToSun:(TimeSL)date timeZone:(int)timeZone
{
    return [self convertLunarToSun:date.day month:date.month year:date.year lunarLeap:1 timeZone:timeZone];
}

- (TimeSL) convertLunarToSun:(int)day month:(int)month year:(int)year lunarLeap:(int)lunarLeap timeZone:(int)timeZone
{
    
    long k, a11, b11, off, leapOff, leapMonth, monthStart;
	if (month < 11)
    {
		a11 = [self getLunarMonth11:year-1 timeZone:timeZone];
        b11 = [self getLunarMonth11:year timeZone:timeZone];
	}
    else
    {
		a11 = [self getLunarMonth11:year timeZone:timeZone];
		b11 = [self getLunarMonth11:year+1 timeZone:timeZone];
	}
    
	k = (int)(0.5 + (a11 - 2415021.076998695) / 29.530588853);
	off = month - 11;
	if (off < 0)
    {
		off += 12;
	}
    
	if (b11 - a11 > 365)
    {
		leapOff = [self getLeapMonthOffset:a11 timeZone:timeZone];
		leapMonth = leapOff - 2;
		if (leapMonth < 0)
        {
			leapMonth += 12;
		}
        
		if ((lunarLeap != 0) && (month != leapMonth))
        {
            TimeSL t = {0,0,0};
			return t;
		}
        else if ((lunarLeap != 0) && (off >= leapOff))
        {
			off += 1;
		}
	}
    
	monthStart = [self getNewMoonDay:k+off timeZone:timeZone];
    return [self jdToDate:monthStart+day-1];
}

- (double)UniversalToJD:(int)D M:(int)M Y:(int)Y {
    double JD;
    if (Y > 1582 || (Y == 1582 && M > 10)
        || (Y == 1582 && M == 10 && D > 14)) {
        JD = 367 * Y - (int)(7 * (Y + ((M + 9) / 12)) / 4)
        - (int)(3 * ((int)((Y + (M - 9) / 7) / 100) + 1) / 4)
        + (int)(275 * M / 9) + D + 1721028.5;
    } else {
        JD = 367 * Y - (int)(7 * (Y + 5001 + ((int)(M - 9) / 7)) / 4)
        + (int)(275 * M / 9) + D + 1729776.5;
    }
    return JD;
    
}

- (NSString *)calculatorNgayThutoDate:(int )d andMonth:(int)m andYear:(int)y
{
    int x ;
    NSString *thu;
    x = (int)([self jdFromDate:d month:m year:y]+2.5) % 7;
    
        if (x == 1) {
            thu = @"Chủ Nhật";
        }
        if (x == 2) {
            thu = @"Thứ Hai";
        }
        if (x == 3) {
            thu = @"Thứ Ba";
        }
        if (x == 4) {
            thu = @"Thứ Tư";
        }
        if (x == 5) {
            thu = @"Thứ Năm";
        }
        if (x == 6) {
            thu = @"Thứ Sáu";
        }
        if (x == 0) {
            thu = @"Thứ Bảy";
        }
    
    return thu;
}

- (int )getThu:(int )d andMonth:(int)m andYear:(int)y
{
    int x;
    x = (int)([self jdFromDate:d month:m year:y]+2.5) % 7;
    return x;
}

-(NSString *)calculatorCantoDate:(int )d andMonth:(int)m andYear:(int)y
{
    int x ;
    NSString *can;
    x = (int)([self jdFromDate:d month:m year:y] + 9) % 10;
    
    
    
    switch (x) {
        case 0:
            can = @"Giáp";
            break;
        case 1:
            can = @"Ất";
            break;
        case 2:
            can = @"Bính";
            break;
        case 3:
            can = @"Đinh";
            break;
        case 4:
            can = @"Mậu";
            break;
        case 5:
            can = @"Kỷ";
            break;
        case 6:
            can = @"Canh";
            break;
        case 7:
            can = @"Tân";
            break;
        case 8:
            can = @"Nhâm";
            break;
        case 9:
            can = @"Quý";
            break;
            
        default:
            break;
    }
    
    return can;
}

-(NSString *)calculatorChitoDate:(int )d andMonth:(int)m andYear:(int)y
{
    int x ;
    NSString *chi;
    x = (int)([self jdFromDate:d month:m year:y]+1) % 12;
    
    switch (x) {
        case 0:
            chi = TYS;
            break;
        case 1:
            chi = SUU;
            break;
        case 2:
            chi = DAN;
            break;
        case 3:
            chi = MAO;
            break;
        case 4:
            chi = THIN;
            break;
        case 5:
            chi =  TYJ;
            break;
        case 6:
            chi = NGO;
            break;
        case 7:
            chi = MUI;
            break;
        case 8:
            chi = THAN;
            break;
        case 9:
            chi = DAU;
            break;
        case 10:
            chi =  TUAT;
            break;
        case 11:
            chi = HOI;
            break;
            
        default:
            break;
    }
    
    return chi;
}

-(NSString *)calculatorCANtoMonth:(int)m andYear:(int)y
{
    int x ;
    NSString *CAN;
    x = (y*12 + m +3) % 10;
    
    switch (x) {
        case 0:
            CAN = @"Giap";
            break;
        case 1:
            CAN = @"Ất";
            break;
        case 2:
            CAN = @"Bính";
            break;
        case 3:
            CAN = @"Đinh";
            break;
        case 4:
            CAN = @"Mậu";
            break;
        case 5:
            CAN = @"Kỷ";
            break;
        case 6:
            CAN = @"Canh";
            break;
        case 7:
            CAN = @"Tân";
            break;
        case 8:
            CAN = @"Nhâm";
            break;
        case 9:
            CAN = @"Quý";
            break;
            
        default:
            break;
    }
    
    return CAN;
}

- (NSString *)calculatorGioCanChifromGio:(int)hh andPhut:(int)mm
{
    NSString *gioChi;
    float h = hh + (float) mm / 60;
    if (h > 23 || (h >= 0 && h <= 1))
    {
        gioChi = @"Tý";
    }
    else if (h > 1 && h <= 3)
    {
        gioChi = @"Sửu";
    }
    else if (h > 3 && h <= 5)
    {
        gioChi = @"Dần";
    }
    else if (h > 5 && h <= 7)
    {
        gioChi = @"Mão";
    }
    else if (h > 7 && h <= 9)
    {
        gioChi = @"Thìn";
    }
    else if (h > 9 && h <= 11)
    {
        gioChi =  @"Ty.";
    }
    else if (h > 11 && h <= 13)
    {
        gioChi = @"Ngọ";
    }
    else if (h > 13 && h <= 15)
    {
        gioChi = @"Mùi";
    }
    else if (h > 15 && h <= 17)
    {
         gioChi = @"Thân";
    }
    else if (h > 17 && h <= 19)
    {
        gioChi = @"Dậu";
    }
    else if (h > 19 && h <= 21)
    {
        gioChi =  @"Tuất";
    }
    else if (h > 21 && h <= 23)
    {
        gioChi = @"Hợi";
    }
    
    return gioChi;

}

- (NSString *)calculatorCHItoMonth:(int)m
{
    int x ;
    NSString *chi;
    x = (int)(m + 1) % 12;
    
    switch (x) {
        case 0:
            chi = @"Tý";
            break;
        case 1:
            chi =@"Sửu";
            break;
        case 2:
            chi = @"Dần";
            break;
        case 3:
            chi = @"Mão";
            break;
        case 4:
            chi = @"Thìn";
            break;
        case 5:
            chi =  @"Ty.";
            break;
        case 6:
            chi = @"Ngọ";
            break;
        case 7:
            chi = @"Mùi";
            break;
        case 8:
            chi = @"Thân";
            break;
        case 9:
            chi = @"Dậu";
            break;
        case 10:
            chi =  @"Tuất";
            break;
        case 11:
            chi = @"Hợi";
            break;
            
        default:
            break;
    }
    
    return chi;
}

- (NSString *)calculatorCHItoYear:(int)y
{
    int x ;
    NSString *chi;
    x = (int)(y + 8) % 12;
    
    switch (x) {
        case 0:
            chi = @"Tý";
            break;
        case 1:
            chi =@"Sửu";
            break;
        case 2:
            chi = @"Dần";
            break;
        case 3:
            chi = @"Mão";
            break;
        case 4:
            chi = @"Thìn";
            break;
        case 5:
            chi =  @"Ty.";
            break;
        case 6:
            chi = @"Ngọ";
            break;
        case 7:
            chi = @"Mùi";
            break;
        case 8:
            chi = @"Thân";
            break;
        case 9:
            chi = @"Dậu";
            break;
        case 10:
            chi =  @"Tuất";
            break;
        case 11:
            chi = @"Hợi";
            break;
            
        default:
            break;
    }
    
    return chi;
}

-(NSString *)calculatorCANtoYear:(int)y
{
    int x ;
    NSString *CAN;
    x = (int)(y + 6) % 10;
    
    switch (x) {
        case 0:
            CAN = @"Giáp";
            break;
        case 1:
            CAN = @"Ất";
            break;
        case 2:
            CAN = @"Bính";
            break;
        case 3:
            CAN = @"Đinh";
            break;
        case 4:
            CAN = @"Mậu";
            break;
        case 5:
            CAN = @"Kỷ";
            break;
        case 6:
            CAN = @"Canh";
            break;
        case 7:
            CAN = @"Tân";
            break;
        case 8:
            CAN = @"Nhâm";
            break;
        case 9:
            CAN = @"Quý";
            break;
            
        default:
            break;
    }
    
    return CAN;
}

- (NSString *)ngayLeDL :(int )ngay thang:(int )thang {
    NSString * ngayLe = @"";
    
    if (thang == 1) {
        if (ngay == 1) {
            ngayLe = @"Tết Dương Lịch";
        }else if (ngay == 9) {
            ngayLe = @"Ngày Sinh Viên - Học sinh Việt Nam";
        }else if (ngay == 11) {
            ngayLe = @"Ngày Tết trồng cây";
        }
    }else if (thang == 2) {
        if (ngay == 3) {
            ngayLe = @"Ngày thành lập Đảng Cộng Sản Việt Nam";
        }else if (ngay == 14) {
            ngayLe = @"Ngày lễ tình nhân Valentine";
        }else if (ngay == 27) {
            ngayLe = @"Ngày thầy thuốc Việt Nam";
        }else if (ngay == 9) {
            ngayLe = @"Ngày sinh viên - Học sinh Việt Nam";
        }
    }else if (thang ==4) {
        if (ngay == 1) {
            ngayLe = @"Ngày cá tháng tư";
        }else if (ngay == 30) {
            ngayLe = @"Ngày giải phóng Miền Nam";
        }
    }else if (thang == 5) {
        if (ngay == 1) {
            ngayLe =@"Ngày Quốc tế Lao Động";
        }else if (ngay == 7) {
            ngayLe =@"Chiến thắng Điện Biên Phủ";
        }else if (ngay == 15) {
            ngayLe =@"Ngày thành lập Đội thiếu niên Tiền Phong Hồ Chí Minh";
        }else if (ngay == 19) {
            ngayLe =@"Ngày sinh của Chủ tịch Hồ Chí Minh";
        }
    }else if (thang == 6) {
        if (ngay == 1) {
            ngayLe = @"Ngày Quốc tế Thiếu nhi";
        }else if (ngay == 5) {
            ngayLe = @"Ngày Môi trường thế giới";
        }else if (ngay == 28) {
            ngayLe = @"Ngày Gia đình Việt Nam";
            
        }
        
    }else if (thang == 8 && ngay == 19){
         ngayLe = @"Ngày Cách mạng tháng Tám thành công";
        
        
    } else if (thang == 9 && ngay == 2) {
        ngayLe = @"Ngày Quốc Khánh nước Việt Nam";
    } else if (thang == 10) {
        if (ngay == 1) {
            ngayLe = @"Quốc tế Người cao tuổi";
        } else if (ngay == 10) {
            ngayLe = @"Ngày Giải phóng Thủ đô Hà Nội";
        } else if (ngay == 13) {
            ngayLe = @"Ngày Doanh nhân Việt Nam";
        } else if (ngay == 20) {
            ngayLe = @"Ngày thành lập Hội liên hiệp Phụ nữ Việt Nam";
        }
    } else if (thang == 11 && ngay == 20) {
        ngayLe = @"Ngày Nhà giáo Việt Nam";
    } else if (thang == 12) {
        if (ngay == 1) {
            ngayLe = @"Ngày Quốc tế phòng chống bệnh AIDS";
        } else if (ngay == 3) {
            ngayLe = @"Ngày Quốc tế người khuyết tật";
        } else if (ngay == 10) {
            ngayLe = @"Ngày Quốc tế quyền con người";
        } else if (ngay == 22) {
            ngayLe = @"Ngày thành lập Quân đội Nhân dân Việt Nam";
        } else if (ngay == 25) {
            ngayLe = @"Lễ Giáng sinh";
        } else if (ngay == 26) {
            ngayLe = @"Ngày Dân số Việt Nam";
        }
    }
    
    return ngayLe;
}

- (NSString *)ngayLeAL: (int)ngay thang:(int)thang {
    NSString * ngayLe = @"";
    if (thang == 1) {
        if (ngay == 1) {
            ngayLe = @"Tết Nguyên Đán";
        } else if (ngay == 2) {
            ngayLe = @"Tết Nguyên Đán";
        } else if (ngay == 3) {
            ngayLe = @"Tết Nguyên Đán";
        } else if (ngay == 15) {
            ngayLe = @"Tết Nguyên tiêu";
        }
    } else if (thang == 3) {
        if (ngay == 3) {
            ngayLe = @"Tết Hàn thực";
        } else if (ngay == 10) {
            ngayLe = @"Giỗ tổ Hùng Vương";
        }
    } else if (thang == 4 && ngay == 15) {
        ngayLe = @"Lễ Phật Đản";
    } else if (thang == 5 && ngay == 5) {
        ngayLe = @"Tết Đoan ngọ";
    } else if (thang == 7 && ngay == 15) {
        ngayLe = @"Lễ Vu lan";
    } else if (thang == 8 && ngay == 15) {
        ngayLe = @"Tết Trung thu";
    } else if (thang == 10 && ngay == 10) {
        ngayLe = @"Tết Trùng thập";
    } else if (thang == 12 && ngay == 23) {
        ngayLe = @"Tết ông Công ông Táo";
    }
    return ngayLe;
    
}

- (BOOL )comepareDate:(int)day andMonth:(int)month anddayStart:(int)dayStart andmonthStart:(int)monthStart anddayEnd:(int)dayEnd andmonthEnd:(int)monthEnd andyear:(int)year
{
    if (year % 400 == 0) {
        dayStart++;
        dayEnd++;
    }
    
    NSString *stringDate1 = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    NSString *stringDate2 = [NSString stringWithFormat:@"%d-%d-%d",year,monthStart,dayStart];
    NSString *stringDate3 = [NSString stringWithFormat:@"%d-%d-%d",year,monthEnd,dayEnd];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *date1 = [dateFormatter dateFromString:stringDate1];
    NSDate *date2 = [dateFormatter dateFromString:stringDate2];
    NSDate *date3 = [dateFormatter dateFromString:stringDate3];
    
    return [date1 compare:date2]>=0 && [date1 compare:date3]<0;
}

- (TietKhiModel *)getTietKhi:(int)day month:(int)month year:(int)year {
    TietKhiModel * tietkhiObject = [[TietKhiModel alloc]init];
        if ([self comepareDate:day andMonth:month anddayStart:6 andmonthStart:1 anddayEnd:20 andmonthEnd:1 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Tiểu Hàn" tinhChatTietKhi:@"gettiet"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:20 andmonthStart:1 anddayEnd:4 andmonthEnd:2 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Đại Hàn" tinhChatTietKhi:@"Rét đậm"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:4 andmonthStart:2 anddayEnd:19 andmonthEnd:2 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Lập Xuân" tinhChatTietKhi:@"Bắt đầu mùa xuân"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:19 andmonthStart:2 anddayEnd:6 andmonthEnd:3 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Vũ Thủy" tinhChatTietKhi:@"Mưa ẩm"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:6 andmonthStart:3 anddayEnd:21 andmonthEnd:3 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Kinh Trập" tinhChatTietKhi:@"Sâu nở"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:21 andmonthStart:3 anddayEnd:5 andmonthEnd:4 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Xuân Phân" tinhChatTietKhi:@"Giữa xuân"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:5 andmonthStart:4 anddayEnd:20 andmonthEnd:4 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Thanh Minh" tinhChatTietKhi:@"Trời trong sáng"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:20 andmonthStart:4 anddayEnd:6 andmonthEnd:5 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Cốc Vũ" tinhChatTietKhi:@"Mưa rào"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:6 andmonthStart:5 anddayEnd:21 andmonthEnd:5 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Lập Hạ" tinhChatTietKhi:@"Bắt đầu mùa hè"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:21 andmonthStart:5 anddayEnd:6 andmonthEnd:6 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Tiểu Mãn" tinhChatTietKhi:@"Lũ nhỏ, duối vàng"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:6 andmonthStart:6 anddayEnd:21 andmonthEnd:6 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Mang Chủng" tinhChatTietKhi:@"Chòm sao tua rua mọc"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:21 andmonthStart:6 anddayEnd:7 andmonthEnd:7 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Hạ Chí" tinhChatTietKhi:@"Giữa hè"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:7 andmonthStart:7 anddayEnd:23 andmonthEnd:7 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Tiểu Thử" tinhChatTietKhi:@"Nóng nhẹ"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:23 andmonthStart:7 anddayEnd:8 andmonthEnd:8 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Đại Thử" tinhChatTietKhi:@"Nóng oi"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:8 andmonthStart:8 anddayEnd:23 andmonthEnd:8 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Lập Thu" tinhChatTietKhi:@"Bắt đầu mùa thu"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:23 andmonthStart:8 anddayEnd:8 andmonthEnd:9 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Xử thử" tinhChatTietKhi:@"Mưa ngâu"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:8 andmonthStart:9 anddayEnd:23 andmonthEnd:9 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Bạch Lộ" tinhChatTietKhi:@"Nắng nhạt"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:23 andmonthStart:9 anddayEnd:8 andmonthEnd:10 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Thu Phân" tinhChatTietKhi:@"Giữa thu"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:8 andmonthStart:10 anddayEnd:23 andmonthEnd:10 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Hàn Lộ" tinhChatTietKhi:@"Mát mẻ"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:23 andmonthStart:10 anddayEnd:8 andmonthEnd:11 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Sương Giáng" tinhChatTietKhi:@"Sương mù xuất hiện"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:8 andmonthStart:11 anddayEnd:22 andmonthEnd:11 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Lập Đông" tinhChatTietKhi:@"Bắt đầu mùa đông"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:22 andmonthStart:11 anddayEnd:7 andmonthEnd:12 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Tiểu Tuyết" tinhChatTietKhi:@"Tuyết xuất hiện"];
            return tietkhiObject;
        } else if ([self comepareDate:day andMonth:month anddayStart:7 andmonthStart:12 anddayEnd:22 andmonthEnd:12 andyear:year]) {
            [tietkhiObject parserTietKhi:@"Đại Tuyết" tinhChatTietKhi:@"Tuyết dầy"];
            return tietkhiObject;
        } else {
            [tietkhiObject parserTietKhi:@"Đông Chí" tinhChatTietKhi:@"Giữa đông"];
            return tietkhiObject;
        }
    return tietkhiObject;
}





//- (TietKhi *)getTietKhi:(int)ngay thang:(int)thang nam:(int)nam
//{
//    NSString *tietKhi;
//    NSString *nghiaTietKhi;
//    TietKhi tietkhi1 = {(NSString *)tietKhi, (NSString *)nghiaTietKhi};
//
//
//    if ([self comepareDate:ngay andMonth:thang anddayStart:6 andmonthStart:1 anddayEnd:20 andmonthEnd:1 andyear:nam]) {
//        tietKhi = @"Tiểu Hàn";
//        nghiaTietKhi = @"Rét nhẹ";
//       
//    }
//    return &tietkhi1;
//}

- (NSString *)checkNamNhuan:(int)n
{
    BOOL check;
    NSString *checkNam;
//    check = (((y % 4 == 0) && (y % 100 != 0)) || (y % 400 == 0));
////    {
////        
////    }
// //       return true; // nam nhuan,0
// //   return false; // khong nhuan,1
//    if (check == YES) {
//        checkNam = @"1";
//    }else{
//        checkNam = @"0";
//    }
    if(((n%4==0)&&(n%100!=0))||(n%400==0))
        printf("Nam %d la nam nhuan!\n",n);
    else
        printf("Nam %d khong phai la nam nhuan!\n",n);
    return checkNam;
}

- (NSString *)calculatorHyThan:(int)d andMonth:(int)m andYear:(int)y
{
    int x ;
    NSString *hyThan;
    x = (int)([self jdFromDate:d month:m year:y]+9) % 12;
    switch (x) {
        case 5:
            hyThan = @"Hỷ Thần: Đông Bắc";
            break;
        case 6:
            hyThan = @"Hỷ Thần: Tây Bắc";
            break;
        case 7:
            hyThan = @"Hỷ Thần: Tây Nam";
            break;
        case 8:
            hyThan = @"Hỷ Thần: Chính Nam";
            break;
        case 9:
            hyThan = @"Hỷ Thần: Đông Nam";
            break;
            
        default:
            break;
    }
    return hyThan;
}

- (NSString *)calculatorTaiThan:(int)d andMonth:(int)m andYear:(int)y
{
    int x ;
    NSString *taiThan;
    x = (int)([self jdFromDate:d month:m year:y]+9) % 12;
    switch (x) {
        case 1:
            taiThan = @"Tài Thần: Đông Nam";
            break;
        case 3:
            taiThan = @"Tài Thần: Đông";
            break;
        case 4:
            taiThan = @"Tài Thần: Bắc";
            break;
        case 5:
            taiThan = @"Tài Thần: Nam";
            break;
        case 7:
            taiThan = @"Tài Thần: Tây Nam";
            break;
        case 8:
            taiThan = @"Tài Thần: Tây";
            break;
        case 9:
            taiThan = @"Tài Thần: Tây Bắc";
            break;
            
        default:
            break;
    }
    return taiThan;
}

- (long )getMonthNhuan:(int)day month:(int)month year:(int)year lunarLeap:(int)lunarLeap timeZone:(int)timeZone
{
//    int x ;
//    NSString *monthNhuan;
    
    long k, a11, b11, off, leapOff, leapMonth;
    if (month < 11)
    {
        a11 = [self getLunarMonth11:year-1 timeZone:timeZone];
        b11 = [self getLunarMonth11:year timeZone:timeZone];
    }
    else
    {
        a11 = [self getLunarMonth11:year timeZone:timeZone];
        b11 = [self getLunarMonth11:year+1 timeZone:timeZone];
    }
    
    k = (int)(0.5 + (a11 - 2415021.076998695) / 29.530588853);
    off = month - 11;
    if (off < 0)
    {
        off += 12;
    }
    
    if (b11 - a11 > 365)
    {
        leapOff = [self getLeapMonthOffset:a11 timeZone:timeZone];
        leapMonth = leapOff - 2;
        if (leapMonth < 0)
        {
            leapMonth += 12;
        }
        
    }
    return leapMonth;
    
}



- (NSString *)getTietKhiSunLong:(int)d andMonth:(int)m andYear:(int)y
{
    int s1 = 0;
    CGFloat ret = [self jdFromDateTietKhi:d month:m year:y];
    CGFloat jd = ret - 0.5 + (22 - 7)/24.0 +59 /1440.0;
    s1 = [self getSunLongitudeTietKhi:jd timeZone:7];
    
    if (s1 >= 0.0 && s1 < 15.0) {
        return @"Xuân Phân";
    } else if (s1 >= 15.0 && s1 < 30.0) {
        return @"Thanh Minh";
    } else if (s1 >= 30.0 && s1 < 45.0) {
        return @"Cốc Vũ";
    } else if (s1 >= 45.0 && s1 < 60.0) {
        return @"Lập Hạ";
    } else if (s1 >= 60.0 && s1 < 75.0) {
        return @"Tiểu Mãn";
    } else if (s1 >= 75.0 && s1 < 90.0) {
        return @"Mang Chủng";
    } else if (s1 >= 90.0 && s1 < 105.0) {
        return @"Hạ Chí";
    } else if (s1 >= 105.0 && s1 < 120.0) {
        return @"Tiểu Thử";
    } else if (s1 >= 120.0 && s1 < 135.0) {
        return @"Đại Thử";
    } else if (s1 >= 135.0 && s1 < 150.0) {
        return @"Lập Thu";
    } else if (s1 >= 150.0 && s1 < 165.0) {
        return @"Xử Thử";
    } else if (s1 >= 165.0 && s1 < 180.0) {
        return @"Bạch Lộ";
    } else if (s1 >= 180.0 && s1 < 195.0) {
        return @"Thu Phân";
    } else if (s1 >= 195.0 && s1 < 210.0) {
        return @"Hàn Lộ";
    } else if (s1 >= 210.0 && s1 < 225.0) {
        return @"Sương Giáng";
    } else if (s1 >= 225.0 && s1 < 240.0) {
        return @"Lập Đông";
    } else if (s1 >= 240.0 && s1 < 255.0) {
        return @"Tiểu Tuyết";
    } else if (s1 >= 255.0 && s1 < 270.0) {
        return @"Đại Tuyết";
    } else if (s1 >= 270.0 && s1 < 285.0) {
        return @"Đông Chí";
    } else if (s1 >= 285.0 && s1 < 300.0) {
        return @"Tiểu Hàn";
    } else if (s1 >= 300.0 && s1 < 315.0) {
        return @"Đại Hàn";
    } else if (s1 >= 315.0 && s1 < 330.0) {
        return @"Lập Xuân";
    } else if (s1 >= 330.0 && s1 < 345.0) {
        return @"Vũ Thủy";
    } else if (s1 >= 345.0 && s1 < 360.0) {
        return @"Kinh Trập";
    }
    return nil;
}

- (StarModel *)getSao:(int)d andMonth:(int)m andYear:(int)y
{
    int x;
    StarModel * starObject = [[StarModel alloc]init];
    NSString *sao;
    x = (int)([self jdFromDate:d month:m year:y] +12) % 28;
    
    
    switch (x) {
        case 1:
            sao = @"Sao Giác";
            break;
        case 2:
            sao = @"Sao Cang";
            break;
        case 3:
            sao = @"Sao Đê";
            break;
        case 4:
            sao = @"Sao Phòng";
            break;
        case 5:
            sao = @"Sao Tâm";
            break;
        case 6:
            sao = @"Sao Vĩ";
            break;
        case 7:
            sao = @"Sao Cơ";
            break;
        case 8:
            sao = @"Sao Đẩu";
            break;
        case 9:
            sao = @"Sao Ngưu";
            break;
        case 10:
            sao = @"Sao Nữ";
            break;
        case 11:
            sao = @"Sao Hư";
            break;
        case 12:
            sao = @"Sao Nguy";
            break;
        case 13:
            sao = @"Sao Thất";
            break;
        case 14:
            sao = @"Sao Bích";
            break;
        case 15:
            sao = @"Sao Khuê";
            break;
        case 16:
            sao = @"Sao Lâu";
            break;
        case 17:
            sao = @"Sao Vị";
            break;
        case 18:
            sao = @"Sao Mão";
            break;
        case 19:
            sao = @"Sao Tấn";
            break;
        case 20:
            sao = @"Sao Chủy";
            break;
        case 21:
            sao = @"Sao Sâm";
            break;
        case 22:
            sao = @"Sao Tỉnh";
            break;
        case 23:
            sao = @"Sao Quỷ";
            break;
        case 24:
            sao = @"Sao Liễu";
            break;
        case 25:
            sao = @"Sao Tinh";
            break;
        case 26:
            sao = @"Sao Trương";
            break;
        case 27:
            sao = @"Sao Dực";
            break;
        case 0:
            sao = @"Sao Chẩn";
            break;

            
        default:
            break;
    }
    [starObject parserStar:sao ynghiaStar:@""];
    return starObject;
}
// Check HoangDao va HacDao
- (BOOL)isHoangDao:(NSInteger)thangAL andNgayChi:(NSString*)ngayChi{
    BOOL isHoangDao = NO;
    if (thangAL == 1 || thangAL == 7) {
        if (   [ngayChi isEqualToString: @"Tý"]
            || [ngayChi isEqualToString: @"Sửu"]
            || [ngayChi isEqualToString: @"Thìn"]
            || [ngayChi isEqualToString: @"Ty."]
            || [ngayChi isEqualToString: @"Mùi"]
            || [ngayChi isEqualToString: @"Tuất"]) {
            isHoangDao = YES;
        }
    } else if (thangAL == 2 || thangAL == 8) {
        if ([ngayChi isEqualToString: @"Dần"]
            || [ngayChi isEqualToString: @"Mão"]
            || [ngayChi isEqualToString: @"Ngọ"]
            || [ngayChi isEqualToString: @"Mùi"]
            || [ngayChi isEqualToString: @"Dậu"]
            || [ngayChi isEqualToString: @"Tý"]) {
            isHoangDao = YES;
        }
    } else if (thangAL == 3 || thangAL == 9) {
        if ([ngayChi isEqualToString: @"Thìn"]
            || [ngayChi isEqualToString: @"Ty."]
            || [ngayChi isEqualToString: @"Thân"]
            || [ngayChi isEqualToString: @"Dậu"]
            || [ngayChi isEqualToString: @"Hợi"]
            || [ngayChi isEqualToString: @"Dần"]) {
            isHoangDao = YES;
        }
    } else if (thangAL == 4 || thangAL == 10) {
        if ([ngayChi isEqualToString: @"Ngọ"]
            || [ngayChi isEqualToString: @"Mùi"]
            || [ngayChi isEqualToString: @"Tuất"]
            || [ngayChi isEqualToString: @"Hợi"]
            || [ngayChi isEqualToString: @"Sửu"]
            || [ngayChi isEqualToString: @"Thìn"]) {
            isHoangDao = YES;
        }
    } else if (thangAL == 5 || thangAL == 11) {
        if ([ngayChi isEqualToString: @"Thân"]
            || [ngayChi isEqualToString: @"Dậu"]
            || [ngayChi isEqualToString: @"Tý"]
            || [ngayChi isEqualToString: @"Sửu"]
            || [ngayChi isEqualToString: @"Mão"]
            || [ngayChi isEqualToString: @"Ngọ"]) {
            isHoangDao = YES;
        }
    } else if (thangAL == 6 || thangAL == 12) {
        if ([ngayChi isEqualToString: @"Tuất"]
            || [ngayChi isEqualToString: @"Hợi"]
            || [ngayChi isEqualToString: @"Dần"]
            || [ngayChi isEqualToString: @"Mão"]
            || [ngayChi isEqualToString: @"Ty."]
            || [ngayChi isEqualToString: @"Thân"]) {
            isHoangDao = YES;
        }
    }
    
    return isHoangDao;
}
- (BOOL)isHacDao:(NSInteger)thangAL andNgayChi:(NSString*)ngayChi{
    BOOL isHacDao = NO;
    if (thangAL == 1 || thangAL == 7) {
        if ([ngayChi isEqualToString: @"Dần"]
            || [ngayChi isEqualToString: @"Mão"]
            || [ngayChi isEqualToString: @"Ngọ"]
            || [ngayChi isEqualToString: @"Thân"]
            || [ngayChi isEqualToString: @"Dậu"]
            || [ngayChi isEqualToString: @"Hợi"]) {
            isHacDao = YES;
        }
    } else if (thangAL == 2 || thangAL == 8) {
        if ([ngayChi isEqualToString: @"Thìn"]
            || [ngayChi isEqualToString: @"Ty."]
            || [ngayChi isEqualToString: @"Thân"]
            || [ngayChi isEqualToString: @"Tuất"]
            || [ngayChi isEqualToString: @"Sửu"]
            || [ngayChi isEqualToString: @"Hợi"]) {
            isHacDao = YES;
        }
    } else if (thangAL == 3 || thangAL == 9) {
        if ([ngayChi isEqualToString: @"Ngọ"]
            || [ngayChi isEqualToString: @"Mùi"]
            || [ngayChi isEqualToString: @"Tuất"]
            || [ngayChi isEqualToString: @"Tý"]
            || [ngayChi isEqualToString: @"Sửu"]
            || [ngayChi isEqualToString: @"Mão"]) {
            isHacDao = YES;
        }
    } else if (thangAL == 4 || thangAL == 10) {
        if ([ngayChi isEqualToString: @"Thân"]
            || [ngayChi isEqualToString: @"Dậu"]
            || [ngayChi isEqualToString: @"Tý"]
            || [ngayChi isEqualToString: @"Dần"]
            || [ngayChi isEqualToString: @"Ty."]
            || [ngayChi isEqualToString: @"Mão"]) {
            isHacDao = YES;
        }
    } else if (thangAL == 5 || thangAL == 11) {
        if ([ngayChi isEqualToString: @"Tuất"]
            || [ngayChi isEqualToString: @"Hợi"]
            || [ngayChi isEqualToString: @"Dần"]
            || [ngayChi isEqualToString: @"Thìn"]
            || [ngayChi isEqualToString: @"Mùi"]
            || [ngayChi isEqualToString: @"Ty."]) {
            isHacDao = YES;
        }
    } else if (thangAL == 6 || thangAL == 12) {
        if ([ngayChi isEqualToString: @"Tý"]
            || [ngayChi isEqualToString: @"Sửu"]
            || [ngayChi isEqualToString: @"Thìn"]
            || [ngayChi isEqualToString: @"Ngọ"]
            || [ngayChi isEqualToString: @"Dậu"]
            || [ngayChi isEqualToString: @"Mùi"])
        {
            isHacDao = YES;
        }
    }
    
    return isHacDao;
}

- (NSString *)getViecLam:(int )x
{
    NSString *string;
    switch (x) {
        case 0:
            string = @"Xuất hành";
            break;
        case 1:
            string = @"Di chuyển chỗ ở";
            break;
        case 2:
            string = @"Nhập học";
            break;
        case 3:
            string = @"Nhận việc";
            break;
        case 4:
            string = @"Hôn thú";
            break;
        case 5:
            string = @"Khởi công xây dựng";
            break;
        case 6:
            string = @"Động thổ";
            break;
        case 7:
            string = @"Sữ chữa nhà";
            break;
        case 8:
            string = @"Khai trương";
            break;
        case 9:
            string = @"Mở cửa hàng";
            break;
        case 10:
            string = @"Giao dịch";
            break;
        case 11:
            string = @"Ký hợp đồng";
            break;
        case 12:
            string = @"Cầu tài";
            break;
        case 13:
            string = @"Mai táng";
            break;
        case 14:
            string = @"Sữa mộ";
            break;
        case 15:
            string = @"Cải mộ";
            break;
        case 16:
            string = @"Xuất hành";
            break;
        case 17:
            string = @"Cầu phúc";
            break;
        case 18:
            string = @"Chữa bệnh";
            break;
        case 19:
            string = @"Tranh chấp";
            break;
        case 20:
            string = @"Kiện tụng";
            break;
        case 21:
            string = @"Giải oan";
            break;
            
        default:
            break;
    }
    
    return string;
    
}

- (int)getSao:(int )x
{
    int y;
    if (x <= 0) {
        y = 0;
    }
    else if ( 0 < x && x <= 20 ) {
        y = 1;
    }
    else if ( 20 < x && x <= 40 ) {
        y = 2;
    }
    else if ( 40 < x && x <= 60 ) {
        y = 3;
    }
    else if ( 60 < x && x <= 80 ) {
        y = 4;
    }
    else if ( 80 < x) {
        y = 5;
    }
    else
    {
        //    NSLog(@"Không SAo");
    }
    return y;
}

- (BOOL )calculatorNamNhuan:(int)y
{
    BOOL namNhuan;
    int x;
    x = y % 19;
   
    switch (x) {
        case 0:
            namNhuan = YES;
            break;
        case 3:
            namNhuan = YES;
            break;
        case 6:
            namNhuan = YES;
            break;
        case 9:
            namNhuan = YES;
            break;
        case 11:
            namNhuan = YES;
            break;
        case 14:
            namNhuan = YES;
            break;
        case 17:
            namNhuan = YES;
            break;
            
        default:
            break;
    }
    
    return namNhuan;
    
}

- (int)getThangNhuan:(int)day month:(int)month year:(int)year lunarLeap:(int)lunarLeap timeZone:(int)timeZone
{
    long k, a11, b11, off, leapOff, leapMonth;
    
    if (month < 11)
    {
        a11 = [self getLunarMonth11:year-1 timeZone:timeZone];
        b11 = [self getLunarMonth11:year timeZone:timeZone];
    }
    else
    {
        a11 = [self getLunarMonth11:year timeZone:timeZone];
        b11 = [self getLunarMonth11:year+1 timeZone:timeZone];
    }
    
    k = (int)(0.5 + (a11 - 2415021.076998695) / 29.530588853);
    off = month - 11;
    if (off < 0)
    {
        off += 12;
    }
    
//    leapOff = [self getLeapMonthOffset:a11 timeZone:timeZone];
//    leapMonth = leapOff - 2;
    
    if (b11 - a11 > 365)
    {
        leapOff = [self getLeapMonthOffset:a11 timeZone:timeZone];
        leapMonth = leapOff - 2;
    }
    
    return (int)leapMonth;
}

//+ (NSArray *)getAllLunarMonthTitles(int[] arr_lunar_month_values, int scr_width) {
+ (NSArray *)getAllLunarMonthTitles:(NSArray *)arr_lunar_month_values scr:(int)scr_width { // (int[] arr_lunar_month_values, int scr_width)
    NSMutableArray *arr_lunar_month_titles = [[NSMutableArray alloc] init]; //new String[arr_lunar_month_values.length];
    for (int i = 0; i < arr_lunar_month_values.count; i++) {
        [arr_lunar_month_titles addObject:@""];
    }
    for (int i = 0; i < arr_lunar_month_values.count; i++) {
        if (scr_width > 240) {
//            arr_lunar_month_titles[i] = @"";
            int mm = [arr_lunar_month_values[i] intValue] / 100;
            switch (mm - 1) {
                case 0:
                    arr_lunar_month_titles[i] = @"01";
                    break;
                case 1:
                    arr_lunar_month_titles[i] = @"02";
                    break;
                case 2:
                    arr_lunar_month_titles[i] = @"03";
                    break;
                case 3:
                    arr_lunar_month_titles[i] = @"04";
                    break;
                case 4:
                    arr_lunar_month_titles[i] = @"05";
                    break;
                case 5:
                    arr_lunar_month_titles[i] = @"06";
                    break;
                case 6:
                    arr_lunar_month_titles[i] = @"07";
                    break;
                case 7:
                    arr_lunar_month_titles[i] = @"08";
                    break;
                case 8:
                    arr_lunar_month_titles[i] = @"09";
                    break;
                case 9:
                    arr_lunar_month_titles[i] = @"10";
                    break;
                case 10:
                    arr_lunar_month_titles[i] = @"11";
                    break;
                case 11:
                    arr_lunar_month_titles[i] = @"12";
                    break;
            }
        } else {
            arr_lunar_month_titles[i] = [NSString stringWithFormat:@"%d", i+1]; // "" + (i + 1);
        }
        if ([arr_lunar_month_values[i] intValue] % 10 > 0) {
            arr_lunar_month_titles[i]  = [NSString stringWithFormat:@"%@+", arr_lunar_month_titles[i]]; //+= "+";
        }
    }
    return arr_lunar_month_titles;
}

-(NSMutableArray *)getAllLunarDaysInSolarMonth:(int)solar_dd solar_mm:(int)solar_mm solar_yy:(int)solar_yy {
    TimeSL curr_lunar_day = [self convertSunToLunar:solar_dd month:solar_mm year:solar_yy timeZone:7];
    int start = (int)[self jdFromDate:solar_dd month:solar_mm year:solar_yy] - 31;
    NSMutableArray * vDays = [NSMutableArray array];
    int count = -1;
    while (count ++ < 62) {
        int jd = start + count;
        TimeSL s = [self jdToDate:jd];
        TimeSL dat = [self convertSunToLunar:s.day month:s.month year:s.year timeZone:7];
        if (dat.month == curr_lunar_day.month && dat.namNhuan == curr_lunar_day.namNhuan) {
            [vDays addObject:[NSString stringWithFormat:@"%d",dat.day]];
        }
    }
    if (vDays.count == 29) {
        [vDays addObject:@"30"];
    }
    return vDays;
}

-(NSMutableArray *)getAllLunarDaysInLunarMonth:(int)lunar_mm solar_mm:(int)lunar_yy solar_yy:(int)lunar_leap {
    int start = (int)[self jdFromDate:1 month:lunar_mm year:lunar_yy];
    NSMutableArray * vDays = [NSMutableArray array];
    int count = -1;
    while (count ++ < 100) {
        int jd = start + count;
        TimeSL s = [self jdToDate:jd];
        TimeSL dat = [self convertSunToLunar:s.day month:s.month year:s.year timeZone:7];
        if (dat.month == lunar_mm && dat.year == lunar_yy && dat.namNhuan == lunar_leap ) {
            [vDays addObject:[NSString stringWithFormat:@"%d",dat.day]];
        }
    }
    return vDays;
}

- (NSString *)tinhNgayTotXau:(int )x andCheck:(int)check
{
    NSString *descNgay;
    if (check == 0) {
    if (x <= -100) {
        descNgay = NgayRatXau;
    }
    else if ( -100 < x && x < 0 ) {
       descNgay = NgayXau;
    }
    else if ( 0 <= x && x <= 50 ) {
        descNgay = NgayBinhThuong;
    }
    else if ( 50 < x && x <= 100 ) {
        descNgay = NgayDep;
    }
    else if ( x > 100 ) {
        descNgay = NgayRatDep;
    }
    }else{
        if (x<=0) {
            descNgay = NgayRatXau;
        }
        else if (0 < x && x <= 100)
        {
            descNgay = NgayXau;
        }
        else{
            descNgay = NgayBinhThuong;
        }
    }
    return descNgay;
}

- (NSString *)convertSaotoText:(int)x andCheck:(int)check
{
    NSString *loaiNgay;
    if (check == 0) {
        if (x<=-100) {
            loaiNgay = @"RẤT XẤU";
        }
        else if (-100< x && x < 0)
        {
            loaiNgay = @"NGÀY XẤU";
        }
        else if (0 <= x && x <= 50)
        {
            loaiNgay = @"BÌNH THƯỜNG";
        }
        else if (50< x && x <= 100)
        {
            loaiNgay = @"NGÀY ĐẸP";
        }
        else{
            loaiNgay = @"RẤT ĐẸP";
        }
    }else{
        if (x<=0) {
            loaiNgay = @"RẤT XẤU";
        }
        else if (0 < x && x <= 100)
        {
            loaiNgay = @"NGÀY XẤU";
        }
        else{
            loaiNgay = @"BÌNH THƯỜNG";
        }
    }
    
    return loaiNgay;
}

- (NSMutableArray *)getAllLunarMonthsInYear:(int)d andMonth:(int)m andYear:(int)y
{
    TimeSL curr_lunar_data = [self convertSunToLunar:d month:m year:y timeZone:7];
    int curr_lunar_year = curr_lunar_data.year;
    long start = [self jdFromDate:1 month:1 year:curr_lunar_year];
    int step = 10;
    int count = -1;
    NSMutableArray *vMonths = [[NSMutableArray alloc]init];
    int last_lunar_day = 1000;
    while (count++ <= (366 + 32 + step) / step) {
        long jd = start + step * count;
        TimeSL s = [self jdToDate:jd];
        TimeSL dat = [self convertSunToLunar:s.day month:s.month year:s.year timeZone:7];
        if (dat.year == curr_lunar_year) {
            if (dat.day < last_lunar_day) {
           //     vMonths.add(dat[1] * 100 + dat[3]);
                [vMonths addObject:[NSString stringWithFormat:@"%d",(dat.month*100 + dat.namNhuan)]];
            }
            last_lunar_day = dat.day;
            if (vMonths.count >= 13) {
                break;
            }
        }
    }
    NSMutableArray *all_days =  [NSMutableArray new];
    for (int i = 0; i < vMonths.count; i++) {
      //  all_days[i] = (int) vMonths[i];
        [all_days addObject:vMonths[i]];
    }
    return all_days;
}

- (NSMutableArray *)getAllLunarMonthTitles:(NSMutableArray *)arr_lunar_month_values andScr_width:(int)scr_width
{
    NSMutableArray *arr_lunar_month_titles = [[NSMutableArray alloc]init];
    for (int i = 1; i <13; i++) {
        [arr_lunar_month_titles addObject:@""];
    }
  //  [arr_lunar_month_titles addObject:<#(nonnull id)#>]
    for (int i = 0; i < arr_lunar_month_values.count; i++) {
        if (scr_width > 240) {
            arr_lunar_month_values[i] = @"";
            int mm = [arr_lunar_month_values[i] intValue] /100;
            switch (mm - 1) {
                case 0:
                arr_lunar_month_titles[i] = [NSString stringWithFormat:@"01"];

                    break;
                case 1:
                arr_lunar_month_titles[i] = [NSString stringWithFormat:@"02"];
                    break;
                case 2:
                    arr_lunar_month_titles[i] = [NSString stringWithFormat:@"03"];
                    break;
                case 3:
                 arr_lunar_month_titles[i] = [NSString stringWithFormat:@"04"];
                    break;
                case 4:
                 arr_lunar_month_titles[i] = [NSString stringWithFormat:@"05"];
                    break;
                case 5:
               arr_lunar_month_titles[i] = [NSString stringWithFormat:@"06"];
                    break;
                case 6:
                  arr_lunar_month_titles[i] = [NSString stringWithFormat:@"07"];
                    break;
                case 7:
                arr_lunar_month_titles[i] = [NSString stringWithFormat:@"08"];
                    break;
                case 8:
                  arr_lunar_month_titles[i] = [NSString stringWithFormat:@"09"];
                    break;
                case 9:
                arr_lunar_month_titles[i] = [NSString stringWithFormat:@"10"];
                    break;
                case 10:
              arr_lunar_month_titles[i] = [NSString stringWithFormat:@"11"];
                    break;
                case 11:
               arr_lunar_month_titles[i] = [NSString stringWithFormat:@"12"];
                    break;
            }
        } else {
         //   arr_lunar_month_titles[i] = [NSString stringWithFormat:@"12"];
            [arr_lunar_month_titles insertObject:[NSString stringWithFormat:@"%d",i+1] atIndex:i+1];
            
        }
        if ([arr_lunar_month_values[i] intValue] % 10 > 0) {
            [arr_lunar_month_values[i] addObject:[NSString stringWithFormat:@"%@+",arr_lunar_month_titles[i]]];
          //  arr_lunar_month_titles[i] += "+";
        }
    }
    return arr_lunar_month_titles;
}

- (NSInteger )getDayFromDate:(NSDate *)date {
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* comp = [cal components:kCFCalendarUnitWeekday fromDate:date];
    NSInteger nday = [comp weekday];
  //  NSString *day;
//    switch (nday) {
//        case 1:
//            day = @"Chủ nhật";
//            break;
//        case 2:
//            day = @"Thứ 2";
//            break;
//        case 3:
//            day = @"Thứ 3";
//            break;
//        case 4:
//            day = @"Thứ 4";
//            break;
//        case 5:
//            day = @"Thứ 5";
//            break;
//        case 6:
//            day = @"Thứ 6";
//            break;
//        case 7:
//            day = @"Thứ 7";
//            break;
//        default:
//            break;
//    }
    return nday;
}





@end
