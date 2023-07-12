local git_stuff = require("jr.custom.git")
local Job = require("plenary.job")
local M = {}

-- {"CAVO-1234": {start_time: 1234, end_time: 1234}}
local ticket_map = {}
local current_ticket = nil
local check_timer_interval = 1000 * 60 -- 1 minute milliseconds
local ticket_idol_time = 60 -- 1 minute in seconds

local function check_interval(force)
	for ticket_number, ticket_info in pairs(ticket_map) do
		local current_time = os.time()
		local time_diff = current_time - ticket_info.end_time

		if time_diff > ticket_idol_time or force then
			local start_time_utc = os.date("!%Y-%m-%d %H:%M:%S", ticket_info.start_time)
			local end_time_utc = os.date("!%Y-%m-%d %H:%M:%S", ticket_info.end_time)

			local db_path = vim.fn.getcwd() .. "/time-tracking.db"

			local query = [[
        INSERT INTO tickets (ticket_number, start_time, end_time)
        VALUES (']] .. ticket_number .. [[', ']] .. start_time_utc .. [[', ']] .. end_time_utc .. [[')
        ]]

			Job:new({
				command = "sqlite3",
				args = {
					db_path,
					query,
				},
				on_exit = function(result, return_val)
					print("logged time for " .. ticket_number)
					-- delete from ticket_map
					if return_val == 0 then
						ticket_map[ticket_number] = nil
					end
				end,
				on_stderr = function(err, data)
					print("ON STDERR", vim.inspect(err), vim.inspect(data))
				end,
			}):sync()
		end
	end
end

function M.start_time_tracking()
	-- capture the current ticket from the branch name on an event that is fired often enough to
	-- pick up a change in branch, but not so often that it's a performance hit
	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("JRTimeTrackingBufEnter", { clear = true }),
		callback = function()
			local ticket_number = git_stuff.get_jira_ticket_from_branch()
			current_ticket = ticket_number
		end,
	})

	-- whenever the cursor is moved, capture or update the time tracking for the current ticket
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

	-- when vim exits, flush the time tracking
	vim.api.nvim_create_autocmd("VimLeave", {
		group = vim.api.nvim_create_augroup("JRTimeTrackingVimLeave", { clear = true }),
		callback = function()
			-- force flushing of time tracking before exit
			check_interval(true)
		end,
	})

	-- start a timer to check the idol time of a ticket and flush the time tracking range to the db
	-- if it's been idle for too long
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

function M.flush_time_tracking()
	check_interval(true)
end

function M.get_time_tracking()
	local db_path = vim.fn.getcwd() .. "/time-tracking.db"
	local response = vim.fn.system("sqlite3 " .. db_path .. " 'select * from tickets'")
	print(response)
end

function M.get_time_worked_for_ticket_async(ticket_number, callback)
	local db_path = vim.fn.getcwd() .. "/time-tracking.db"

	local query_by_ticket_number = [[
     SELECT ticket_number, SUM(strftime('%s', end_time) - strftime('%s', start_time))  AS total_time_seconds
     from tickets
     WHERE ticket_number = "]] .. ticket_number .. [["
     GROUP BY ticket_number
     ]]

	Job:new({
		command = "sqlite3",
		args = {
			db_path,
			query_by_ticket_number,
		},
		on_exit = function(j, return_val)
			local result = j:result()
			if #result == 0 then
				callback(nil)
			end
			for _, row in ipairs(result) do
				local row_split = vim.split(row, "|")
				callback(tonumber(row_split[2]))
			end
		end,
		on_stdout = function(j, data)
			print("on_stdout", data)
		end,
		on_stderr = function(j, data)
			print("on_stderr", data)
		end,
	}):start()
end

function M.delete_time_for_ticket(ticket_number)
	local db_path = vim.fn.getcwd() .. "/time-tracking.db"

	local query_by_ticket_number = [[
     DELETE FROM tickets
     WHERE ticket_number = "]] .. ticket_number .. [["
     ]]

	Job:new({
		command = "sqlite3",
		args = {
			db_path,
			query_by_ticket_number,
		},
		on_exit = function(j, return_val)
			print("deleted ticket " .. ticket_number)
		end,
		on_stdout = function(j, data)
			print("on_stdout", data)
		end,
		on_stderr = function(j, data)
			print("on_stderr", data)
		end,
	}):start()
end
return M

-- SELECT ticket_number, SUM(strftime('%s', end_time) - strftime('%s', start_time))  AS total_time_seconds
-- from tickets
-- GROUP BY ticket_number
