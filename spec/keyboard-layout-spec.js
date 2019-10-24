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
})
