function expranking_string(data)
    local f = openfile(".\\logs\\expranking.txt", "w")
    if f then
        write(f, data)
        closefile(f)
        Msg2Player("CËp nhËt d÷ liÖu xÕp h¹ng thµnh c«ng!")
    else
        Msg2Player("CËp nhËt d÷ liÖu xÕp h¹ng thÊt b¹i!")
    end
end