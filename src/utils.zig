const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.complex.Complex;

const Vector = @import("../zlinalg.zig").Vector;
const Matrix = @import("../zlinalg.zig").Matrix;

pub fn ValueType(comptime T: type) type {
    switch(T) {
        f32, Complex(f32) => {return f32;},
        f64, Complex(f64) => {return f64;},
        []f32, []Complex(f32) => {return f32;},
        []f64, []Complex(f64) => {return f64;},
        Vector(f32), Matrix(f32), Vector(Complex(f32)), Matrix(Complex(f32)) => {return f32;},
        Vector(f64), Matrix(f64), Vector(Complex(f64)), Matrix(Complex(f64)) => {return f64;},
        else => {@compileError("type not implemented");},
    }
}

// splits a complex vector/matrix into real and imaginary components
pub fn splitify(cmp: anytype, re: anytype, im: anytype) !void {

    comptime var C: type = @TypeOf(cmp);
    comptime var VC:type = ValueType(C);

    comptime var R: type = @TypeOf(re);
    comptime var VR: type =ValueType(R);

    comptime var I: type = @TypeOf(im);
    comptime var VI: type =ValueType(I);

    if( (VC != VR) or (VC != VI)){ @compileError("unexpected input types"); }

    switch(C) {
        Vector(Complex(VC)) => {
            if( (R!=Vector(VC)) or (I!=Vector(VC)) ){
                @compileError("unexpected input types");
            }
            if(( cmp.val.len != re.val.len) or ( cmp.val.len != im.val.len)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        Matrix(Complex(VC)) => {
            if( (R!=Matrix(VC)) or (I!=Matrix(VC)) ){
                @compileError("unexpected input types");
            }
            if(( cmp.n_row != re.n_row) or ( cmp.n_row != im.n_row)) {
                return error.Non_Commensurate_Inputs;
            }
            if(( cmp.n_col != re.n_col) or ( cmp.n_col != im.n_col)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        else => {@compileError("type not implemented");},
    }

    for(cmp.val) |cmpval, i| {
        re.val[i] = cmpval.re;
        im.val[i] = cmpval.im;
    }
}

pub fn complexify(cmp: anytype, re: anytype, im: anytype) !void {

    comptime var C: type = @TypeOf(cmp);
    comptime var VC:type = ValueType(C);

    comptime var R: type = @TypeOf(re);
    comptime var VR: type =ValueType(R);

    comptime var I: type = @TypeOf(im);
    comptime var VI: type =ValueType(I);

    if( (VC != VR) or (VC != VI)){ @compileError("unexpected input types"); }

    switch(C) {
        Vector(Complex(VC)) => {
            if( (R!=Vector(VC)) or (I!=Vector(VC)) ){
                @compileError("unexpected input types");
            }
            if(( cmp.val.len != re.val.len) or ( cmp.val.len != im.val.len)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        Matrix(Complex(VC)) => {
            if( (R!=Matrix(VC)) or (I!=Matrix(VC)) ){
                @compileError("unexpected input types");
            }
            if(( cmp.n_row != re.n_row) or ( cmp.n_row != im.n_row)) {
                return error.Non_Commensurate_Inputs;
            }
            if(( cmp.n_col != re.n_col) or ( cmp.n_col != im.n_col)) {
                return error.Non_Commensurate_Inputs;
            }
        },
        else => {@compileError("type not implemented");},
    }

    for(cmp.val) |_, i| {
        cmp.val[i].re = re.val[i];
        cmp.val[i].im = im.val[i];
    }
}

pub fn copy(src: anytype, dest: anytype) !void {

    comptime var S: type = @TypeOf(src);
    comptime var VS:type = ValueType(S);

    comptime var D: type = @TypeOf(dest);

    if(S != D) { @compileError("dissimilar input types"); }

    switch(S) {
        Vector(VS), Vector(Complex(VS)) => {
            if(src.val.len != dest.val.len) {return error.Non_Commensurate_Inputs;}
            for(src.val) |srcval, i| {
                dest.val[i] = srcval;
            }
        },
        Matrix(VS), Matrix(Complex(VS)) => {
            if(( src.n_row != dest.n_row) or ( src.n_row != dest.n_row)) {
                return error.Non_Commensurate_Inputs;
            }
            if(( src.n_col != dest.n_col) or ( src.n_col != dest.n_col)) {
                return error.Non_Commensurate_Inputs;
            }
            for(src.val) |srcval, i| {
                dest.val[i] = srcval;
            }
        },
        else => {@compileError("type not implemented");},
    }
}
