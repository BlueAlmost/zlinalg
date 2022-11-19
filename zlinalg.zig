const std = @import("std");

// containers
pub const Vec = @import("src/vector.zig").Vec; // vector struct implmentation
pub const Mat = @import("src/matrix.zig").Mat; // general matrix struct implmentation

// utilities
const utils = @import("src/utils.zig");
pub const splitify = utils.splitify;
pub const complexify = utils.complexify;
pub const copy = utils.copy;
