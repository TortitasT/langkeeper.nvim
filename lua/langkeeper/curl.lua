return {
  curl = function(opts)
    local url = opts.url
    local args = opts.raw or {}

    if opts.compressed then
      table.insert(args, "--compressed")
    end

    if opts.body then
      table.insert(args, "-d")
      table.insert(args, opts.body)
    end

    if opts.headers then
      for k, v in pairs(opts.headers) do
        table.insert(args, "-H")
        table.insert(args, k .. ": " .. v)
      end
    end

    if opts.timeout then
      table.insert(args, "--max-time")
      table.insert(args, opts.timeout / 1000)
    end

    if opts.method then
      table.insert(args, "-X")
      table.insert(args, opts.method)
    end

    table.insert(args, url)

    local stdout = vim.loop.new_pipe(false)

    vim.loop.spawn("curl", {
      args = args,
      stdio = { nil, stdout, nil },
    }, function(_, _, _)
      if opts.on_success then
        vim.loop.read_start(stdout, function(err, data)
          assert(not err, err)
          if data then
            opts.on_success(data)
          end
        end)
      end
    end)
  end
}
