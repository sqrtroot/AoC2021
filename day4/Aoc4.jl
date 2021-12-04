### A Pluto.jl notebook ###
# v0.17.2

using Markdown
using InteractiveUtils

# ╔═╡ f858375d-0246-4fc2-a70d-aac19586c0b4
begin
	using PartialFunctions
	begin
		
		struct ReversedFunction{F<:Function} <: Function
		    func::F
		    ReversedFunction(rf::ReversedFunction) = rf.func
		    ReversedFunction(f::F) where F<:Function = new{F}(f)
		end 
		
		(r::ReversedFunction)(args...) = r.func(reverse(args)...)
		flip(f::F) where F<:Function = ReversedFunction(f)
	end;
end;

# ╔═╡ 20722bf8-2bc3-4d4e-84d0-c7846c35fe80
md"# Day 4"

# ╔═╡ bad36090-3f1f-47d2-ae80-151dd36d97b3
md"## file parser"

# ╔═╡ 8c3398df-1df6-4d43-80c1-6f38362c2136
parse_file(file) = open(file,"r") do f;
	numbers = readline(f) |> flip(split) $ ',' .|> parse $ Int;
	
	lines = readlines(f)
	splits = findall(==(""), lines) .|> start-> lines[start+1:start+5]
	parse_row(row) = reshape(row |> flip(split) $ " " |> filter $ !isempty .|> parse $ Int, :, 5)
	parse_board(board) = reduce(vcat,map(parse_row, board))
	Dict("numbers"=>numbers, "boards"=>map(parse_board, splits))
end

# ╔═╡ 2ed3f1cb-a361-457e-a0db-7f9fbf3a8da7
md"## Input"

# ╔═╡ 349b7516-5507-11ec-1130-15d5c91e6c28
test_input = parse_file("testinput")

# ╔═╡ 998eff29-8df9-4efc-99d3-36e263b4222b
input = parse_file("input")

# ╔═╡ e160dd23-f732-4169-9773-c874f9ea2fbc
md"## Helper functions"

# ╔═╡ 408ecc47-a648-4f5c-9fd1-024ef3069c13
count_matches_in_row(row, board, numbers) =
	count(==(row), findall(x->x∈numbers, board) .|> c->c[1])

# ╔═╡ 6c4a5ebc-9ff8-4ca8-ac4f-a1e2d5908076
@assert count_matches_in_row(1, test_input["boards"][1], Set([22;13])) == 2

# ╔═╡ d348a24d-47c5-4512-93b1-ae8e01f45ad7
check(board,valid_nums) = any(>=(5), 1:5 .|> r->count_matches_in_row(r, board,valid_nums))

# ╔═╡ 1a7e5a63-bda5-44e3-a3b3-75ff79b75f7b
check_board(board, valid_nums) = check(board, valid_nums) || check(board', valid_nums)

# ╔═╡ 084c41f9-5b66-4a7a-a656-50397eb08705
@assert check_board(test_input["boards"][1], Set([22;13;17;11;0]))

# ╔═╡ b374592e-78b5-418f-b8b3-51a3a055b466
@assert !check_board(test_input["boards"][1], Set([0;0;0;0;0]))

# ╔═╡ 3c3cc5c2-6771-4644-bb27-06da18ad1297
calculate_score(board, valid_nums) = sum(setdiff(board,valid_nums))*valid_nums[end]

# ╔═╡ f9012711-ad63-4def-ab9c-4a2cb426a973
md"# Part 1"

# ╔═╡ 4074134c-38c7-4e30-976c-cca702d66585
function p1(boards, numbers)
	for i in 1:length(numbers)
		testing = numbers[1:i]
		for board in boards
			if check_board(board, testing)
				return calculate_score(board, testing)
			end
		end
	end
end

# ╔═╡ 1b5c7aaa-9e29-460f-8312-a2258e2a788a
@assert p1(test_input["boards"],test_input["numbers"]) == 4512

# ╔═╡ 001c395a-947b-428b-abf4-bff693a94b3f
p1(input["boards"], input["numbers"])

# ╔═╡ a999e474-fb1b-4bd2-a039-e42f39c98744
md"# Part 2"

# ╔═╡ 6069c9ad-d67d-420f-b754-085d14c706ad
function p2(boards,numbers)
	already_won = zeros(length(numbers))
	for bi in 1:length(boards)
		for i in 1:length(numbers)
			if check_board(boards[bi], numbers[1:i])
				already_won[bi]=i
				break
			end
		end
	end
	score = max(already_won...)
	id = findfirst(==(score), already_won)
	boards[id], numbers[1:convert(Int,score)]
end

# ╔═╡ ca414da3-1f1a-4f44-94ce-b428f16e877b
@assert calculate_score(p2(test_input["boards"], test_input["numbers"])...) == 1924

# ╔═╡ 9622e547-7914-4f07-97f2-8f3bfdf695fa
t = p2(input["boards"], input["numbers"])

# ╔═╡ 43278d76-a510-419e-bd65-623d55394bc0
calculate_score(t...)

# ╔═╡ bd713c41-70c7-4493-81f0-d6309c7e80a0
md"# Part 1/2
doing them together is faster and a different method for part2"

# ╔═╡ b627f455-2104-4d06-a32a-14fee19f560d
function p3(boards,numbers)
	already_won = falses(length(numbers))
	win_count = 0
	first_win = undef
	last_win = undef
	for i in 1:length(numbers)
		for bi in 1:length(boards)
			if !already_won[bi] && check_board(boards[bi], numbers[1:i])
				already_won[bi]=true
				win_count += 1
				if first_win == undef
					first_win = calculate_score(boards[bi], numbers[1:i])
				end
				last_win = calculate_score(boards[bi], numbers[1:i])
			end
		end
		if win_count == length(boards)
			break
		end
	end
	return first_win, last_win
end

# ╔═╡ e5db17f8-7b63-45fd-8bdf-a73537647629
p3(test_input["boards"], test_input["numbers"])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PartialFunctions = "570af359-4316-4cb7-8c74-252c00c2016b"

[compat]
PartialFunctions = "~1.0.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[PartialFunctions]]
git-tree-sha1 = "c9e22bc046e05f549623d951ab33a6095017982d"
uuid = "570af359-4316-4cb7-8c74-252c00c2016b"
version = "1.0.4"
"""

# ╔═╡ Cell order:
# ╟─20722bf8-2bc3-4d4e-84d0-c7846c35fe80
# ╟─f858375d-0246-4fc2-a70d-aac19586c0b4
# ╟─bad36090-3f1f-47d2-ae80-151dd36d97b3
# ╠═8c3398df-1df6-4d43-80c1-6f38362c2136
# ╟─2ed3f1cb-a361-457e-a0db-7f9fbf3a8da7
# ╠═349b7516-5507-11ec-1130-15d5c91e6c28
# ╠═998eff29-8df9-4efc-99d3-36e263b4222b
# ╟─e160dd23-f732-4169-9773-c874f9ea2fbc
# ╠═408ecc47-a648-4f5c-9fd1-024ef3069c13
# ╠═6c4a5ebc-9ff8-4ca8-ac4f-a1e2d5908076
# ╠═d348a24d-47c5-4512-93b1-ae8e01f45ad7
# ╠═1a7e5a63-bda5-44e3-a3b3-75ff79b75f7b
# ╠═084c41f9-5b66-4a7a-a656-50397eb08705
# ╠═b374592e-78b5-418f-b8b3-51a3a055b466
# ╠═3c3cc5c2-6771-4644-bb27-06da18ad1297
# ╟─f9012711-ad63-4def-ab9c-4a2cb426a973
# ╠═4074134c-38c7-4e30-976c-cca702d66585
# ╠═1b5c7aaa-9e29-460f-8312-a2258e2a788a
# ╠═001c395a-947b-428b-abf4-bff693a94b3f
# ╟─a999e474-fb1b-4bd2-a039-e42f39c98744
# ╠═6069c9ad-d67d-420f-b754-085d14c706ad
# ╠═ca414da3-1f1a-4f44-94ce-b428f16e877b
# ╠═9622e547-7914-4f07-97f2-8f3bfdf695fa
# ╠═43278d76-a510-419e-bd65-623d55394bc0
# ╟─bd713c41-70c7-4493-81f0-d6309c7e80a0
# ╠═b627f455-2104-4d06-a32a-14fee19f560d
# ╠═e5db17f8-7b63-45fd-8bdf-a73537647629
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
