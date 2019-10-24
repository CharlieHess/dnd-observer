#import <Cocoa/Cocoa.h>
#import <dispatch/dispatch.h>

#import <Carbon/Carbon.h>
#import "keyboard-layout-manager.h"
#import "do-not-disturb-observer.mm"
#include <vector>
#include <string>
#include <cctype>

using namespace v8;

uv_loop_t *loop = uv_default_loop();
uv_async_t async;

static void asyncSendHandler(uv_async_t *handle) {
  (static_cast<KeyboardLayoutManager *>(handle->data))->HandleKeyboardLayoutChanged();
}

static void RemoveCFObserver(void *arg) {
  auto manager = static_cast<KeyboardLayoutManager*>(arg);
  // [manager->observer dealloc];
}

KeyboardLayoutManager::KeyboardLayoutManager(v8::Isolate *isolate, Nan::Callback *callback) : isolate_(isolate), callback(callback) {
  uv_async_init(loop, &async, (uv_async_cb) asyncSendHandler);

  auto observer = [[DoNotDisturbObserver alloc] initWithCallback:^() {
    async.data = this;
    uv_async_send(&async);
  }];

#if NODE_MAJOR_VERSION >= 10
  node::AddEnvironmentCleanupHook(
    isolate,
    RemoveCFObserver,
    const_cast<void*>(static_cast<const void*>(nullptr)));
#endif
}

KeyboardLayoutManager::~KeyboardLayoutManager() {
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

void KeyboardLayoutManager::HandleKeyboardLayoutChanged() {
  Nan::AsyncResource async_resource("keyboard_layout:HandleKeyboardLayoutChanged");
  callback->Call(0, NULL, &async_resource);
}

NAN_METHOD(KeyboardLayoutManager::GetCurrentKeyboardLayout) {
  Nan::HandleScope scope;
  TISInputSourceRef source = TISCopyCurrentKeyboardInputSource();
  CFStringRef sourceId = (CFStringRef) TISGetInputSourceProperty(source, kTISPropertyInputSourceID);
  info.GetReturnValue().Set(Nan::New([(NSString *)sourceId UTF8String]).ToLocalChecked());
}
