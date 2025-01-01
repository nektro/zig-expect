const std = @import("std");

pub fn expect(actual: anytype) Expect(@TypeOf(actual)) {
    return .{ .actual = actual };
}

pub fn Expect(T: type) type {
    return struct {
        actual: T,

        pub fn toEqual(self: *const @This(), expected: T) !void {
            try std.testing.expectEqual(expected, self.actual);
        }
    };
}
