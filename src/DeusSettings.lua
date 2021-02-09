return {
    -- Ignores scripts that end in specific extensions such as "Example.config" by adding ".config"
    IgnoredExtensions = {},

    -- Doesn't laod modules until they are needed
    LazyLoadModules = true,

    -- Ignores modules parented to modules
    IgnoreSubmodules = true,

    -- Adds Deus table to global shared table accessible by shared.Deus
    AttachToShared = true,

    -- Creates a module in ReplicatedStorage that can be used by any script
    PubliclyAccessibleLoader = false,
}