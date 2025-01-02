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

        pub fn toEqualSlice(self: *const @This(), expected: T) !void {
            try std.testing.expectEqualSlices(std.meta.Elem(T), expected, self.actual);
        }

        pub fn toEqualString(self: *const @This(), expected: []const u8) !void {
            try std.testing.expectEqualStrings(expected, self.actual);
        }
    };
}
