files = readdir(joinpath(@__DIR__, "./pages"))

header_s = read(joinpath(@__DIR__, "header.html"), String)
footer_s = read(joinpath(@__DIR__, "footer.html"), String)

for f in files
    out_file = open(joinpath(@__DIR__, f), "w")
    s = read(joinpath(@__DIR__, "./pages/", f), String)
    write(out_file, header_s)
    write(out_file, s)
    write(out_file, footer_s)
    close(out_file)
end