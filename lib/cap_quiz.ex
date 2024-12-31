defmodule CapQuiz do
  @moduledoc """
  Documentation for `CapQuiz`.
  """
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__,[],name: :mname)
  end

  def getlst(:"$end_of_table",lst) do
    lst
  end

  def getlst(nxt,lst) do
    lst = [nxt | lst]
    nxt = :ets.next(:mname,nxt)
    getlst(nxt ,lst)
  end

 def init(_state) do
    LoadCap.createets(:mname)
    fst = :ets.first(:mname)
    lst = CapQuiz.getlst(fst,[fst])
    state = Enum.reduce(lst,%{},fn i,acc -> Map.put(acc,i,%{rgt: 0,tq: 0}) end)
    {:ok,state}
 end

 def handle_call(:show,_from,capdat) do
   {:reply,capdat,capdat}
 end

 def incscore(co) do
   GenServer.cast(:mname,{:incscore,co})
 end

 def handle_cast({:incscore,co},capdat) do
   {_curr,capdat} = Map.get_and_update(capdat,co,fn x ->{x,%{rgt: x[:rgt]+1,tq: x[:tq]+1}} end)
   {:noreply,capdat}
 end

 def showdat() do
   GenServer.call(:mname,:show) 
 end


 def minscore() do
#  Enum.minshowdat
 end

 def qme("x",_) do
   IO.puts(" Game ended by user")
 end
 
 def qme(co,at) do
   [{_c,%{"cap" => cap}}] = :ets.lookup(:mname,co)
   IO.puts("Retrieved cap #{cap}")
   case String.trim(IO.gets("Capital of #{co}:")) do
   ^cap -> 
      IO.puts("Entered cap #{cap}")
      incscore(co) 
    "x"-> 
      IO.puts("Answer is #{cap}")
    _ ->
      IO.puts("Answer is #{cap} Enter x to exit")
   end 
 end

 def qme() do
  GenServer.call(:startquiz)
 end

 def handle_call(:startquiz,capdat) do
  qme(Enum.at(capdat,0),0)
 end

 def qme_old(inp) do

#  Enum.count(c)
#   {co,codat} = Enum.min_by(d,fn {c,n} -> n["score"] end)
#
#   case Enum String.trim(IO.gets("capital of #{co}:")) do
#
#   case "x" ->
#    
#   with inp when inp != "x" <- String.trim(IO.gets("")) do
#     IO.puts(inp)
#   end

 end



  @doc """
  Hello world.

  ## Examples

      iex> CapQuiz.hello()
      :world

  """
  def hello do
    :world
  end
end
