const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    // Create ArrayLists for the two columns
    var column1 = std.ArrayList(i32).init(allocator);
    defer column1.deinit();

    var column2 = std.ArrayList(i32).init(allocator);
    defer column2.deinit();

    // Open the file
    const file = try std.fs.cwd().openFile("input", .{});
    defer file.close();

    // Create a buffered reader to read the file line by line
    var buf = std.io.bufferedReader(file.reader());

    // Read lines from the buffered reader
    var r = buf.reader();

    // lines will get read into this
    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    var line_count: usize = 0;
    var byte_count: usize = 0;
    while (true) {
        r.streamUntilDelimiter(arr.writer(), '\n', null) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        line_count += 1;
        byte_count += arr.items.len;
        // std.debug.print("{s}\n", .{arr.items});
        var tokenizer = std.mem.tokenizeAny(u8, arr.items, " ");
        const column1_str_opt = tokenizer.next();
        if (column1_str_opt == null) continue;
        const column1_str = column1_str_opt.?;

        const column2_str_opt = tokenizer.next();
        if (column2_str_opt == null) continue;
        const column2_str = column2_str_opt.?;

        const column1_value = try std.fmt.parseInt(i32, column1_str, 10);
        const column2_value = try std.fmt.parseInt(i32, column2_str, 10);
        try column1.append(column1_value);
        try column2.append(column2_value);
        arr.clearRetainingCapacity();
    }
    // std.debug.print("{d} lines, {d} bytes", .{ line_count, byte_count });
    std.mem.sort(i32, column1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, column2.items, {}, std.sort.asc(i32));

    // // Print sorted lists
    std.debug.print("Column 1 Sorted: {d}\n", .{column1.items.len});
    std.debug.print("Column 2 Sorted: {d}\n", .{column2.items.len});
    var sum: u32 = 0;
    for (column1.items, 0..) |number, index| {
        const value = @abs(column2.items[index] - number);
        sum = sum + value;
    }
    std.debug.print("{d}\n", .{sum});
}
