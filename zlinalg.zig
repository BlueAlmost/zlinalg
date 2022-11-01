const std = @import("std");

// containers
pub const Vector  = @import("src/vector.zig").Vector; // vector struct implmentation
pub const Matrix  = @import("src/matrix.zig").Matrix; // general matrix struct implmentation

// utilities
const utils = @import("src/utils.zig");
pub const splitify   = utils.splitify;
pub const complexify = utils.complexify;
pub const copy       = utils.copy;

