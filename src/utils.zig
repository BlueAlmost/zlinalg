const std = @import("std");
const print = std.debug.print;
const math = std.math;
const Complex = std.math.complex.Complex;

const Vector = @import("../zlinalg.zig").Vector;
const Matrix = @import("../zlinalg.zig").Matrix;

// splits a complex vector into real and imaginary components
pub fn splitifyVector(comptime T: type, cmp: Vector(Complex(T)), re: Vector(T), im: Vector(T)) !void {

    if(( cmp.val.len != re.val.len) or ( cmp.val.len != im.val.len)) {
        return error.Non_Commensurate_Inputs;
    }

    for(cmp.val) |cmpval, i| {
        re.val[i] = cmpval.re;
        im.val[i] = cmpval.im;
    }
}

// splits a matrix vector into real and imaginary components
pub fn splitifyMatrix(comptime T: type, cmp: Matrix(Complex(T)), re: Matrix(T), im: Matrix(T)) !void {

    if(( cmp.n_row != re.n_row) or ( cmp.n_row != im.n_row)) {
        return error.Non_Commensurate_Inputs;
    }
    if(( cmp.n_col != re.n_col) or ( cmp.n_col != im.n_col)) {
        return error.Non_Commensurate_Inputs;
    }

    for(cmp.val) |cmpval, i| {
        re.val[i] = cmpval.re;
        im.val[i] = cmpval.im;
    }
}


// merges two real vectors into a complex vector
pub fn complexifyVector(comptime T: type, cmp: Vector(Complex(T)), re: Vector(T), im: Vector(T)) !void {

    if(( cmp.val.len != re.val.len) or ( cmp.val.len != im.val.len)) {
        return error.Non_Commensurate_Inputs;
    }

    for(re.val) |_,i| {
        cmp.val[i].re = re.val[i];
        cmp.val[i].im = im.val[i];
    }
}

// merges two real matrices into a complex matrices
pub fn complexifyMatrix(comptime T: type, cmp: Matrix(Complex(T)), re: Matrix(T), im: Matrix(T)) !void {

    if(( cmp.n_row != re.n_row) or ( cmp.n_row != im.n_row)) {
        return error.Non_Commensurate_Inputs;
    }
    if(( cmp.n_col != re.n_col) or ( cmp.n_col != im.n_col)) {
        return error.Non_Commensurate_Inputs;
    }

    for(re.val) |_,i| {
        cmp.val[i].re = re.val[i];
        cmp.val[i].im = im.val[i];
    }
}

// copies source vector values to destination vector
pub fn copyVector(comptime T: type, src: Vector(T), dest: Vector(T) ) !void {

    for(src.val) |_, i| {
        dest.val[i] = src.val[i];
    }
}

// copies source matrix values to destination matrix
pub fn copyMatrix(comptime T: type, src: Matrix(T), dest: Matrix(T) ) !void {

    for(src.val) |_, i| {
        dest.val[i] = src.val[i];
    }
}
