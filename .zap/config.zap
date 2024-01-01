
-- Getting Started: https://zap.redblox.dev/intro/getting-started.html

-- These two settings can be ignored if you're not using the CLI
opt server_output = "src/ReplicatedStorage/Zap/Server.luau"
opt client_output = "path/to/client/output.luau"

event MyEvent = {
	from: Server,
	type: Reliable,
	call: ManyAsync,
	data: struct {
		foo: u32,
		bar: string,
	},
}