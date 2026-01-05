local user_ids = {
	878674194, 
	4724648468,
	149759419,
	2294188446,
	5818696713,
	2594901738,
	1433699977,
	4062996700,
	1341435676,
	7352054833,
	189713559,
	5832510716,
	2520455298,
	2050161622,
	1106320934,
	3600755696,
	137723571,
	935864306,
	582370,
	51796,
	8460804257,
	3525918505,
	2835853128,
	2395613299,
	2506320774,
	494401813,
	60265,
	4337893156,
	682887852,
	8390626336,
	7197552531,
	558638,
	2578972524,
	8142054648,
	4544888724,
	7225903,
	8280673725,
	2412582194,
	2357168230,
	7438567227,
	7412920468,
	7411162962,
	9409314548,
	16132908,
	5042090443,
	1491576084,
	4045474373,
	8130930626,
	8137825406,
	4709828943,
	2415886442,
	5801091074,
	29242182,
	7411200326,
	3924496689,
	852347682,
	279773,
	5019169384,
	4891411890,
	1602593335,
	326671671,
	343182231,
	4339819060,
	1658496,
	2388584611,
	1679536495,
	3576067905,
	2555761663,
	4649864403,
	5036683208,
	36786456,
	3376509853,
	1226086717,
	8812431342,
}
local players = {}
local notifications = {}

local function ease_out_quint(t)
    return 1 - (1 - t) ^ 5
end

local function notify(player_name)
    table.insert(notifications, 1, {
        name = player_name,
        time = utility.GetTickCount()
    })
end

local function get_players()
    local active_players = {}
    for _, player in ipairs(game.Players:GetChildren()) do
        if player and player.Address then
            active_players[player.Address] = {
                user_id = player.UserId,
                name = player.Name
            }
            if not players[player.Address] then
                for _, mod_id in ipairs(user_ids) do
                    if player.UserId == mod_id then
                        notify(player.Name)
                        break 
                    end
                end
            end
        end
    end
    players = active_players
end

local function draw_notifications()
    if #notifications == 0 then
        return
    end

    local now = utility.GetTickCount()
    local screen_width, screen_height = cheat.GetWindowSize()

    local active_notifications = {}
    local notification_height = 65
    local margin = 5
    local current_y_position = screen_height - notification_height -- Starting y position

    for i, notification in ipairs(notifications) do
        local time = now - notification.time
        if time < 30000 then
            table.insert(active_notifications, notification)

            local progress = 1
            if time < 500 then
                progress = time / 500
            elseif time > 30000 - 500 then
                progress = (30000 - time) / 500
            end

            local eased_progress = ease_out_quint(progress)
            local current_x = screen_width + ((screen_width - 250 - 5) - screen_width) * eased_progress
            local alpha = 255 * eased_progress

            -- Draw the notification background
            draw.RectFilled(current_x, current_y_position, 250, notification_height, Color3.fromRGB(18, 22, 28), 5, alpha)
            draw.Rect(current_x, current_y_position, 250, notification_height, Color3.new(0, 1, 1), 1, 5, alpha)
            
            local _, text_height = draw.GetTextSize("A", "Verdana")
            local text_x = current_x + 10
            local text_y = current_y_position + 10
            
            -- Draw the title and name
            draw.TextOutlined("Nigger Spotted!", text_x, text_y, Color3.fromRGB(255, 50, 50), "Verdana", alpha)
            draw.TextOutlined("Name: " .. notification.name, text_x, text_y + text_height + 4, Color3.new(1, 1, 1), "Verdana", alpha)

            -- Draw the loading bar
            local bar_progress = (30000 - time) / 30000  -- Calculate progress
            local bar_width = (250 - 12) * bar_progress  -- Width of the bar based on time left
            local bar_x = current_x + 6
            local bar_y = current_y_position + notification_height - 4 - 8  -- Position of the bar

            draw.RectFilled(bar_x, bar_y, bar_width, 4, Color3.new(0, 1, 1), 2, alpha)  -- Draw the loading bar

            -- Update position for the next notification
            current_y_position = current_y_position - (notification_height + margin)
        end
    end

    notifications = active_notifications
end

cheat.register("onSlowUpdate", get_players)
cheat.register("onPaint", draw_notifications)
