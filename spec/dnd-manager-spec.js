'use strict'

const DndManager = require('../lib/dnd-manager')

describe('DndManager', () => {
  describe('onDndChanged', () => {
    it('should notify when do not disturb changes', function (done) {
      let secondsLeft = 10

      const interval = setInterval(() => {
        process.stdout.clearLine()
        process.stdout.cursorTo(5)
        process.stdout.write(`Please toggle Do Not Disturb. ${secondsLeft} seconds remaining...`)
        secondsLeft = secondsLeft - 1
      }, 1000)

      DndManager.onDndChanged(() => {
        clearInterval(interval)
        done()
      })
    }, 10000)
  })
})
