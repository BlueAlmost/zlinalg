const std = @import("std");
const print = std.debug.print;
const zlinalg = @import("../zlinalg.zig");

const Complex = std.math.Complex;

const Vector = zlinalg.Vector;
const Matrix = zlinalg.Matrix;

const splitify   = zlinalg.splitify;
const complexify = zlinalg.complexify;
const copy       = zlinalg.copy;

const eps = 1e-6;

test "utils - splitify for vector inputs\n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try Vector(C).init(allocator, 2);
        var r = try Vector(R).init(allocator, 2);
        var i = try Vector(R).init(allocator, 2);
        c.val[0] = C.init(1.2, 3.4);
        c.val[1] = C.init(5.6, 7.8);

        try splitify(c, r, i);

        try std.testing.expectApproxEqAbs(r.val[0], 1.2, eps);
        try std.testing.expectApproxEqAbs(r.val[1], 5.6, eps);
        
        try std.testing.expectApproxEqAbs(i.val[0], 3.4, eps);
        try std.testing.expectApproxEqAbs(i.val[1], 7.8, eps);
    }
}


test "utils - splitify for matrix inputs\n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try Matrix(C).init(allocator, 2, 2);
        var r = try Matrix(R).init(allocator, 2, 2);
        var i = try Matrix(R).init(allocator, 2, 2);
        c.val[0] = C.init(1.2, 3.4);
        c.val[1] = C.init(5.6, 7.8);
        c.val[2] = C.init(-1.2, -3.4);
        c.val[3] = C.init(-5.6, -7.8);

        try splitify(c, r, i);

        try std.testing.expectApproxEqAbs(r.val[0], 1.2, eps);
        try std.testing.expectApproxEqAbs(r.val[1], 5.6, eps);
        try std.testing.expectApproxEqAbs(r.val[2], -1.2, eps);
        try std.testing.expectApproxEqAbs(r.val[3], -5.6, eps);
        
        try std.testing.expectApproxEqAbs(i.val[0], 3.4, eps);
        try std.testing.expectApproxEqAbs(i.val[1], 7.8, eps);
        try std.testing.expectApproxEqAbs(i.val[2], -3.4, eps);
        try std.testing.expectApproxEqAbs(i.val[3], -7.8, eps);
    }
}



test "utils - complexify for vector input\n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var r = try Vector(R).init(allocator, 2);
        var i = try Vector(R).init(allocator, 2);
        var c = try Vector(C).init(allocator, 2);

        r.val[0] = 1.2;
        r.val[1] = 5.6;
        i.val[0] = 3.4;
        i.val[1] = 7.8;

        try complexify(c, r, i);

        try std.testing.expectApproxEqAbs(c.val[0].re, 1.2, eps);
        try std.testing.expectApproxEqAbs(c.val[1].re, 5.6, eps);
        
        try std.testing.expectApproxEqAbs(c.val[0].im, 3.4, eps);
        try std.testing.expectApproxEqAbs(c.val[1].im, 7.8, eps);
    }
}


test "utils - complexify for matrix input \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var r = try Matrix(R).init(allocator, 2, 2);
        var i = try Matrix(R).init(allocator, 2, 2);
        var c = try Matrix(C).init(allocator, 2, 2);

        r.val[0] = 1.2;
        r.val[1] = 2.3;
        r.val[2] = 3.4;
        r.val[3] = 4.5;

        i.val[0] = -1.2;
        i.val[1] = -2.3;
        i.val[2] = -3.4;
        i.val[3] = -4.5;

        try complexify(c, r, i);

        try std.testing.expectApproxEqAbs(c.val[0].re, 1.2, eps);
        try std.testing.expectApproxEqAbs(c.val[1].re, 2.3, eps);
        try std.testing.expectApproxEqAbs(c.val[2].re, 3.4, eps);
        try std.testing.expectApproxEqAbs(c.val[3].re, 4.5, eps);
        
        try std.testing.expectApproxEqAbs(c.val[0].im, -1.2, eps);
        try std.testing.expectApproxEqAbs(c.val[1].im, -2.3, eps);
        try std.testing.expectApproxEqAbs(c.val[2].im, -3.4, eps);
        try std.testing.expectApproxEqAbs(c.val[3].im, -4.5, eps);
    }
}


test "utils - copy for real vector \n" {
    inline for (.{f32, f64}) |R| {
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(R).init(allocator, 2);
        var y = try Vector(R).init(allocator, 2);

        x.val[0] = 1.2;
        x.val[1] = 5.6;

        try copy(x, y);

        try std.testing.expectApproxEqAbs(y.val[0], 1.2, eps);
        try std.testing.expectApproxEqAbs(y.val[1], 5.6, eps);
    }
}

test "utils - copy for complex vector \n" {

    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(C).init(allocator, 2);
        var y = try Vector(C).init(allocator, 2);

        x.val[0].re = 1.2;
        x.val[1].re = 5.6;
        x.val[0].im = -1.2;
        x.val[1].im = -5.6;

        try copy(x, y);

        try std.testing.expectApproxEqAbs(y.val[0].re, 1.2, eps);
        try std.testing.expectApproxEqAbs(y.val[1].re, 5.6, eps);
        
        try std.testing.expectApproxEqAbs(y.val[0].im, -1.2, eps);
        try std.testing.expectApproxEqAbs(y.val[1].im, -5.6, eps);
    }
}

test "utils - copy for real matrix \n" {
    inline for (.{f32, f64}) |R| {
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        var y = try Matrix(R).init(allocator, 2, 2);

        x.val[0] = 1.2;
        x.val[1] = 2.3;
        x.val[2] = 3.4;
        x.val[3] = 4.5;
        
        try copy(x, y);

        try std.testing.expectApproxEqAbs(y.val[0], 1.2, eps);
        try std.testing.expectApproxEqAbs(y.val[1], 2.3, eps);
        try std.testing.expectApproxEqAbs(y.val[2], 3.4, eps);
        try std.testing.expectApproxEqAbs(y.val[3], 4.5, eps);
    }
}
test "utils - copy for complex matrix \n" {
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);
        
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        var y = try Matrix(C).init(allocator, 2, 2);

        x.val[0].re = 1.2;
        x.val[1].re = 2.3;
        x.val[2].re = 3.4;
        x.val[3].re = 4.5;
        
        x.val[0].im = -1.2;
        x.val[1].im = -2.3;
        x.val[2].im = -3.4;
        x.val[3].im = -4.5;

        try copy(x, y);

        try std.testing.expectApproxEqAbs(y.val[0].re, 1.2, eps);
        try std.testing.expectApproxEqAbs(y.val[1].re, 2.3, eps);
        try std.testing.expectApproxEqAbs(y.val[2].re, 3.4, eps);
        try std.testing.expectApproxEqAbs(y.val[3].re, 4.5, eps);
        
        try std.testing.expectApproxEqAbs(y.val[0].im, -1.2, eps);
        try std.testing.expectApproxEqAbs(y.val[1].im, -2.3, eps);
        try std.testing.expectApproxEqAbs(y.val[2].im, -3.4, eps);
        try std.testing.expectApproxEqAbs(y.val[3].im, -4.5, eps);
    }
}

