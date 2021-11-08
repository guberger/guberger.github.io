# Largely inspired from https://github.com/tlienart/Franklin.jl

using LiveServer

function process_file(PATHS, fpair, header, footer)
    inp = joinpath(fpair...)
    out = open(joinpath(PATHS[:folder], fpair.second), "w")
    content = read(inp, String)
    write(out, header)
    write(out, content)
    write(out, footer)
    close(out)
    return nothing
end

function add_if_new_file!(dict, fpair)
    haskey(dict, fpair) && return nothing
    # it's a new file
    println("tracking new file '$(fpair.second)'.")
    # save it's modification time, set to zero if it's a new file in a loop
    # to force its processing in FS2
    dict[fpair] = 0
    return nothing
end

function scan_input_dir!(PATHS, watched_files)
    # fill the dictionaries
    for (root, _, files) ∈ walkdir(PATHS[:folder])
        for file in files
            # assemble full path (root is an absolute path)
            fpath = joinpath(root, file)
            fpair = root => file
            # early skips
            !isfile(fpath) && continue
            # add files
            if startswith(fpath, PATHS[:assets])
                add_if_new_file!(watched_files.assets, fpair)
            elseif startswith(fpath, PATHS[:body])
                add_if_new_file!(watched_files.body, fpair)
            elseif startswith(fpath, PATHS[:layout])
                add_if_new_file!(watched_files.layout, fpair)
            end
        end
    end
    return nothing
end

function fd_setup()
    PATHS = Dict{Symbol,String}()
    PATHS[:folder] = @__DIR__
    PATHS[:body] = joinpath(@__DIR__, "body")
    PATHS[:layout] = joinpath(@__DIR__, "layout")
    PATHS[:assets] = joinpath(@__DIR__, "assets")
    # named tuples of all the watched files (order matters)
    watched_files = (body = Dict{Pair{String,String},Float64}(),
                    layout = Dict{Pair{String,String},Float64}(),
                    bib = Dict{Pair{String,String},Float64}(),
                    assets = Dict{Pair{String,String},Float64}())
    scan_input_dir!(PATHS, watched_files)
    return PATHS, watched_files
end

function fd_loop(cycle_counter, PATHS, watched_files)
    # every 30 cycles (3 seconds), scan directory to check for new or deleted
    # files and update dicts accordingly
    if mod(cycle_counter, 30) == 0
        # 1) check if some files have been deleted; note that we don't do
        # anything, we just remove the file reference from the corresponding
        # dictionary.
        for d ∈ watched_files, (fpair, _) ∈ d
            fpath = joinpath(fpair...)
            if !isfile(fpath)
                delete!(d, fpair)
            end
        end
        # 2) scan the input folder, if new files have been added then this will
        # update the dictionaries
        scan_input_dir!(PATHS, watched_files)
    else
        # do a pass over the files, check if one has changed and if so trigger
        # the appropriate file processing mechanism
        for (_, dict) ∈ pairs(watched_files), (fpair, t) ∈ dict
            # check if there was a modification to the file
            fpath = joinpath(fpair...)
            cur_t = mtime(fpath)
            cur_t <= t && continue
            # if there was then the file has been modified and should be
            # re-processed + copied
            fmsg = rpad("→ file $(fpath[length(PATHS[:folder])+1:end]) was " *
                 "modified ", 30)
            print(fmsg)
            dict[fpair] = cur_t

            # if it's a layout file, trigger build of all body files
            if haskey(watched_files[:layout], fpair)
                fmsg = fmsg * rpad("→ updating... ", 15)
                print("\r" * fmsg)
                start = time()
                # retrieve head, foot etc
                header = read(joinpath(PATHS[:layout], "header.html"), String)
                footer = read(joinpath(PATHS[:layout], "footer.html"), String)
                # process all body files
                for fpair in keys(watched_files.body)
                    process_file(PATHS, fpair, header, footer)
                end
            # if it's a body file, trigger build of only this file
            elseif haskey(watched_files[:body], fpair)
                fmsg = fmsg * rpad("→ updating... ", 15)
                print("\r" * fmsg)
                start = time()
                # retrieve head, foot etc
                header = read(joinpath(PATHS[:layout], "header.html"), String)
                footer = read(joinpath(PATHS[:layout], "footer.html"), String)
                # then process
                process_file(PATHS, fpair, header, footer)
            end
            
            print("\n")
        end
    end
    return nothing
end

function preview_site()
    PATHS, watched_files = fd_setup()
    coreloopfun = (ctr, _) -> fd_loop(ctr, PATHS, watched_files)
    LiveServer.serve(coreloopfun=coreloopfun)
end

