--- mupen-lua-ugui test runner
--- https://github.com/Aurumaker72/mupen-lua-ugui

function folder(file)
    local s = debug.getinfo(2, 'S').source:sub(2)
    local p = file:gsub('[%(%)%%%.%+%-%*%?%^%$]', '%%%0'):gsub('[\\/]', '[\\/]') .. '$'
    return s:gsub(p, '')
end

local groups = {
    dofile(folder('runner.lua') .. 'button.lua'),
    dofile(folder('runner.lua') .. 'toggle_button.lua'),
    dofile(folder('runner.lua') .. 'carrousel_button.lua'),
    dofile(folder('runner.lua') .. 'textbox.lua'),
    dofile(folder('runner.lua') .. 'joystick.lua'),
    dofile(folder('runner.lua') .. 'combobox.lua'),
    -- dofile(folder('runner.lua') .. 'listbox.lua'),
    -- dofile(folder('runner.lua') .. 'trackbar.lua'),
    -- dofile(folder('runner.lua') .. 'scrollbar.lua'),
}

local verbose = false

for key, group in pairs(groups) do
    print(string.format('Setting up %s...', group.name or ('test ' .. key)))

    -- Reset the ugui state completely between groups
    dofile(folder('tests\\runner.lua') .. 'mupen-lua-ugui.lua')

    if group.setup then
        group.setup()
    end

    for _, test in pairs(group.tests) do
        local test_params = test.params and test.params or {0}

        for test_param_index, test_param in pairs(test_params) do
            -- Optionally reset the state between individual tests too
            if group.keep_state_between_tests then
                dofile(folder('tests\\runner.lua') .. 'mupen-lua-ugui.lua')
            end

            local passed = true
            local fail_msgs = {}

            local test_context = {
                data = test_param,
                assert = function(condition, str)
                    if condition == false then
                        passed = false
                        fail_msgs[# fail_msgs + 1] = str
                    end
                end,
                log = function(str)
                    if verbose then
                        print('    [@] ' .. str)
                    end
                end,
            }

            test.func(test_context)

            local name = not test.params and test.name or string.format('%s (%d)', test.name, test_param_index)

            if passed then
                print(string.format('    PASS %s', name))
            else
                if #fail_msgs > 0 then
                    print(string.format('    FAIL %s:', name))

                    for _, msg in pairs(fail_msgs) do
                        print(string.format('      [!] %s', msg))
                    end
                else
                    print(string.format('    FAIL %s', name))
                end
            end
        end
    end

    print('')
end
