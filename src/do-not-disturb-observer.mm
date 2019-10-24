#import <Foundation/Foundation.h>

@interface DoNotDisturbObserver : NSObject

typedef void(^ChangedCallback)(void);

@property (nonatomic, copy) ChangedCallback callback;

- (instancetype)initWithCallback:(ChangedCallback)callback;

@end

@implementation DoNotDisturbObserver : NSObject

static NSString *const kDndKeyPath = @"doNotDisturb";
static NSString *const kNotificationCenterKey = @"com.apple.notificationcenterui";

- (instancetype)initWithCallback:(ChangedCallback)callback
{
  if (self = [super init])
  {
    NSLog(@"DoNotDisturbObserver::initWithCallback");

    _callback = callback;

    [[[NSUserDefaults alloc] initWithSuiteName:kNotificationCenterKey]
      addObserver:self
      forKeyPath:kDndKeyPath
      options:NSKeyValueObservingOptionNew
      context:nil
    ];
  }

  return self;
}

- (void)dealloc
{
  NSLog(@"DoNotDisturbObserver::dealloc");

  [super dealloc];

  [[[NSUserDefaults alloc] initWithSuiteName:kNotificationCenterKey]
    removeObserver:self
    forKeyPath:kDndKeyPath
  ];

  _callback = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
  ofObject:(id)object
  change:(NSDictionary *)change
  context:(void *)context
{
  NSLog(@"DoNotDisturbObserver::observeValueForKeyPath: %@", keyPath);

  if ([keyPath isEqualToString:kDndKeyPath])
  {
    [self callback];
  }
}

@end
