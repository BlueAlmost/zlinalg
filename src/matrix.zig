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
