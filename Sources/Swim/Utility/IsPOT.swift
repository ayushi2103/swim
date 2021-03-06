extension Int {
    /// Return true if self is power of 2.
    @inlinable
    var isPOT: Bool {
        return self > 0 && self & (self-1) == 0
    }
}
