#import <Cocoa/Cocoa.h>
#import <dispatch/dispatch.h>

#import <Carbon/Carbon.h>
#import "dnd-manager.h"
#import "dnd-observer.mm"
#include <vector>
#include <string>
#include <cctype>

using namespace v8;

uv_loop_t *loop = uv_default_loop();
uv_async_t async;

static NSString *const kDndKeyPath = @"doNotDisturb";
static NSString *const kNotificationCenterKey = @"com.apple.notificationcenterui";

static void asyncSendHandler(uv_async_t *handle) {
  (static_cast<DndManager *>(handle->data))->HandleDndChanged();
}

static void RemoveCFObserver(void *arg) {
  auto manager = static_cast<DndManager*>(arg);
  // [manager->observer dealloc];
}

DndManager::DndManager(v8::Isolate *isolate, Nan::Callback *callback) : isolate_(isolate), callback(callback) {
  uv_async_init(loop, &async, (uv_async_cb) asyncSendHandler);

  auto observer = [[DndObserver alloc] initWithCallback:^() {
    async.data = this;
    uv_async_send(&async);
  }];

  [[[NSUserDefaults alloc] initWithSuiteName:kNotificationCenterKey]
    addObserver:observer
    forKeyPath:kDndKeyPath
    options:NSKeyValueObservingOptionNew
    context:nil
  ];

#if NODE_MAJOR_VERSION >= 10
  node::AddEnvironmentCleanupHook(
    isolate,
    RemoveCFObserver,
    const_cast<void*>(static_cast<const void*>(nullptr)));
#endif
}

DndManager::~DndManager() {
#if NODE_MAJOR_VERSION >= 10
  node::RemoveEnvironmentCleanupHook(
    isolate(),
    RemoveCFObserver,
    const_cast<void*>(static_cast<const void*>(this))
  );
#endif
  RemoveCFObserver(this);
  delete callback;
};

void DndManager::HandleDndChanged() {
  Nan::AsyncResource async_resource("DndManager:HandleDndChanged");
  callback->Call(0, NULL, &async_resource);
}
