import AppKit

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}

extension NSButton {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
