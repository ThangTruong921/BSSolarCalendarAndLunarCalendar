//
//  ViewController.m
//  TestThuatToan
//
//  Created by NguyenKimTai on 5/9/16.
//  Copyright © 2016 NguyenKimTai. All rights reserved.
//

#import "ViewController.h"
#import "Lunar.h"
#import "BSCalendar.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *t1;
@property (weak, nonatomic) IBOutlet UITextField *t2;
@property (weak, nonatomic) IBOutlet UITextField *t3;
@property (weak, nonatomic) IBOutlet UITextField *t4;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)convert:(id)sender {
//    int start = [self jdFromDate:[_t1.text intValue]  month:[_t2.text intValue] year:[_t3.text intValue]];
//    int step = 15;
//    int count = -1;
//    while (count++ < 30) {
//        int jd = start+step*count;
//        NSArray * s = [self jdToDate:start];
//        NSArray * l = [self convertSolar2Lunar:[s[0] intValue] mm:[s[1] intValue] yy:[s[2] intValue]];
//        NSArray * s2 = [self convertLunar2Solar:[l[0] intValue] lunarMonth:[l[1] intValue] lunarYear:[l[2] intValue] lunarLeap:[l[3] intValue]];
//        
//        if ([s[0] intValue] == [s2[0] intValue] && [s[1] intValue] == [s2[1] intValue] && [s[2] intValue] == [s2[2] intValue]) {
//            NSLog(@"OK! %@-%@-%@ => %@-%@-%@",s[0],s[1],s[2],l[0],l[1],l[2]);
//        } else {
//        }
//        
//        
//        
//        [self getAllLunarMonthsInLunarYear:[_t3.text intValue]];
//        NSArray * s21 = [self convertLunar2Solar:[_t1.text intValue] lunarMonth:[_t2.text intValue] lunarYear:[_t3.text intValue] lunarLeap:[_t4.text intValue]];
//        NSLog(@"%@-%@-%@",s21[0],s21[1],s21[2]);
//        
//    }
//}

- (int)jdFromDate:(int)dd month:(int)mm year:(int)yy {
    
    int a = (14 - mm) / 12;
    int y = yy+4800-a;
    int m = mm+12*a-3;
    int jd = dd + (153*m+2)/5 + 365*y + y/4 - y/100 + y/400 - 32045;
    if (jd < 2299161) {
        jd = dd + (153*m+2)/5 + 365*y + y/4 - 32083;
    }
    return jd;
}
- (NSMutableArray *)jdToDate:(int)jd {
    int a,b,c;
    if (jd > 2299160) {
        a = jd + 32044;
        b = (4*a+3)/146097;
        c = a - (b*146097)/4;
    }else {
        
        b = 0;
        c = jd + 32082;
        
    }
    int d = (4 * c + 3) / 1461;
    int e = c - (1461 * d) / 4;
    int m = (5 * e + 2) / 153;
    int day = e - (153 * m + 2) / 5 + 1;
    int month = m + 3 - 12 * (m / 10);
    int year = b * 100 + d - 4800 + m / 10;
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"%d",day]];
    [array addObject:[NSString stringWithFormat:@"%d",month]];
    [array addObject:[NSString stringWithFormat:@"%d",year]];
    return array;
    
}

- (double)NewMoonAA98:(int)k {
    double T = k / 1236.85;
    double T2 = T * T;
    double T3 = T2 * T;
    double dr = PI / 180;
    double Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2
    - 0.000000155 * T3;
    Jd1 = Jd1 + 0.00033
    * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr);
    double M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347
    * T3;
    double Mpr = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236
    * T3;
    double F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239
    * T3;
    double C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021
    * sin(2 * dr * M);
    C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
    C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
    C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051
    * sin(dr * (M + Mpr));
    C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004
    * sin(dr * (2 * F + M));
    C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006
    * sin(dr * (2 * F + Mpr));
    C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005
    * sin(dr * (2 * Mpr + M));
    double deltat;
    if (T < -11) {
        deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3
        - 0.000000081 * T * T3;
    } else {
        deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
    }
    ;
    double JdNew = Jd1 + C1 - deltat;
    return JdNew;
    
}

-(int)INT:(double)d {
    
    return (int)floor(d);
}

- (int)getNewMoonDay:(int)k timeZone:(double)timeZone {
    double jd = [self NewMoonAA98:k];
    return [self INT:(jd + 0.5 + timeZone / 24)];
}

- (double)SunLongitude:(double)jdn {
    return [self SunLongitudeAA98:jdn];
}


- (double)SunLongitudeAA98:(double)jdn {
    double T = (jdn - 2451545.0) / 36525;
    double T2 = T * T;
    double dr = PI / 180;
    double M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048
    * T * T2;
    double L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2;
    double DL = (1.914600 - 0.004817 * T - 0.000014 * T2)
    * sin(dr * M);
    DL = DL + (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290
    * sin(dr * 3 * M);
    double L = L0 + DL;
    L = L - 360 * ([self INT:(L / 360)]);
    return L;
    
}

- (double)getSunLongitude:(int)dayNumber timeZone:(double)timeZone {
    
    return [self SunLongitude:(dayNumber - 0.5 - timeZone / 24)];
}
- (int)getLunarMonth11:(int)yy timeZone:(double)timeZone {
    double off = [self jdFromDate:31 month:12 year:yy] - 2415021.076998695;
    int k = [self INT:(off / 29.530588853)];
    int nm = [self getNewMoonDay:k timeZone:timeZone];
    
    int sunLong = [self INT:([self getSunLongitude:nm timeZone:timeZone] / 30)];
    if (sunLong >= 9) {
        nm = [self getNewMoonDay:(k-1) timeZone:timeZone];
    }
    return nm;
    
}

- (int)getLeapMonthOffset:(int)a11 timeZone:(double)timeZone {
    
    int k =[self INT:(0.5 + (a11 - 2415021.076998695) / 29.530588853)];
    int last;
    int i = 1;
    int arc = [self INT:([self getSunLongitude:[self getNewMoonDay:(k+i) timeZone:timeZone] timeZone:timeZone]/30)];
    do {
        last = arc;
        i++;
        arc = [self INT:([self getSunLongitude:[self getNewMoonDay:(k+i) timeZone:timeZone] timeZone:timeZone]/30)];
    } while (arc != last && i < 14);
    return i - 1;
}
- (NSMutableArray *)convertSolar2Lunar:(int)dd mm:(int)mm yy:(int)yy {
    int lunarDay, lunarMonth, lunarYear, lunarLeap;
    int dayNumber = [self jdFromDate:dd month:mm year:yy];
    int k = [self INT:((dayNumber - 2415021.076998695) / 29.530588853)];
    int monthStart = [self getNewMoonDay:(k + 1) timeZone:7];
    if (monthStart > dayNumber) {
        monthStart = [self getNewMoonDay:k timeZone:7];
    }
    int a11 = [self getLunarMonth11:yy timeZone:7];
    int b11 = a11;
    if (a11 >= monthStart) {
        lunarYear = yy;
        a11 = [self getLunarMonth11:(yy-1) timeZone:7];
        
    } else {
        lunarYear = yy + 1;
        b11 = [self getLunarMonth11:(yy + 1) timeZone:7];
    }
    lunarDay = dayNumber - monthStart + 1;
    int diff = [self INT:((monthStart - a11) / 29)];
    lunarLeap = 0;
    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
        int leapMonthDiff = [self getLeapMonthOffset:a11 timeZone:7];
        if (diff >= leapMonthDiff) {
            lunarMonth = diff + 10;
            if (diff == leapMonthDiff) {
                lunarLeap = 1;
            }
        }
    }
    if (lunarMonth > 12) {
        lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
        lunarYear -= 1;
    }
    //    return new int[]{lunarDay, lunarMonth, lunarYear, lunarLeap};
    
    NSMutableArray * array = [NSMutableArray array];
    [array addObject:[NSString stringWithFormat:@"%d",lunarDay]];
    [array addObject:[NSString stringWithFormat:@"%d",lunarMonth]];
    [array addObject:[NSString stringWithFormat:@"%d",lunarYear]];
    [array addObject:[NSString stringWithFormat:@"%d",lunarLeap]];
    
    return array;
}

- (NSMutableArray *)convertLunar2Solar:(int)lunarDay lunarMonth:(int)lunarMonth lunarYear:(int)lunarYear lunarLeap:(int)lunarLeap {
    
    
    int a11, b11;
    if (lunarMonth < 11) {
        a11 = [self getLunarMonth11:(lunarYear - 1) timeZone:7];
        b11 = [self getLunarMonth11:lunarYear timeZone:7];
    } else {
        a11 = [self getLunarMonth11:lunarYear timeZone:7];
        b11 = [self getLunarMonth11:(lunarYear + 1) timeZone:7];
    }
    int k = [self INT:(0.5 + (a11 - 2415021.076998695) / 29.530588853)];
    int off = lunarMonth - 11;
    if (off < 0) {
        off += 12;
    }
    if (b11 - a11 > 365) {
        int leapOff = [self getLeapMonthOffset:a11 timeZone:7];
        int leapMonth = leapOff - 2;
        if (leapMonth < 0) {
            leapMonth += 12;
        }
        if (lunarLeap != 0 && lunarMonth != leapMonth) {
            NSMutableArray * array = [NSMutableArray array];
        } else if (lunarLeap != 0 || off >= leapOff) {
            off += 1;
        }
    }
    int monthStart = [self getNewMoonDay:(k + off) timeZone:7];
    NSMutableArray * array1 = [NSMutableArray array];
    array1 = [self jdToDate:(monthStart + lunarDay -1)];
    
    return array1;
    
}

- (BOOL)Namnhuan:(int)yy {
    if ((yy % 4 == 0 && yy % 100 != 0) || (yy % 400 == 0)){
        return true;// nam nhuan,0
    }else {
        return false; // khong nhuan,1
    }
    
}

- (int)getTotalDaysInMonth:(int)mm yy:(int)yy {
    if (![self Namnhuan:yy]) {
        if (mm == 1 || mm == 3 || mm == 5 || mm == 7 || mm == 8 || mm == 10
            || mm == 12)
            return 31;
        else if (mm == 4 || mm == 6 || mm == 9 || mm == 11)
            return 30;
        else if (mm == 2)
            return 28;
    } else if ([self Namnhuan:yy]) {
        if (mm == 1 || mm == 3 || mm == 5 || mm == 7 || mm == 8 || mm == 10
            || mm == 12)
            return 31;
        else if (mm == 4 || mm == 6 || mm == 9 || mm == 11)
            return 30;
        else if (mm == 2)
            return 29;
    }
    return 1;
}

- (NSMutableArray *)getAllLunarMonthTitles:(NSMutableArray *)arr_lunar_month_values scr_width:(int)scr_width {
    NSMutableArray * arr_lunar_month_titles = [NSMutableArray array];
    
    for (int i = 0 ; i < arr_lunar_month_values.count; i++) {
        [arr_lunar_month_titles addObject:@""];
    }
    
    
    for (int i = 0; i < arr_lunar_month_values.count; i++) {
        if (scr_width > 240) {
            int mm = [arr_lunar_month_values[i] intValue] / 100;
            switch (mm - 1) {
                case 0:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"01"];
                    break;
                case 1:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"02"];
                    break;
                case 2:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"02"];
                    break;
                case 3:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"04"];
                    break;
                case 4:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"05"];
                    break;
                case 5:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"06"];
                    break;
                case 6:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"07"];
                    break;
                case 7:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"08"];
                    break;
                case 8:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"09"];
                    break;
                case 9:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"10"];
                    break;
                case 10:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"11"];
                    break;
                case 11:
                    [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"12"];
                    break;
            }
        } else {
            [arr_lunar_month_titles replaceObjectAtIndex:(i+1) withObject:[NSString stringWithFormat:@"%d",(i+1)]];
        }
        if ([arr_lunar_month_values[i] intValue] % 10 > 0) {
            [arr_lunar_month_titles replaceObjectAtIndex:i withObject:@"N"];
        }
    }
    return arr_lunar_month_titles;
    
}

- (NSMutableArray *)getAllLunarMonthsInYear:(int)solar_dd solar_mm:(int)solar_mm solar_yy:(int)solar_yy {
    NSMutableArray * curr_lunar_data = [[NSMutableArray alloc]init];
    [curr_lunar_data addObjectsFromArray:[self convertSolar2Lunar:solar_dd mm:solar_mm yy:solar_yy]];
    NSString * curr_lunar_year = curr_lunar_data[2];
    
    int start = [self jdFromDate:1 month:1 year:[curr_lunar_year intValue]];
    int step = 10;
    int count = -1;
    NSMutableArray * vMonths = [[NSMutableArray alloc]init];
    int last_lunar_day = 1000;
    while (count++ <= (366 + 32 + step) / step) {
        int jd = start + step * count;
        NSMutableArray * s = [[NSMutableArray alloc]init];
        [s addObjectsFromArray:[self jdToDate:jd]];
        NSMutableArray * dat = [[NSMutableArray alloc]init];
        [dat addObjectsFromArray:[self convertSolar2Lunar:[s[0] intValue] mm:[s[1] intValue] yy:[s[2] intValue]]];
        if (dat[2] == curr_lunar_year) {
            if ([dat[0] intValue] < last_lunar_day) {
                [vMonths addObject:[NSString stringWithFormat:@"%d",([dat[1] intValue] * 100 + [dat[3] intValue])]];
            }
            last_lunar_day = [dat[0] intValue];
            if (vMonths.count >= 13) {
                break;
            }
        }
    }
    NSMutableArray * all_days = [[NSMutableArray alloc]init];
    for (int i = 0; i < vMonths.count; i++) {
        [all_days addObject:@""];
    }
    for (int i = 0; i < vMonths.count; i++) {
        [all_days replaceObjectAtIndex:i withObject:vMonths[i]];
    }
    return all_days;
}

- (NSMutableArray *)getAllLunarMonthsInLunarYear:(int)lunar_yy {
    int curr_lunar_year = lunar_yy;
    int start = [self jdFromDate:1 month:1 year:lunar_yy] - 64;
    int step = 10;
    int count = -1;
    NSMutableArray * vMonths = [[NSMutableArray alloc]init];
    int last_lunar_day = 1000;
    while (count++ <= (366 + 96 + step) / step) {
        int jd = start + step * count;
        NSMutableArray * s = [[NSMutableArray alloc]init];
        [s addObjectsFromArray:[self jdToDate:jd]];
        NSMutableArray * dat = [[NSMutableArray alloc]init];
        [dat addObjectsFromArray:[self convertSolar2Lunar:[s[0] intValue] mm:[s[1] intValue] yy:[s[2] intValue]]];
        if ([dat[2] intValue] == curr_lunar_year) {
            if ([dat[0] intValue] < last_lunar_day) {
                [vMonths addObject:[NSString stringWithFormat:@"%d",([dat[1] intValue] * 100 + [dat[3] intValue])]];
            }
            last_lunar_day = [dat[0] intValue];
            if (vMonths.count >= 13) {
                break;
            }
        }
    }
    NSMutableArray * all_days = [[NSMutableArray alloc]init];
    for (int i = 0; i < vMonths.count; i++) {
        [all_days addObject:@""];
    }
    for (int i = 0; i < vMonths.count; i++) {
        [all_days replaceObjectAtIndex:i withObject:vMonths[i]];
    }
    return all_days;
    
}

- (NSMutableArray *)getAllLunarDaysInLunarMonth:(int)lunar_mm lunar_yy:(int)lunar_yy lunar_leap:(int)lunar_leap {
    int start = [self jdFromDate:1 month:lunar_mm year:lunar_yy];
    int count = -1;
    NSMutableArray * vDays = [[NSMutableArray alloc]init];
    while (count++ < 100) {
        int jd = start + count;
        NSMutableArray * s = [[NSMutableArray alloc]init];
        [s addObjectsFromArray:[self jdToDate:jd]];
        NSMutableArray * dat = [[NSMutableArray alloc]init];
        [dat addObjectsFromArray:[self convertSolar2Lunar:[s[0] intValue] mm:[s[1] intValue] yy:[s[2] intValue]]];
        if ([dat[1] intValue] == lunar_mm && [dat[2] intValue] == lunar_yy && [dat[3] intValue] == lunar_leap) {
            [vDays addObject:dat[0]];
        }
    }
    NSMutableArray * all_days = [[NSMutableArray alloc]init];
    for (int i = 0; i < vDays.count; i++) {
        [all_days addObject:@""];
    }
    
    for (int i = 0; i < vDays.count; i++) {
        [all_days replaceObjectAtIndex:i withObject:vDays[i]];
    }
    return all_days;
    
}

- (NSMutableArray *)getAllLunarDaysInSolarMonth:(int)solar_dd solar_mm:(int)solar_mm solar_yy:(int)solar_yy {
    NSMutableArray * curr_lunar_day = [[NSMutableArray alloc]init];
    [curr_lunar_day addObjectsFromArray:[self convertSolar2Lunar:solar_dd mm:solar_mm yy:solar_yy]];
    
    int start = [self jdFromDate:solar_dd month:solar_mm year:solar_yy] -31;
    int count = -1;
    NSMutableArray * vDays = [[NSMutableArray alloc]init];
    
    while (count++ < 62) {
        int jd = start + count;
        NSMutableArray * s = [[NSMutableArray alloc]init];
        [s addObjectsFromArray:[self jdToDate:jd]];
        NSMutableArray * dat = [[NSMutableArray alloc]init];
        [dat addObjectsFromArray:[self convertSolar2Lunar:[s[0] intValue] mm:[s[1] intValue] yy:[s[2] intValue]]];
        if ([dat[1] intValue] == [curr_lunar_day[1] intValue] && [dat[3] intValue] == [curr_lunar_day[3] intValue]) {
            [vDays addObject:dat[0]];
        }
    }
    NSMutableArray * all_days = [[NSMutableArray alloc]init];
    for (int i = 0; i < vDays.count; i++) {
        [all_days addObject:@""];
    }
    
    for (int i = 0; i < vDays.count; i++) {
        [all_days replaceObjectAtIndex:i withObject:vDays[i]];
    }
    return all_days;
    
}

- (NSMutableArray *)findSolarDateFromLunar:(int)lunar_dd lunar_mm:(int)lunar_mm lunar_yy:(int)lunar_yy lunar_leap:(int)lunar_leap {
    int start = [self jdFromDate:lunar_dd month:lunar_mm year:lunar_yy];
    int count = -1;
    while (count++ < 96) {
        int jd = start + count;
        NSMutableArray * s = [[NSMutableArray alloc]init];
        [s addObjectsFromArray:[self jdToDate:jd]];
        NSMutableArray * l = [[NSMutableArray alloc]init];
        [l addObjectsFromArray:[self convertSolar2Lunar:[s[0] intValue] mm:[s[1] intValue] yy:[s[2] intValue]]];
        if ([l[0] intValue] == lunar_dd && [l[1] intValue] == lunar_mm && [l[2] intValue] == lunar_yy && [l[3] intValue] == lunar_leap) {
            return s;
        }
    }
    start -= 60;
    count = -1;
    while (count++ < 120) {
        int jd = start + count;
        NSMutableArray * s = [[NSMutableArray alloc]init];
        [s addObjectsFromArray:[self jdToDate:jd]];
        NSMutableArray * l = [[NSMutableArray alloc]init];
        [l addObjectsFromArray:[self convertSolar2Lunar:[s[0] intValue] mm:[s[1] intValue] yy:[s[2] intValue]]];
        if ([l[0] intValue] == lunar_dd && [l[1] intValue] == lunar_mm && [l[2] intValue] == lunar_yy && [l[3] intValue] == lunar_leap) {
            return s;
        }
    }
    return nil;
    
}

@end
