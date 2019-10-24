#include "dnd-manager.h"

using namespace v8;

NAN_MODULE_INIT(init) {
  Nan::HandleScope scope;
  Local<FunctionTemplate> newTemplate = Nan::New<FunctionTemplate>(DndManager::New);
  newTemplate->SetClassName(Nan::New<String>("DndManager").ToLocalChecked());
  newTemplate->InstanceTemplate()->SetInternalFieldCount(1);
  newTemplate->PrototypeTemplate();

  Nan::Set(target, Nan::New("DndManager").ToLocalChecked(), Nan::GetFunction(newTemplate).ToLocalChecked());
}

#if NODE_MAJOR_VERSION >= 10
NAN_MODULE_WORKER_ENABLED(dnd_manager, init)
#else
NODE_MODULE(dnd_manager, init)
#endif

NAN_METHOD(DndManager::New) {
  Nan::HandleScope scope;

  Local<Function> callbackHandle = info[0].As<Function>();
  Nan::Callback *callback = new Nan::Callback(callbackHandle);

  DndManager *manager = new DndManager(info.GetIsolate(), callback);
  manager->Wrap(info.This());
  return;
}
