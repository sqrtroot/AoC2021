### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ 5d3554d4-78b5-4e52-96ef-baf2b775eef9
md"
# Day 1 inputs
"

# ╔═╡ 2f0ca3bc-c93a-4cb8-8166-fb268a67e291
begin
	input = open("input","r") do f; (x->parse(Int,x)).(readlines(f)); end
	test_input = open("testinput","r") do f; (x->parse(Int,x)).(readlines(f)); end
	("test_input"=>test_input, "input"=>input)
end

# ╔═╡ 70e75554-e2b4-4c7e-b8fc-8f03aa30bee6
md"
# Part 1
"

# ╔═╡ abe3187d-0c78-4fc3-88c4-8335acd7ea82
p1(x) = count(<(0),x[1:end-1] - x[2:end])

# ╔═╡ 2e59bfac-60ad-40a3-a216-665409482205
@assert p1(test_input) == 7

# ╔═╡ d63a1f63-162c-4e1c-a76d-51e6a7bac389
p1(input)

# ╔═╡ e5fd579a-d488-4ff2-90ae-6763b5fa5ccd
md"# Part 2"

# ╔═╡ 58a22805-714c-496b-a59f-8e61719cdbea
p2(x) = x+[x[2:end];0]+[x[3:end];0;0]

# ╔═╡ d2db12b9-dab6-496c-bb21-0d96a45a622c
@assert p1(p2(test_input)) == 5

# ╔═╡ 1bb9b24c-7544-4d3c-8627-50ee740c033a
p1(p2(input))

# ╔═╡ Cell order:
# ╟─5d3554d4-78b5-4e52-96ef-baf2b775eef9
# ╟─2f0ca3bc-c93a-4cb8-8166-fb268a67e291
# ╟─70e75554-e2b4-4c7e-b8fc-8f03aa30bee6
# ╠═abe3187d-0c78-4fc3-88c4-8335acd7ea82
# ╠═2e59bfac-60ad-40a3-a216-665409482205
# ╠═d63a1f63-162c-4e1c-a76d-51e6a7bac389
# ╟─e5fd579a-d488-4ff2-90ae-6763b5fa5ccd
# ╠═58a22805-714c-496b-a59f-8e61719cdbea
# ╠═d2db12b9-dab6-496c-bb21-0d96a45a622c
# ╠═1bb9b24c-7544-4d3c-8627-50ee740c033a
