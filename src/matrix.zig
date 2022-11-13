const std = @import("std");
const Complex = std.math.complex.Complex;
const Allocator = std.mem.Allocator;
const print = std.debug.print;

pub fn Matrix(comptime T: type) type {

    comptime var U: type = usize;

    return struct {

        const Self = @This();
        n_row: U,
        n_col: U,
        val: []T,

        pub fn fill(self: Self, new_val: T) void {
            for(self.val) |_, i| {
                self.val[i] = new_val;
            }
        }

        pub fn init(allocator: Allocator, n_row: U, n_col: U) !Self {
            return Self{
                .n_row = n_row,
                .n_col = n_col,
                .val = try allocator.alloc(T, n_row*n_col),
            };
        }

        pub fn neg(self: Self) void {
            switch(T) {
                f32, f64 => {
                    for(self.val) |_, i| {
                        self.val[i] = -self.val[i];
                    }
                },

                Complex(f32), Complex(f64) => {
                    for(self.val) |_, i| {
                        self.val[i].re = -self.val[i].re;
                        self.val[i].im = -self.val[i].im;
                    }
                },
                else => @compileError("requested Vector type is not allowed"),
            }
        }

        pub fn ones(self: Self) void {
            switch(T) {
                f32, f64 => {
                    for(self.val) |_, i| {
                        self.val[i] = 1;
                    }
                },
                Complex(f32), Complex(f64) => {
                    for(self.val) |_, i| {
                        self.val[i].re = 1;
                        self.val[i].im = 0;
                    }
                },
                else => @compileError("requested Matrix type is not allowed"),
            }
        }

        pub fn prt(self: *Self) void {
            switch(T){
                f32, f64 => {

                    // first row
                    print("\n[", .{});
                    var i_col: usize = 0;
                    while( i_col < self.n_col) : (i_col += 1) {
                        print(" {e:>10.3} ", .{self.val[self.n_row*i_col]});
                    }
                    print("\n", .{});

                    // middle rows
                    var i_row: usize = 1;
                    while( i_row < self.n_row-1) : (i_row += 1) {
                        i_col = 0;
                        print(" ", .{});
                        while( i_col < self.n_col) : (i_col += 1) {
                            print(" {e:>10.3} ", .{self.val[i_row + i_col*self.n_row]});
                        }
                        print("\n", .{});
                    }

                    // last row
                    i_col = 0;
                    print(" ", .{});
                    while( i_col < self.n_col) : (i_col += 1) {
                        print(" {e:>10.3} ", .{self.val[self.n_row-1 + self.n_row*i_col]});
                    }
                    print("]\n", .{});
                },

                Complex(f32), Complex(f64) => {

                    // first row
                    print("\n[", .{});
                    var i_col: usize = 0;
                    while( i_col < self.n_col) : (i_col += 1) {
                        print(" ({e:>10.3}, {e:>10.3})", 
                            .{ self.val[self.n_row*i_col].re, self.val[self.n_row*i_col].im, });
                    }
                    print("\n", .{});

                    // middle rows
                    var i_row: usize = 1;
                    while( i_row < self.n_row-1) : (i_row += 1) {
                        i_col = 0;
                        print(" ", .{});
                        while( i_col < self.n_col) : (i_col += 1) {
                            print(" ({e:>10.3}, {e:>10.3})", 
                                .{ self.val[i_row + i_col*self.n_row].re,
                                    self.val[i_row + i_col*self.n_row].im });
                        }
                        print("\n", .{});
                    }

                    // last row
                    i_col = 0;
                    print(" ", .{});
                    while( i_col < self.n_col) : (i_col += 1) {
                        print(" ({e:>10.3}, {e:>10.3})", 
                            .{ self.val[self.n_row-1 + self.n_row*i_col].re,
                                self.val[self.n_row-1 + self.n_row*i_col].im });
                    }
                    print(" ]\n", .{});
                },
                else => @compileError("requested Matrix type is not allowed"),
            }
        }

        pub fn scale(self: Self, alpha: anytype) void {
            switch(T){
                f32, f64 => {
                    for(self.val) |_, i| { self.val[i] *= alpha; }
                },

                Complex(f32) => {
                    if( @TypeOf(alpha) != f32 ) { @compileError("scaling parameter must be real"); }
                    for(self.val) |_, i| {
                        self.val[i].re *= alpha;
                        self.val[i].im *= alpha;
                    }
                },
                Complex(f64) => {
                    if( @TypeOf(alpha) != f64 ) {@compileError("scaling parameter must be real");}
                    for(self.val) |_, i| {
                        self.val[i].re *= alpha;
                        self.val[i].im *= alpha;
                    }
                },
                else => @compileError("requested Matrix type is not allowed"),
            }
        }

        pub fn zeros(self: Self) void {
            switch(T) {
                f32, f64 => {
                    for(self.val) |_, i| {
                        self.val[i] = 0;
                    }
                },
                Complex(f32), Complex(f64) => {
                    for(self.val) |_, i| {
                        self.val[i].re = 0;
                        self.val[i].im = 0;
                    }
                },
                else => @compileError("requested Matrix type is not allowed"),
            }
        }


    };
}

//-----------------------------------------------------------



test "matrix methods fill - real \n" {
    const eps = 1e-6;
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.fill(1.23);

        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[3], eps);
    }
}

test "matrix methods fill - complex \n" {
    const eps = 1e-6;
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.fill( C.init(1.23, 4.56));

        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.56),x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.56),x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.56),x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.23),x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.56),x.val[3].im, eps);
    }
}

test "matrix methods neg - real \n" {
    const eps = 1e-6;
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

        try std.testing.expectApproxEqAbs(@as(R, -0.23),x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, -0.56),x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, -1.23),x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, -4.56),x.val[3], eps);
    }
}

test "matrix methods neg - complex \n" {
    const eps = 1e-6;
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

        try std.testing.expectApproxEqAbs(@as(R, -1.23),x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -4.56),x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -7.89),x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.56),x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -1.89),x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -4.56),x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, -2.89),x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R,  4.56),x.val[3].im, eps);
    }
}

test "matrix methods ones - real \n" {
    const eps = 1e-6;
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.ones();

        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[3], eps);
    }
}

test "matrix methods ones - complex \n" {
    const eps = 1e-6;
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.ones();

        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 1.0),x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[3].im, eps);
    }
}

test "matrix methods scale - real \n" {
    const eps = 1e-6;
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

        try std.testing.expectApproxEqAbs(@as(R, 2.2),x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 4.4),x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 6.6),x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, 8.8),x.val[3], eps);
    }
}

test "matrix methods scale - complex \n" {
    const eps = 1e-6;
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

        try std.testing.expectApproxEqAbs(@as(R, 2.2),x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 6.6),x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 2.2),x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -6.6),x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 4.4),x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 8.8),x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 4.4),x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, -8.8),x.val[3].im, eps);
    }
}

test "matrix methods zeros - real \n" {
    const eps = 1e-6;
    inline for (.{f32, f64}) |R| {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(R).init(allocator, 2, 2);
        x.zeros();

        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[0], eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[1], eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[2], eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[3], eps);
    }
}

test "matrix methods zeros - complex \n" {
    const eps = 1e-6;
    inline for (.{f32, f64}) |R| {
        comptime var C: type = Complex(R);

        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();
        const allocator = arena.allocator();

        var x = try Matrix(C).init(allocator, 2, 2);
        x.zeros();

        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[0].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[0].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[1].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[1].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[2].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[2].im, eps);

        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[3].re, eps);
        try std.testing.expectApproxEqAbs(@as(R, 0.0),x.val[3].im, eps);
    }
}

