'use strict'

const Emitter = require('event-kit').Emitter
const { DndManager } = require('../build/Release/dnd-manager.node')

const emitter = new Emitter()

const manager = new DndManager(() => {
  emitter.emit('did-change-dnd')
})

function onDndChanged (callback) {
  return emitter.on('did-change-dnd', callback)
}

module.exports = {
  onDndChanged: onDndChanged,
}
