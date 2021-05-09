using Clang
using Clang.LibClang.Clang_jll
pat = raw"C:\ADALM2000\libm2k"

# LIBCLANG_HEADERS are those headers to be wrapped.
const LIBCLANG_INCLUDE = joinpath(dirname(Clang_jll.libclang_path), "..", "include", "clang-c") |> normpath
const LIBCLANG_HEADERS = [joinpath(pat, header) for header in readdir(pat) if endswith(header, ".h")]

wc = init(; headers = LIBCLANG_HEADERS,
            output_file = joinpath(@__DIR__, "jllibm2k_api.jl"),
            common_file = joinpath(@__DIR__, "jllibm2k_common.jl"),
            clang_includes = vcat(LIBCLANG_INCLUDE, CLANG_INCLUDE),
            clang_args = ["-I", joinpath(LIBCLANG_INCLUDE, "..")],
            header_wrapped = (root, current)->root == current,
            header_library = x->"jllibm2k",
            clang_diagnostics = true,
            )

run(wc)
