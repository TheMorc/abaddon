#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#include "quicklook.h"

@interface QuickLookDelegate : NSObject <QLPreviewPanelDataSource, QLPreviewPanelDelegate>
@property (nonatomic, strong) NSURL *fileURL;
@end

@implementation QuickLookDelegate
- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    return 1;
}

- (id<QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return self.fileURL;
}
@end

static QuickLookDelegate *quickLookDelegate = nil;

void QuickLook(const char* filePath) {
    @autoreleasepool {
        NSString *nsFilePath = [NSString stringWithUTF8String:filePath];
        NSURL *fileURL = [NSURL fileURLWithPath:nsFilePath];

        if (!quickLookDelegate) {
            quickLookDelegate = [[QuickLookDelegate alloc] init];
        }
        quickLookDelegate.fileURL = fileURL;

        dispatch_async(dispatch_get_main_queue(), ^{
            QLPreviewPanel *panel = [QLPreviewPanel sharedPreviewPanel];
            [panel setDelegate:quickLookDelegate];
            [panel setDataSource:quickLookDelegate];
            [panel makeKeyAndOrderFront:nil];
        });
    }
}