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
