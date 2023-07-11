local git_stuff = require("jr.custom.git")
local M = {}

-- {"CAVO-1234": {start_time: 1234, end_time: 1234}}
local ticket_map = {}
local current_ticket = nil
local check_timer_interval = 1000 * 60 -- 1 minute milliseconds
local ticket_idol_time = 60 -- 1 minute in seconds

local function check_interval()
	for ticket_number, ticket_info in pairs(ticket_map) do
		local current_time = os.time()
		local time_diff = current_time - ticket_info.end_time

		if time_diff > ticket_idol_time then
			print("logging time for " .. ticket_number)
			local start_time_utc = os.date("!%Y-%m-%d %H:%M:%S", ticket_info.start_time)
			local end_time_utc = os.date("!%Y-%m-%d %H:%M:%S", ticket_info.end_time)

			local db_path = vim.fn.getcwd() .. "/time-tracking.db"
			vim.fn.system(
				"sqlite3 "
					.. db_path
					.. " 'insert into tickets (ticket_number, start_time, end_time) values (\""
					.. ticket_number
					.. '", datetime("'
					.. start_time_utc
					.. '"), datetime("'
					.. end_time_utc
					.. "\"))'"
			)
			-- delete from ticket_map
			ticket_map[ticket_number] = nil
		end
	end
end

function M.start_time_tracking()
	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("JRTimeTrackingBufEnter", { clear = true }),
		callback = function()
			--TODO: find an event that fires less often than bufenter

			local ticket_number = git_stuff.get_jira_ticket_from_branch()
			current_ticket = ticket_number
		end,
	})

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = vim.api.nvim_create_augroup("JRTimeTracking", { clear = true }),
		callback = function()
			local ticket_number = current_ticket

			if not ticket_number then
				return
			end

			local current_time = os.time()

			if not ticket_map[ticket_number] then
				ticket_map[ticket_number] = {
					start_time = current_time,
					end_time = current_time,
				}
			end

			ticket_map[ticket_number].end_time = current_time
		end,
	})

	local timer = vim.loop.new_timer()
	local interval = check_timer_interval
	timer:start(
		0,
		interval,
		vim.schedule_wrap(function()
			check_interval()
		end)
	)
end

function M.print_ticket_map()
	print(vim.inspect(ticket_map))
end

return M

-- SELECT ticket_number, SUM(strftime('%s', end_time) - strftime('%s', start_time))  AS total_time_seconds
-- from tickets
-- GROUP BY ticket_number
