const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.complex.Complex;

const Vector = @import("../zlinalg.zig").Vector;
const Matrix = @import("../zlinalg.zig").Matrix;

pub fn ValueType(comptime T: type) type {
    switch (T) {
        f32, Complex(f32) => {
            return f32;
        },
        f64, Complex(f64) => {
            return f64;
        },
        []f32, []Complex(f32) => {
            return f32;
        },
        []f64, []Complex(f64) => {
            return f64;
        },
        Vector(f32), Matrix(f32), Vector(Complex(f32)), Matrix(Complex(f32)) => {
            return f32;
        },
        Vector(f64), Matrix(f64), Vector(Complex(f64)), Matrix(Complex(f64)) => {
            return f64;
        },
        else => {
            @compileError("type not implemented");
        },
    }
}

// splits a complex vector/matrix into real and imaginary components
pub fn splitify(cmp: anytype, re: anytype, im: anytype) !void {
    comptime var C: type = @TypeOf(cmp);
    comptime var VC: type = ValueType(C);

    comptime var R: type = @TypeOf(re);
    comptime var VR: type = ValueType(R);

    comptime var I: type = @TypeOf(im);
    comptime var VI: type = ValueType(I);

    if ((VC != VR) or (VC != VI)) {
        @compileError("unexpected input types");
    }

    switch (C) {
        Vector(Complex(VC)) => {
            if ((R != Vector(VC)) or (I != Vector(VC))) {
                @compileError("unexpected input types");
            }
            if ((cmp.val.len != re.val.len) or (cmp.val.len != im.val.len)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        Matrix(Complex(VC)) => {
            if ((R != Matrix(VC)) or (I != Matrix(VC))) {
                @compileError("unexpected input types");
            }
            if ((cmp.n_row != re.n_row) or (cmp.n_row != im.n_row)) {
                return error.Non_Commensurate_Inputs;
            }
            if ((cmp.n_col != re.n_col) or (cmp.n_col != im.n_col)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        else => {
            @compileError("type not implemented");
        },
    }

    for (cmp.val) |cmpval, i| {
        re.val[i] = cmpval.re;
        im.val[i] = cmpval.im;
    }
}

pub fn complexify(cmp: anytype, re: anytype, im: anytype) !void {
    comptime var C: type = @TypeOf(cmp);
    comptime var VC: type = ValueType(C);

    comptime var R: type = @TypeOf(re);
    comptime var VR: type = ValueType(R);

    comptime var I: type = @TypeOf(im);
    comptime var VI: type = ValueType(I);

    if ((VC != VR) or (VC != VI)) {
        @compileError("unexpected input types");
    }

    switch (C) {
        Vector(Complex(VC)) => {
            if ((R != Vector(VC)) or (I != Vector(VC))) {
                @compileError("unexpected input types");
            }
            if ((cmp.val.len != re.val.len) or (cmp.val.len != im.val.len)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        Matrix(Complex(VC)) => {
            if ((R != Matrix(VC)) or (I != Matrix(VC))) {
                @compileError("unexpected input types");
            }
            if ((cmp.n_row != re.n_row) or (cmp.n_row != im.n_row)) {
                return error.Non_Commensurate_Inputs;
            }
            if ((cmp.n_col != re.n_col) or (cmp.n_col != im.n_col)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        else => {
            @compileError("type not implemented");
        },
    }

    for (cmp.val) |_, i| {
        cmp.val[i].re = re.val[i];
        cmp.val[i].im = im.val[i];
    }
}

pub fn copy(src: anytype, dest: anytype) !void {
    comptime var S: type = @TypeOf(src);
    comptime var VS: type = ValueType(S);

    comptime var D: type = @TypeOf(dest);

    if (S != D) {
        @compileError("dissimilar input types");
    }

    switch (S) {
        Vector(VS), Vector(Complex(VS)) => {
            if (src.val.len != dest.val.len) {
                return error.Non_Commensurate_Inputs;
            }
            for (src.val) |srcval, i| {
                dest.val[i] = srcval;
            }
        },
        Matrix(VS), Matrix(Complex(VS)) => {
            if ((src.n_row != dest.n_row) or (src.n_row != dest.n_row)) {
                return error.Non_Commensurate_Inputs;
            }
            if ((src.n_col != dest.n_col) or (src.n_col != dest.n_col)) {
                return error.Non_Commensurate_Inputs;
            }
            for (src.val) |srcval, i| {
                dest.val[i] = srcval;
            }
        },
        else => {
            @compileError("type not implemented");
        },
    }
}

//-----------------------------------------------

test "utils - splitify for vector inputs\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
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

        try std.testing.expectApproxEqAbs(@as(R, 1.2), r.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), r.val[1], eps);

        try std.testing.expectApproxEqAbs(@as(R, 3.4), i.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.8), i.val[1], eps);
    }
}

test "utils - splitify for matrix inputs\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
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

        try std.testing.expectApproxEqAbs(@as(R, 1.2), r.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), r.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.2), r.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -5.6), r.val[3], eps);

        try std.testing.expectApproxEqAbs(@as(R, 3.4), i.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.8), i.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.4), i.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -7.8), i.val[3], eps);
    }
}

test "utils - complexify for vector input\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
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

        try std.testing.expectApproxEqAbs(@as(R, 1.2), c.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), c.val[1].re, eps);

        try std.testing.expectApproxEqAbs(@as(R, 3.4), c.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.8), c.val[1].im, eps);
    }
}

test "utils - complexify for matrix input \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
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

        try std.testing.expectApproxEqAbs(@as(R, 1.2), c.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.3), c.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 3.4), c.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.5), c.val[3].re, eps);

        try std.testing.expectApproxEqAbs(@as(R, -1.2), c.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.3), c.val[1].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.4), c.val[2].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -4.5), c.val[3].im, eps);
    }
}

test "utils - copy for real vector \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vector(R).init(allocator, 2);
        var y = try Vector(R).init(allocator, 2);

        x.val[0] = 1.2;
        x.val[1] = 5.6;

        try copy(x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1.2), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), y.val[1], eps);
    }
}

test "utils - copy for complex vector \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
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

        try std.testing.expectApproxEqAbs(@as(R, 1.2), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), y.val[1].re, eps);

        try std.testing.expectApproxEqAbs(@as(R, -1.2), y.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -5.6), y.val[1].im, eps);
    }
}

test "utils - copy for real matrix \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
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

        try std.testing.expectApproxEqAbs(@as(R, 1.2), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.3), y.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 3.4), y.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.5), y.val[3], eps);
    }
}
test "utils - copy for complex matrix \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
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

        try std.testing.expectApproxEqAbs(@as(R, 1.2), y.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 2.3), y.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 3.4), y.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.5), y.val[3].re, eps);

        try std.testing.expectApproxEqAbs(@as(R, -1.2), y.val[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -2.3), y.val[1].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -3.4), y.val[2].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -4.5), y.val[3].im, eps);
    }
}
