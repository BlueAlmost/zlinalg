const std = @import("std");

pub fn build(b: *std.build.Builder) void {

    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const exe_targets = [_]Target {
        // .{ .name = "foo", .src = "foo.zig", .desc ="foo"},
    };

    for (exe_targets) |e_target| {
        e_target.build(b);
    }

    const exe_tests = b.addTest("test/main_test.zig");
    exe_tests.setTarget(target);
    exe_tests.setBuildMode(mode);

    exe_tests.addPackagePath("zlinalg", "zlinalg.zig");

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&exe_tests.step);
}

//---------------------------------------------------------------------------

const Target = struct {

    name: []const u8,
    src:  []const u8,
    desc: []const u8,

    pub fn build(self: Target, b: *std.build.Builder) void {

        // const target = b.standardTargetOptions(.{});
        const mode = b.standardReleaseOptions();

        var exe = b.addExecutable(self.name, self.src);
        exe.setBuildMode(b.standardReleaseOptions());
        // exe.setTarget(target);
        exe.setBuildMode(mode);

        exe.addPackagePath("zlinalg", "zlinalg.zig");
        
        exe.setOutputDir("bin");
        exe.install();

        const run_cmd = exe.run();
        run_cmd.step.dependOn(b.getInstallStep());
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }
    }
};
