const std = @import("std");

// containers
pub const Vector  = @import("src/vector.zig").Vector; // vector struct implmentation
pub const Matrix  = @import("src/matrix.zig").Matrix; // general matrix struct implmentation

// utilities
const utils = @import("src/utils.zig");
pub const splitifyVector    = utils.splitifyVector;
pub const splitifyMatrix    = utils.splitifyMatrix;

pub const complexifyVector  = utils.complexifyVector;
pub const complexifyMatrix  = utils.complexifyMatrix;

pub const copyVector        = utils.copyVector;
pub const copyMatrix        = utils.copyMatrix;

