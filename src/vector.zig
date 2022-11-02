const std = @import("std");
const Complex = std.math.complex.Complex;

const Allocator = std.mem.Allocator;

const print = std.debug.print;

pub fn Vector(comptime T: type) type {

    comptime var U: type = usize;

    switch(T) {
        f32, f64, => {},
        Complex(f32), Complex(f64) => {},
        else => @compileError("requested Vector type is not allowed"),
    }

    return struct {

        const Self = @This();
        val: []T,

        pub fn fill(self: Self, new_val: T) void {
            for(self.val) |_, i| {
                self.val[i] = new_val;
            }
        }

        pub fn init(allocator: Allocator, len: U) !Self {
            return Self{
                .val = try allocator.alloc(T, len),
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
                else => @compileError("requested Vector type is not allowed"),
            }
        }

        pub fn prt(self: *Self) void {
            switch(T){

                f32, f64 => {
                    print("\n[ {e:>10.3}", .{self.val[0]});
                    {
                        var i: usize = 1;
                        while( i < self.val.len-1) : (i += 1) {
                            print("\n  {e:>10.3}", .{self.val[i]});
                        }
                        print("\n  {e:>10.3} ]\n", .{self.val[i]});
                    }
                },

                Complex(f32), Complex(f64) => {
                    print("\n[ ({e:>10.3}, {e:>10.3})", .{ self.val[0].re, self.val[0].im});
                    {
                        var i: usize = 1;
                        while( i < self.val.len-1) : (i += 1) {
                            print("\n  ({e:>10.3}, {e:>10.3})", .{ self.val[i].re, self.val[i].im});
                        }
                        print("\n  ({e:>10.3}, {e:>10.3}) ]\n", .{ self.val[i].re, self.val[i].im});

                    }
                },
                else => @compileError("requested Vector type is not allowed"),
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
                else => @compileError("requested Vector type is not allowed"),
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
                else => @compileError("requested Vector type is not allowed"),
            }
        }

    };
}


//-----------------------------------------------


test "vector methods fill - real \n" {
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
    const eps = 1e-6;
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
