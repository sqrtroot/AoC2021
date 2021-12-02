### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ e766c090-5351-11ec-05e7-c76915db4f47
begin
	using LinearAlgebra
	using PartialFunctions
	@enum Direction Up Down Forward
	function Base.parse(::Type{Direction}, line::AbstractString)
		if line == "up" Up elseif line == "down" Down else Forward end 
	end
end

# ╔═╡ 1c7d5264-47be-485b-b021-4fb79a3eb02f
md"# Day 2 inputs and setup"

# ╔═╡ a5dca02b-c72e-4033-a479-018a06aef8a3
begin
	
	struct ReversedFunction{F<:Function} <: Function
	    func::F
	    ReversedFunction(rf::ReversedFunction) = rf.func
	    ReversedFunction(f::F) where F<:Function = new{F}(f)
	end 
	
	(r::ReversedFunction)(args...) = r.func(reverse(args)...)
	flip(f::F) where F<:Function = ReversedFunction(f)
end;

# ╔═╡ fd431ff4-813e-4c5b-a916-351e035fb19c
tilps = flip(split);

# ╔═╡ a3698a1d-3c8b-468e-b56a-819afcaed9db
parse_inputfile(file) = open(file,"r") do f; readlines(f).|>
	tilps $ " " .|>
	(zip $ [Direction, Int]) .|>
	map $ x->parse(x...)
end

# ╔═╡ 990d8ac0-0092-4c65-b2a9-c40ecfc1c42d
begin
	test_input = parse_inputfile("testinput")
	input = parse_inputfile("input")
	("test_input"=>test_input, "input"=>input)
end

# ╔═╡ c9b6dce4-47e9-443a-bc7b-a7d494f4fe65
md"# Part 1"

# ╔═╡ c14843b5-8fc0-4565-b253-0551c934e8f6
sum_direction(dir, dirs) = filter(x->x[1] == dir, dirs) .|> flip(getindex) $ 2 |> sum

# ╔═╡ c32827d7-99b3-4801-951f-d23f83880d7e
p1(x) = sum_direction(Forward, x) * (sum_direction(Down, x)-sum_direction(Up,x))

# ╔═╡ 5b8775e2-0225-4a7c-8dc7-2a7bc71a5e25
@assert p1(test_input) == 150

# ╔═╡ bafbc8c0-da61-4dca-b631-823f3ec46ca9
p1(input)

# ╔═╡ 18960d1f-d07b-4ab9-b62f-54c6717352ba
md"# Part2"

# ╔═╡ f65493ab-20a3-4c57-a173-7cd2b1edf7e6
function cartesian_course(dirs)
		aim = 0
		x = 0
		y = 0
		for d in dirs
			if d[1] == Forward
				x += d[2]
				y += aim*d[2]
			elseif d[1] == Down
				aim += d[2]
			elseif d[1] == Up
				aim -= d[2]
			end
		end
		return [x;y]
end

# ╔═╡ b557d130-b855-4cf8-bd0d-e5d589403014
@assert cartesian_course(test_input) |> reduce $ (*) == 900

# ╔═╡ bc6bcff8-ce83-4e58-8382-e4f55ebd7de4
cartesian_course(input) |> reduce $ (*)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"

[compat]
PartialFunctions = "~1.0.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[PartialFunctions]]
git-tree-sha1 = "c9e22bc046e05f549623d951ab33a6095017982d"
uuid = "570af359-4316-4cb7-8c74-252c00c2016b"
version = "1.0.4"
"""

# ╔═╡ Cell order:
# ╟─1c7d5264-47be-485b-b021-4fb79a3eb02f
# ╠═e766c090-5351-11ec-05e7-c76915db4f47
# ╟─a5dca02b-c72e-4033-a479-018a06aef8a3
# ╠═fd431ff4-813e-4c5b-a916-351e035fb19c
# ╠═a3698a1d-3c8b-468e-b56a-819afcaed9db
# ╠═990d8ac0-0092-4c65-b2a9-c40ecfc1c42d
# ╟─c9b6dce4-47e9-443a-bc7b-a7d494f4fe65
# ╠═c14843b5-8fc0-4565-b253-0551c934e8f6
# ╠═c32827d7-99b3-4801-951f-d23f83880d7e
# ╠═5b8775e2-0225-4a7c-8dc7-2a7bc71a5e25
# ╠═bafbc8c0-da61-4dca-b631-823f3ec46ca9
# ╟─18960d1f-d07b-4ab9-b62f-54c6717352ba
# ╠═f65493ab-20a3-4c57-a173-7cd2b1edf7e6
# ╠═b557d130-b855-4cf8-bd0d-e5d589403014
# ╠═bc6bcff8-ce83-4e58-8382-e4f55ebd7de4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
