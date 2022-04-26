-- function which tells AI which heroes to target
function hero_target_active(unit)
    if unit.id == "Tallin" then
        return true
    elseif unit.id == "Aiglondur" then
        return true
    elseif unit.id == "Angras" then
        return true
    elseif unit.id == "Zorfu" then
        return true
    elseif unit.id == "Hamel" then
        return true
    elseif unit.id == "Kaayye" then
        return true
    elseif unit.id == "Eryssa" then
        return true
    else
        return false
    end
end