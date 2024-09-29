//
//  DebugLogSearchResult.m
//  PerfectDebug
//
//  Created by pwrd on 2022/8/5.
//

#import "DebugLogSearchResult.h"


@implementation DebugLogSearchResult

- (instancetype)initWithModel:(DebugLogModel *)model searchAttrStr:(NSAttributedString *)searchAttrStr {
    if (self = [super initWithTag:model.tag contentDic:model.contentDic timeStamp:model.timeStamp]) {
        self.searchAttrStr = searchAttrStr;
    }
    return self;
}

@end
