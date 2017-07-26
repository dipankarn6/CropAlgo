defmodule Crops do

	def init do
		CSV.decode(File.stream!("Sample1.csv"))
		|> Stream.each(fn row -> row end)
		|> get_map
	end

	def get_map(stream) do
		Enum.to_list(stream)
		|> Map.new(fn {:ok,[a,b]} -> {a,b} end)
	end

	def input(crops,area,bed) do
		map=Crops.init
		crop_list=Map.keys(crops)
		IO.puts crop_list
		filtered_map=Map.take(map,crop_list)
		IO.puts filtered_map
		height_list=Map.values(filtered_map) |> Enum.sort(&(&1>=&2))
		x=fun1(height_list,filtered_map,[])
		print(x,crops,area,bed)
	end

	def fun1([],_,x) do
		x
	end

	def fun1(height_list,filtered_map,x) when is_list(height_list) do
			[head|tail]=height_list
			x=x ++ [filtered_map |> Enum.find(fn {_,val} -> val == head end ) |> elem(0)]
			fun1(tail,filtered_map,x)
	end

	def print(x,crops,area,bed) do
		#mat = Matrix.new(hd(area),hd(tl(area)))
		Mod.input(x,crops,hd(area),hd(tl(area)),bed)
	end
end
