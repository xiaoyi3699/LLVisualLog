//
//  UIWindow+LLAddPart.m
//  LLFeatureStatic
//
//  Created by WangZhaomeng on 2018/1/11.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "UIWindow+LLAddPart.h"
#import <objc/runtime.h>
#include <sys/sysctl.h>
#include <mach/mach.h>

@implementation UIWindow (LLAddPart)

static char fpsKey;
static char cupKey;

- (UILabel *)fpsLabel
{
    return objc_getAssociatedObject(self, &fpsKey);
}

- (void)setFpsLabel:(UILabel *)fpsLabel
{
    objc_setAssociatedObject(self, &fpsKey, fpsLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)cpuLabel
{
    return objc_getAssociatedObject(self, &cupKey);
}

- (void)setCpuLabel:(UILabel *)cpuLabel
{
    objc_setAssociatedObject(self, &cupKey, cpuLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)startObserveFpsAndCpu {
    
    CGFloat centerX = self.bounds.size.width/2;
    
    if (self.fpsLabel == nil) {
        self.fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX-75, 0, 40, 20)];
        self.fpsLabel.textColor = [UIColor blueColor];
        self.fpsLabel.textAlignment = NSTextAlignmentRight;
        self.fpsLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.fpsLabel];
    }
    
    if (self.cpuLabel == nil) {
        self.cpuLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX+35, 0, 40, 20)];
        self.cpuLabel.textColor = [UIColor blueColor];
        self.cpuLabel.textAlignment = NSTextAlignmentLeft;
        self.cpuLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.cpuLabel];
    }
    
    [[CADisplayLink displayLinkWithTarget:self selector:@selector(ll_refreshFps:)] addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)ll_refreshFps:(CADisplayLink *)link {
    static NSTimeInterval lastTime = 0;
    static int frameCount = 0;
    if (lastTime == 0) {
        lastTime = link.timestamp;
        return;
    }
    //累计帧数
    frameCount++;
    //累计时间
    NSTimeInterval passTime = link.timestamp - lastTime;
    //1秒左右获取一次帧数
    if (passTime > .5) {
        //帧数 = 总帧数/时间
        int fps = ceil(frameCount/passTime);
        //重置
        lastTime = link.timestamp;
        frameCount = 0;
        
        self.fpsLabel.text = [NSString stringWithFormat:@"%d",fps];
        self.cpuLabel.text = [NSString stringWithFormat:@"%d%%",[self ll_cpuUsage]];
    }
}

///CPU使用量
- (int)ll_cpuUsage
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t        thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t    thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0;
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < (int)thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return roundf(tot_cpu);
}

@end
