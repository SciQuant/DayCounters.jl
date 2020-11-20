using DayCounters
using Documenter

makedocs(;
    modules=[DayCounters],
    authors="Ramiro Vignolo <ramirovignolo@gmail.com> and contributors",
    repo="https://github.com/rvignolo/DayCounters.jl/blob/{commit}{path}#L{line}",
    sitename="DayCounters.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
