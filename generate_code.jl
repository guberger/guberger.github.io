using LiveServer

function generate_files(cycle_counter::Int)
    if mod(cycle_counter, 30) != 0
        return
    end

    filenames = readdir(joinpath(@__DIR__, "./pages"))

    header_str = read(joinpath(@__DIR__, "header.html"), String)
    footer_str = read(joinpath(@__DIR__, "footer.html"), String)

    for fname in filenames
        out_file = open(joinpath(@__DIR__, fname), "w")
        file_str = read(joinpath(@__DIR__, "./pages/", fname), String)
        write(out_file, header_str)
        write(out_file, file_str)
        write(out_file, footer_str)
        close(out_file)
    end
end

function my_serve()
    coreloopfun = (cycle_counter, fw) -> generate_files(cycle_counter)
    LiveServer.serve(coreloopfun=coreloopfun)
end

