const std = @import("std");
const expect = @import("expect").expect;

test {
    try expect(try foo()).toEqual(5);
}

fn foo() !u32 {
    return 5;
}
