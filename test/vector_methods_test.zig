const std = @import("std");
const print = std.debug.print;
const zlinalg = @import("zlinalg");

const Complex = std.math.Complex;

const Vector = zlinalg.Vector;
const eps = 1e-6;

test "vector methods fill - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(R).init(allocator, 2);
        x.fill(1.23);

        try std.testing.expectApproxEqAbs(x.val[0], 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 1.23, eps);
    }
}

test "vector methods fill - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(C).init(allocator, 2);
        x.fill( C.init(1.23, 4.56));

        try std.testing.expectApproxEqAbs(x.val[0].re, 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 4.56, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 4.56, eps);
    }
}

test "vector methods neg - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(R).init(allocator, 2);
        x.val[0] = 1.23;
        x.val[1] = 4.56;
        x.neg();

        try std.testing.expectApproxEqAbs(x.val[0], -1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[1], -4.56, eps);
    }
}

test "vector methods neg - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(C).init(allocator, 2);
        x.val[0] = C.init(1.23,  4.56);
        x.val[1] = C.init(7.89, -4.56);
        x.neg();

        try std.testing.expectApproxEqAbs(x.val[0].re, -1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, -4.56, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, -7.89, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 4.56, eps);
    }
}

test "vector methods ones - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(R).init(allocator, 2);
        x.ones();

        try std.testing.expectApproxEqAbs(x.val[0], 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 1.0, eps);
    }
}

test "vector methods ones - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(C).init(allocator, 2);
        x.ones();

        try std.testing.expectApproxEqAbs(x.val[0].re, 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 0.0, eps);
    }
}

test "vector methods scale - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(R).init(allocator, 2);
        x.val[0] = 1.1;
        x.val[1] = 3.3;

        var alpha: R = 2.0;

        x.scale(alpha);

        try std.testing.expectApproxEqAbs(x.val[0], 2.2, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 6.6, eps);
    }
}

test "vector methods scale - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(C).init(allocator, 2);
        x.val[0] = C.init(1.1,  3.3);
        x.val[1] = C.init(1.1, -3.3);

        var alpha: R = 2.0;
        x.scale(alpha);

        try std.testing.expectApproxEqAbs(x.val[0].re, 2.2, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 6.6, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 2.2, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, -6.6, eps);
    }
}

test "vector methods zeros - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(R).init(allocator, 3);
        x.zeros();

        try std.testing.expectApproxEqAbs(x.val[0], 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[2], 0.0, eps);
    }
}

test "vector methods zeros - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(C).init(allocator, 3);
        x.zeros();

        try std.testing.expectApproxEqAbs(x.val[0].re, 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[2].re, 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[2].im, 0.0, eps);
    }
}
