#ifndef SRC_DND_OBSERVER_H_
#define SRC_DND_OBSERVER_H_

#include "nan.h"

class DndManager : public Nan::ObjectWrap {
 public:
  void HandleDndChanged();

  static NAN_METHOD(New);

 private:
  DndManager(v8::Isolate* isolate, Nan::Callback *callback);
  ~DndManager();

  v8::Isolate* isolate() { return isolate_; }

  v8::Isolate *isolate_;
  Nan::Callback *callback;
};

#endif  // SRC_DND_OBSERVER_H_
