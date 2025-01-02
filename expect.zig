const std = @import("std");

pub fn expect(actual: anytype) Expect(@TypeOf(actual)) {
    return .{ .actual = actual };
}

pub fn Expect(T: type) type {
    return struct {
        actual: T,
        negate: bool = false,

        const info = @typeInfo(T);

        pub fn toEqual(self: *const @This(), expected: T) !void {
            try std.testing.expectEqual(expected, self.actual);
        }

        pub fn toEqualSlice(self: *const @This(), expected: T) !void {
            if (info == .Optional) {
                try std.testing.expectEqualSlices(std.meta.Elem(T), expected, self.actual.?);
                return;
            }
            try std.testing.expectEqualSlices(std.meta.Elem(T), expected, self.actual);
        }

        pub fn toEqualString(self: *const @This(), expected: []const u8) !void {
            if (info == .Optional) {
                try std.testing.expectEqualStrings(expected, self.actual.?);
                return;
            }
            try std.testing.expectEqualStrings(expected, self.actual);
        }

        pub fn not(self: *const @This()) Expect(T) {
            return .{
                .actual = self.actual,
                .negate = !self.negate,
            };
        }

        pub fn toBeNull(self: *const @This()) !void {
            if (info == .Optional) {
                if (!self.negate) try std.testing.expectEqual(@as(T, null), self.actual);
                if (self.negate) try std.testing.expect(self.actual != null);
                return;
            }
            if (!self.negate) try std.testing.expectEqual(@as(?T, null), self.actual);
            if (self.negate) try std.testing.expect(self.actual != null);
        }
    };
}
