local present, barbar = pcall(require, "barbar")
if not present then
    return
end

barbar.setup({
    animation = false,
    icons = {
        modified = {button = ''},
    }
})

