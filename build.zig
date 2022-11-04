const std = @import("std");

pub fn build(b: *std.build.Builder) void {

    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    // const exe_targets = [_]Target {
    //     // .{ .name = "foo", .src = "foo.zig", .desc ="foo"},
    // };

    // for (exe_targets) |e_target| {
    //     e_target.build(b);
    // }

    const exe_tests = b.addTest("./main_test.zig");
    exe_tests.addPackagePath("zlinalg", "zlinalg.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}

