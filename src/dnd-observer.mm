#import <Foundation/Foundation.h>

@interface DndObserver : NSObject

typedef void(^ChangedCallback)(void);

@property (nonatomic, copy) ChangedCallback callback;

- (instancetype)initWithCallback:(ChangedCallback)callback;

@end

@implementation DndObserver : NSObject

- (instancetype)initWithCallback:(ChangedCallback)callback
{
  if (self = [super init])
  {
    NSLog(@"DndObserver::initWithCallback");
    _callback = callback;
  }

  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
  ofObject:(id)object
  change:(NSDictionary *)change
  context:(void *)context
{
  NSLog(@"DndObserver::observeValueForKeyPath: %@", keyPath);

  if ([keyPath isEqualToString:@"doNotDisturb"])
  {
    [self callback];
  }
}

@end
