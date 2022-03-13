function key_init(num)
    gpio.setup(num, nil)    -- io num作为输入

end

function judge_key()
    local a = 0
    a= gpio.get(13)
    -- print(a)

    if a == 1 then
        print("mod")
        return 1
        -- sys.wait(500)
    end
end