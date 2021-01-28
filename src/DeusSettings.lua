return {
    -- Ignores scripts that end in specific extensions such as "Example.config" by adding ".config"
    IgnoredExtensions = {},

    -- Doesn't laod modules until they are needed
    LazyLoadModules = true,

    -- Ignores modules parented to modules
    IgnoreSubmodules = true,

    -- Adds Deus table to global shared table accessible by shared.Deus()
    AttachToShared = false,

    -- Creates a module in ReplicatedStorage that can be used by any script
    PubliclyAccessibleLoader = false,

    --[[
        NOTE: If 'AttachToShared' is 'false' Deus will still set 'shared.Deus()' and will remove itself after it is finished loading itself.
        If 'AttachToShared' and 'PubliclyAccessibleLoader' are false then 'shared.Deus()' will not be removed until it is run to allow
        one-time access.
    --]]
}