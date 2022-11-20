const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.complex.Complex;

const Vec = @import("../zlinalg.zig").Vec;
const Mat = @import("../zlinalg.zig").Mat;

pub fn ValueType(comptime T: type) type {
    switch (T) {
        f32, Complex(f32) => { return f32; },
        f64, Complex(f64) => { return f64; },
        []f32, []Complex(f32) => { return f32; },
        []f64, []Complex(f64) => { return f64; },
        Vec(f32), Mat(f32), Vec(Complex(f32)), Mat(Complex(f32)) => { return f32; },
        Vec(f64), Mat(f64), Vec(Complex(f64)), Mat(Complex(f64)) => { return f64; },
        else => { @compileError("type not implemented"); },
    }
}

pub fn AliasType(comptime T: type) type {
    switch (T) {
        []f32, Vec(f32), Mat(f32) => { return []f32; },
        []f64, Vec(f64), Mat(f64) => { return []f64; },
        []Complex(f32), Vec(Complex(f32)), Mat(Complex(f32)) => { return []Complex(f32); },
        []Complex(f64), Vec(Complex(f64)), Mat(Complex(f64)) => { return []Complex(f64); },
        else => { @compileError("type not implemented"); },
    }
}

pub fn aliasInput(comptime T: type, x: T) AliasType(T) {
    switch (T) {
        []f32, []f64, []Complex(f32), []Complex(f64) => { return x; },
        Vec(f32), Vec(f64), Mat(f32), Mat(f64),
        Vec(Complex(f32)), Vec(Complex(f64)), Mat(Complex(f32)), Mat(Complex(f64)),
        => { return x.val; },
        else => { @compileError("type not implemented"); },
    }
}


// splits a complex vector/matrix into real and imaginary components
pub fn splitify(cmp: anytype, re: anytype, im: anytype) !void {
    comptime var C:  type = @TypeOf(cmp);
    comptime var VC: type = ValueType(C);

    comptime var R:  type = @TypeOf(re);
    comptime var VR: type = ValueType(R);

    comptime var I:  type = @TypeOf(im);
    comptime var VI: type = ValueType(I);

    if ((VC != VR) or (VC != VI)) { @compileError("unexpected input types"); }
    
    // create aliases
    var cmp_alias: AliasType(C) = aliasInput(C, cmp);
    var re_alias:  AliasType(R) = aliasInput(R, re);
    var im_alias:  AliasType(I) = aliasInput(I, im);

    if ((cmp_alias.len != re_alias.len) or (cmp_alias.len != im_alias.len)) {
        return error.Non_Commensurate_Inputs;
    }

    for (cmp_alias) |cmpval, i| {
        re_alias[i] = cmpval.re;
        im_alias[i] = cmpval.im;
    }
}

pub fn complexify(cmp: anytype, re: anytype, im: anytype) !void {
    comptime var C: type = @TypeOf(cmp);
    comptime var VC: type = ValueType(C);

    comptime var R: type = @TypeOf(re);
    comptime var VR: type = ValueType(R);

    comptime var I: type = @TypeOf(im);
    comptime var VI: type = ValueType(I);

    if ((VC != VR) or (VC != VI)) { @compileError("unexpected input types"); }

    // create aliases
    var cmp_alias: AliasType(C) = aliasInput(C, cmp);
    var re_alias:  AliasType(R) = aliasInput(R, re);
    var im_alias:  AliasType(I) = aliasInput(I, im);

    if ((cmp_alias.len != re_alias.len) or (cmp_alias.len != im_alias.len)) {
        return error.Non_Commensurate_Inputs;
    }

    for (cmp_alias) |_, i| {
        cmp_alias[i].re = re_alias[i];
        cmp_alias[i].im = im_alias[i];
    }
}

pub fn copy(src: anytype, dest: anytype) !void {
    comptime var S: type = @TypeOf(src);
    // comptime var VS: type = ValueType(S);

    comptime var D: type = @TypeOf(dest);
    // comptime var DS: type = ValueType(D);

    if (S != D) { @compileError("dissimilar input types"); }

    // create aliases
    var src_alias:  AliasType(S) = aliasInput(S, src);
    var dest_alias:  AliasType(D) = aliasInput(D, dest);

    if (src_alias.len != dest_alias.len) {
        return error.Non_Commensurate_Inputs;
    }

    for (src_alias) |_, i| {
        dest_alias[i] = src_alias[i];
    }
}

//-----------------------------------------------

test "utils - splitify for array inputs\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try allocator.alloc(C, 2);
        var r = try allocator.alloc(R, 2);
        var i = try allocator.alloc(R, 2);
        c[0] = C.init(1.2, 3.4);
        c[1] = C.init(5.6, 7.8);

        try splitify(c, r, i);

        try std.testing.expectApproxEqAbs(@as(R, 1.2), r[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), r[1], eps);

        try std.testing.expectApproxEqAbs(@as(R, 3.4), i[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.8), i[1], eps);
    }
}

test "utils - splitify for vec inputs\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try Vec(C).init(allocator, 2);
        var r = try Vec(R).init(allocator, 2);
        var i = try Vec(R).init(allocator, 2);
        c.val[0] = C.init(1.2, 3.4);
        c.val[1] = C.init(5.6, 7.8);

        try splitify(c, r, i);

        try std.testing.expectApproxEqAbs(@as(R, 1.2), r.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), r.val[1], eps);

        try std.testing.expectApproxEqAbs(@as(R, 3.4), i.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.8), i.val[1], eps);
    }
}

test "utils - splitify for mat inputs\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try Mat(C).init(allocator, 2, 2);
        var r = try Mat(R).init(allocator, 2, 2);
        var i = try Mat(R).init(allocator, 2, 2);
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

test "utils - complexify for array input\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try allocator.alloc(C, 2);
        var r = try allocator.alloc(R, 2);
        var i = try allocator.alloc(R, 2);

        r[0] = 1.2;
        r[1] = 5.6;
        i[0] = 3.4;
        i[1] = 7.8;

        try complexify(c, r, i);

        try std.testing.expectApproxEqAbs(@as(R, 1.2), c[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), c[1].re, eps);

        try std.testing.expectApproxEqAbs(@as(R, 3.4), c[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, 7.8), c[1].im, eps);
    }
}

test "utils - complexify for vec input\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try Vec(C).init(allocator, 2);
        var r = try Vec(R).init(allocator, 2);
        var i = try Vec(R).init(allocator, 2);

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

test "utils - complexify for mat input \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var c = try Mat(C).init(allocator, 2, 2);
        var r = try Mat(R).init(allocator, 2, 2);
        var i = try Mat(R).init(allocator, 2, 2);

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

test "utils - copy for real array \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(R, 2);
        var y = try allocator.alloc(R, 2);

        x[0] = 1.2;
        x[1] = 5.6;

        try copy(x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1.2), y[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), y[1], eps);
    }
}

test "utils - copy for real vec \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vec(R).init(allocator, 2);
        var y = try Vec(R).init(allocator, 2);

        x.val[0] = 1.2;
        x.val[1] = 5.6;

        try copy(x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1.2), y.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), y.val[1], eps);
    }
}

test "utils - copy for complex array\n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try allocator.alloc(C, 2);
        var y = try allocator.alloc(C, 2);

        x[0].re = 1.2;
        x[1].re = 5.6;
        x[0].im = -1.2;
        x[1].im = -5.6;

        try copy(x, y);

        try std.testing.expectApproxEqAbs(@as(R, 1.2), y[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 5.6), y[1].re, eps);

        try std.testing.expectApproxEqAbs(@as(R, -1.2), y[0].im, eps);
        try std.testing.expectApproxEqAbs(@as(R, -5.6), y[1].im, eps);
    }
}

test "utils - copy for complex vec \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Vec(C).init(allocator, 2);
        var y = try Vec(C).init(allocator, 2);

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

test "utils - copy for real mat \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Mat(R).init(allocator, 2, 2);
        var y = try Mat(R).init(allocator, 2, 2);

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
test "utils - copy for complex mat \n" {
    const eps = 1e-6;
    inline for (.{ f32, f64 }) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Mat(C).init(allocator, 2, 2);
        var y = try Mat(C).init(allocator, 2, 2);

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
