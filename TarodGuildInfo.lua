
TarodGuildInfo = {}

TarodGuildInfo.name = "Tarod's Guild Info"
TarodGuildInfo.id = "TarodGuildInfo"
TarodGuildInfo.currentPlayer = nil
TarodGuildInfo.maxOnline = 15

function TarodGuildInfo:Initialize()
    TarodGuildInfo.currentPlayer = GetUnitName("player")
    d(zo_strformat("Welcome Back |cB27BFF<<1>>|r!", TarodGuildInfo.currentPlayer))
    TarodGuildInfo:GuildInfo() 
end

function TarodGuildInfo:GuildInfo() 
    local guildCount = GetNumGuilds()
    for idx = 1, guildCount do
        TarodGuildInfo:PrintGuildInfo(idx)
    end 
end

function TarodGuildInfo:PrintGuildInfo(idx)
    local guildId = GetGuildId(idx)
    local _, onlineMemberCount = GetGuildInfo(guildId)
    d(zo_strformat("|cFFFFFF<<1>>|r: |cFFB5F4<<2>>|r", GetGuildName(guildId), GetGuildMotD(guildId)))
    d(zo_strformat(" |cC3F0C2<<1[You are the only one online :(/There is only another member online:/There are $d members online:]>>|r", onlineMemberCount-1))
    if (onlineMemberCount < TarodGuildInfo.maxOnline ) then 
        TarodGuildInfo:PrintGuildMembers(guildId)
    end
end

function TarodGuildInfo:PrintGuildMembers(guildId)
    local guildMemberCount = GetNumGuildMembers(guildId)
    for idx=1, guildMemberCount do
        local pname,note,rank,status,logoff = GetGuildMemberInfo(guildId, idx)
        local hasChar, charName, zoneName, classType, alliance, level, cp, zoneId, consoleId = GetGuildMemberCharacterInfo(guildId, idx)
        
        -- Why GetUnitName returns formatted string while charName has the localization suffixes??
        if logoff == 0 and zo_strformat("<<1>>", charName) ~= TarodGuildInfo.currentPlayer then
            local gender = GetGenderFromNameDescriptor(charName)
            local className = GetClassName(gender, classType)
            if cp > 810 then cp = 810 end
            local levelText = nil
            local text = zo_strformat("   |cB27BFF|H1:character:<<1>>|h<<1>>|h|r/|c6EABCA<<2>>|r |cC3F0C2<<3>> <<4>> <<5[/%dcp/%dcp]>> in <<6>>|r", pname, charName, className, level, cp, zoneName)
            d(text)
        end
    end
end

function TarodGuildInfo.OnAddOnLoaded(event, addontName) 
    if addontName == TarodGuildInfo.id then
        TarodGuildInfo:Initialize()
    end
end

EVENT_MANAGER:RegisterForEvent(TarodGuildInfo.id, EVENT_ADD_ON_LOADED, TarodGuildInfo.OnAddOnLoaded)

SLASH_COMMANDS["/guildinfo"] = function (extra)
    local guilds = GetNumGuilds()
    local index = tonumber(extra)
    if index == nill or guilds == 0 then 
        TarodGuildInfo:GuildInfo()
    elseif index >= 1 and index <= guilds then 
        TarodGuildInfo:PrintGuildInfo(index)
    else
        d(zo_strformat("Please use |cC3F0C2/guildinfo|r |cB27BFF#num_guild|r where |cB27BFF#num_guild|r is a valid guild number between 1 and <<1>>", guilds))
        d("You can also use plain |cC3F0C2/guildinfo|r to get the default welcome message.")
    end
end

