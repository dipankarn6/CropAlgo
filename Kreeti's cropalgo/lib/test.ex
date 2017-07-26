defmodule Mod do
    def input(x,crops,a,b,bed) do
      bed = Enum.sort(bed)
      mat = Matrix.new(a,b,"_")
      [mat,list] = fill_beds(mat,bed,[])
      mid_pos=find_mid(bed,[])
      mat = make_matrix(x,crops,mat,list,mid_pos,bed)
      print_bed(mat)
    end

    def find_mid([],mid_pos) do
      mid_pos
    end

    def find_mid(bed,mid_pos) do
      each_bed = hd(bed)
      mid = trunc(Math.sqrt(Math.pow(Enum.at(each_bed,2),2) + Math.pow(Enum.at(each_bed,3),2))/2)
      mid_pos = mid_pos ++ [[mid+Enum.at(each_bed,0)-1,mid+Enum.at(each_bed,1)-1]]
      find_mid(tl(bed),mid_pos)
    end

    def make_matrix([],_,mat,_,_,_) do
      mat
    end

    def make_matrix(x,crops,mat,list,mid_pos,bed) do
      plant = hd(x)
      seeds = crops[plant]
      [mat,list] = fill_plant(plant,seeds,mat,list,mid_pos,bed)
      make_matrix(tl(x),crops,mat,list,mid_pos,bed)
    end

    def fill_plant(_,seeds,mat,list,_,_) when seeds == 0 do
      [mat,list]
    end

    def fill_plant(plant,seeds,mat,list,mid_pos,bed) when seeds > 0 do
      [i,j] = hd(list)
      mat = Matrix.set(mat,i,j,plant)
      list = tl(list)
      if seeds-1 <=2 and seeds-1 > 0 and Enum.any?(bed, fn [a,b,c,d] -> a+c-1 == i and b+d-1 == j end) do
        [[a,b,c,d]] = Enum.filter(bed, fn [a,b,c,d] -> a+c-1 == i and b+d-1 == j end)
        index = Enum.find_index(bed, fn(x) -> x == [a,b,c,d] end)
        [mat,list] = nearest_mat(plant,seeds-1,mat,list,mid_pos,index,bed)
        seeds = 1
        fill_plant(plant,seeds-1,mat,list,mid_pos,bed)
      else
        fill_plant(plant,seeds-1,mat,list,mid_pos,bed)
      end
    end

    def find_distance(point1,point2) do
      Math.sqrt(Math.pow(hd(point2)-hd(point1),2) + Math.pow(hd(tl(point2))-hd(tl(point1)),2))
    end

    def min_distance(_,[],min_list) do
      min_list
    end

    def min_distance(point1,mid_pos,min_list) do
      point2 = hd(mid_pos)
      min_list = min_list ++ [find_distance(point1,point2)]
      min_distance(point1,tl(mid_pos),min_list)
    end

    def nearest_mat(plant,seeds,mat,list,mid_pos,index,bed) do
      {x,mid_pos} = Enum.split(mid_pos,index)
      min_list = min_distance(hd(mid_pos),tl(mid_pos),[])
      min = Enum.min(min_list)
      index = Enum.find_index(min_list,fn(x)-> x == min end) + length(x)
      nearest_bed = Enum.at(bed,index+1)
      spcl_case(plant,seeds,mat,list,nearest_bed)
    end
    def check(mat,i,j) do
      if Matrix.elem(mat,i,j) != "0" do
        check(mat,i,j+1)
      else
        [i,j]
      end
    end
    def spcl_case(plant,seeds,mat,list,nearest_bed) when seeds <=2 do
      [i,j] = [Enum.at(nearest_bed,0),Enum.at(nearest_bed,1)]
      [i,j] = check(mat,i,j)
      if seeds == 2 do
        mat = Matrix.set(mat,i,j,plant)
        mat = Matrix.set(mat,i,j+1,plant)
        list = List.delete(list,[i,j])
        list = List.delete(list,[i,j+1])
        [mat,list]
      else
        mat = Matrix.set(mat,i,j,plant)
        list = List.delete(list,[i,j])
        [mat,list]
      end
    end

    def print_bed([]) do
      IO.puts ":ok"
    end

    def print_bed(mat) when is_list(mat) do
      IO.inspect hd(mat)
      print_bed(tl(mat))
    end

    def fill_beds(mat,[],list) do
      [mat,list]
    end

    def fill_beds(mat,bed,list) do
      each_bed = hd(bed)
      row =Enum.at(each_bed,0) + Enum.at(each_bed,2)
      col =Enum.at(each_bed,1) + Enum.at(each_bed,3)
      [mat,list] = fun1(mat,Enum.at(each_bed,0),Enum.at(each_bed,1),row,col,list)
      fill_beds(mat,tl(bed),list)
    end

    def fun1(mat,i,_,row,_,list) when i == row do
      [mat,list]
    end

    def fun1(mat,i,j,row,col,list) when i < row do
      [mat,list]=fun2(mat,i,j,row,col,list)
      fun1(mat,i+1,j,row,col,list)
    end

    def fun2(mat,_,j,_,col,list) when j == col do
      [mat,list]
    end

    def fun2(mat,i,j,row,col,list) when j < col do
      list =list ++ [[i,j]]
      mat = Matrix.set(mat,i,j,"0")
      fun2(mat,i,j+1,row,col,list)
    end
end
