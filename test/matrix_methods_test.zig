const std = @import("std");
const print = std.debug.print;
const zlinalg = @import("zlinalg");

const Complex = std.math.Complex;

const Matrix = zlinalg.Matrix;
const eps = 1e-6;

test "matrix methods fill - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.fill(1.23);

        try std.testing.expectApproxEqAbs(x.val[0], 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[2], 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[3], 1.23, eps);
    }
}

test "matrix methods fill - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.fill( C.init(1.23, 4.56));

        try std.testing.expectApproxEqAbs(x.val[0].re, 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 4.56, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 4.56, eps);
        
        try std.testing.expectApproxEqAbs(x.val[2].re, 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[2].im, 4.56, eps);

        try std.testing.expectApproxEqAbs(x.val[3].re, 1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[3].im, 4.56, eps);
    }
}

test "matrix methods neg - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.val[0] = 0.23;
        x.val[1] = 0.56;
        x.val[2] = 1.23;
        x.val[3] = 4.56;
        x.neg();

        try std.testing.expectApproxEqAbs(x.val[0], -0.23, eps);
        try std.testing.expectApproxEqAbs(x.val[1], -0.56, eps);
        try std.testing.expectApproxEqAbs(x.val[2], -1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[3], -4.56, eps);
    }
}

test "matrix methods neg - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.val[0] = C.init(1.23,  4.56);
        x.val[1] = C.init(7.89, -4.56);
        x.val[2] = C.init(1.89,  4.56);
        x.val[3] = C.init(2.89, -4.56);
        x.neg();

        try std.testing.expectApproxEqAbs(x.val[0].re, -1.23, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, -4.56, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, -7.89, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 4.56, eps);
        
        try std.testing.expectApproxEqAbs(x.val[2].re, -1.89, eps);
        try std.testing.expectApproxEqAbs(x.val[2].im, -4.56, eps);

        try std.testing.expectApproxEqAbs(x.val[3].re, -2.89, eps);
        try std.testing.expectApproxEqAbs(x.val[3].im,  4.56, eps);
    }
}

test "matrix methods ones - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.ones();

        try std.testing.expectApproxEqAbs(x.val[0], 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[2], 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[3], 1.0, eps);
    }
}

test "matrix methods ones - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.ones();

        try std.testing.expectApproxEqAbs(x.val[0].re, 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[2].re, 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[2].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[3].re, 1.0, eps);
        try std.testing.expectApproxEqAbs(x.val[3].im, 0.0, eps);
    }
}

test "matrix methods scale - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.val[0] = 1.1;
        x.val[1] = 2.2;
        x.val[2] = 3.3;
        x.val[3] = 4.4;

        var alpha: R = 2.0;

        x.scale(alpha);

        try std.testing.expectApproxEqAbs(x.val[0], 2.2, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 4.4, eps);
        try std.testing.expectApproxEqAbs(x.val[2], 6.6, eps);
        try std.testing.expectApproxEqAbs(x.val[3], 8.8, eps);
    }
}

test "matrix methods scale - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.val[0] = C.init(1.1,  3.3);
        x.val[1] = C.init(1.1, -3.3);
        x.val[2] = C.init(2.2,  4.4);
        x.val[3] = C.init(2.2, -4.4);

        var alpha: R = 2.0;
        x.scale(alpha);

        try std.testing.expectApproxEqAbs(x.val[0].re, 2.2, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 6.6, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 2.2, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, -6.6, eps);

        try std.testing.expectApproxEqAbs(x.val[2].re, 4.4, eps);
        try std.testing.expectApproxEqAbs(x.val[2].im, 8.8, eps);

        try std.testing.expectApproxEqAbs(x.val[3].re, 4.4, eps);
        try std.testing.expectApproxEqAbs(x.val[3].im, -8.8, eps);
    }
}

test "matrix methods zeros - real \n" {
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.zeros();

        try std.testing.expectApproxEqAbs(x.val[0], 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1], 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[2], 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[3], 0.0, eps);
    }
}

test "matrix methods zeros - complex \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.zeros();

        try std.testing.expectApproxEqAbs(x.val[0].re, 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[0].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[1].re, 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[1].im, 0.0, eps);

        try std.testing.expectApproxEqAbs(x.val[2].re, 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[2].im, 0.0, eps);
        
        try std.testing.expectApproxEqAbs(x.val[3].re, 0.0, eps);
        try std.testing.expectApproxEqAbs(x.val[3].im, 0.0, eps);
    }
}
