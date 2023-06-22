const std = @import("std");
const print = std.debug.print;

//const n: u64 = 100_000_000_000;
var a: u64 = 0;
var pi: f32 = undefined;

pub fn main() !void {
    print("monte carlo pi calculator in zig!\n", .{});

    var argiter = std.process.args();

    _ = argiter.skip();
    const nstring = argiter.next() orelse {
        print("Error: usage: ./pi <point count>\n", .{});
        std.os.exit(1);
    };

    const n = std.fmt.parseUnsigned(u64, nstring[0..nstring.len], 10) catch {
        print("Error: parameter is not a number\n", .{});
        std.os.exit(1);
    };

    if (n == 0) {
        print("Error: cannot calculate with zero points\n", .{});
        std.os.exit(1);
    }

    print("Points: {}, Calculating...\n", .{n});

    var rander = std.rand.Xoshiro256.init(std.crypto.random.int(u64));

    var binde = n / 1000;

    if (n < 1000) {
        print("Error: point count can't be lower than 1000(due to percentage indicator)\n", .{});
        std.os.exit(1);
    }

    for (0..n) |i| {
        if (i % binde == 0) {
            rander.seed(std.crypto.random.int(u64));

            var yuzde: f32 = @intToFloat(f32, i / binde) / 10;
            print("\r%{d:.1}", .{yuzde});
        }

        var x = rander.random().float(f32);
        _ = rander.next();
        var y = rander.random().float(f32);
        _ = rander.next();
        if (cemberdeMi(x, y)) {
            a += 1;
        }
    }

    pi = @intToFloat(f32, 4 * a) / @intToFloat(f32, n);

    print("\nCalculated pi: {d}\n", .{pi});
}

fn cemberdeMi(x: f32, y: f32) bool {
    return (x * x + y * y) <= 1;
}

test "random" {
    var rander = std.rand.Xoshiro256.init(std.crypto.random.int(u64));
    for (0..10) |i| {
        var random = rander.random().float(f32);
        print("{}: {d}", .{ i, random });
    }
}

test "cember" {
    const assert = std.debug.assert;
    assert(cemberdeMi(0.5, 0.5));
    assert(cemberdeMi(0.2, 0.2));
    assert(!cemberdeMi(0.9, 0.9));
}
