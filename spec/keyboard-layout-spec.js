'use strict'

const KeyboardLayout = require('../lib/keyboard-layout')

describe('Keyboard Layout', () => {
  if (process.platform === 'darwin' || process.platform === 'win32') {
    describe('.getCurrentKeyboardLayout()', () => {
      it('returns the current keyboard layout', () => {
        const layout = KeyboardLayout.getCurrentKeyboardLayout()
        expect(typeof layout).toBe('string')
        expect(layout.length).toBeGreaterThan(0)
      })
    })

    describe('.observeCurrentKeyboardLayout(callback)', () => {
      it('calls back immediately with the current keyboard layout', () => {
        const callback = jasmine.createSpy('observeCurrentKeyboardLayout')
        const disposable = KeyboardLayout.observeCurrentKeyboardLayout(callback)
        disposable.dispose()
        expect(callback.callCount).toBe(1)
        const layout = callback.argsForCall[0][0]
        expect(typeof layout).toBe('string')
        expect(layout.length).toBeGreaterThan(0)
      })
    })
  }

  describe('onDidChangeCurrentKeyboardLayout', () => {
    it('should notify when do not disturb changes', function (done) {
      let secondsLeft = 10

      const interval = setInterval(() => {
        process.stdout.clearLine()
        process.stdout.cursorTo(5)
        process.stdout.write(`Please toggle Do Not Disturb. ${secondsLeft} seconds remaining...`)
        secondsLeft = secondsLeft - 1
      }, 1000)

      KeyboardLayout.onDidChangeCurrentKeyboardLayout(() => {
        clearInterval(interval)
        done()
      })
    }, 10000)
  })
})
