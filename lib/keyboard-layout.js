'use strict'

const Emitter = require('event-kit').Emitter
const { KeyboardLayoutManager } = require('../build/Release/keyboard-layout-manager.node')

const emitter = new Emitter()

const manager = new KeyboardLayoutManager(() => {
  emitter.emit('did-change-current-keyboard-layout', getCurrentKeyboardLayout())
})

function getCurrentKeyboardLayout () {
  return manager.getCurrentKeyboardLayout()
}

function onDidChangeCurrentKeyboardLayout (callback) {
  return emitter.on('did-change-current-keyboard-layout', callback)
}

function observeCurrentKeyboardLayout (callback) {
  callback(getCurrentKeyboardLayout())
  return onDidChangeCurrentKeyboardLayout(callback)
}

module.exports = {
  getCurrentKeyboardLayout: getCurrentKeyboardLayout,
  onDidChangeCurrentKeyboardLayout: onDidChangeCurrentKeyboardLayout,
  observeCurrentKeyboardLayout: observeCurrentKeyboardLayout
}
