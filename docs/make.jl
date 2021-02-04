using DayCounters
using Documenter
using DocumenterTools: Themes

# download themes
for file in ("sciquant-lightdefs.scss", "sciquant-darkdefs.scss", "sciquant-style.scss")
    download("https://raw.githubusercontent.com/SciQuant/doctheme/master/$file", joinpath(@__DIR__, file))
end

# create themes
for w in ("light", "dark")
    header = read(joinpath(@__DIR__, "sciquant-style.scss"), String)
    theme = read(joinpath(@__DIR__, "sciquant-$(w)defs.scss"), String)
    write(joinpath(@__DIR__, "sciquant-$(w).scss"), header*"\n"*theme)
end

# compile themes
Themes.compile(joinpath(@__DIR__, "sciquant-light.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-light.css"))
Themes.compile(joinpath(@__DIR__, "sciquant-dark.scss"), joinpath(@__DIR__, "src/assets/themes/documenter-dark.css"))

makedocs(;
    modules=[DayCounters],
    authors="SciQuant",
    repo="https://github.com/SciQuant/DayCounters.jl/blob/{commit}{path}#L{line}",
    sitename="DayCounters.jl",
    format=Documenter.HTML(;
        prettyurls=false,
        canonical="https://SciQuant.github.io/DayCounters.jl/dev",
        assets = [
        "assets/logo.ico",
        asset("https://fonts.googleapis.com/css?family=Lato|Source+Code+Pro&display=swap", class=:css),
        ],
        collapselevel = 1,
    ),
    pages=[
        "Introduction" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/SciQuant/DayCounters.jl",
    devbranch = "main"
)
