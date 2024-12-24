defmodule CapQuiz do
  @moduledoc """
  Documentation for `CapQuiz`.
  """

  use GenServer
  NimbleCSV.define(CapcsvParser, separator: ",", escape: "\"")

  def start_link() do
    GenServer.start_link(__MODULE__,[],name: :mname)
  end

 def init(_state) do
#    capdat = %{"USA": %{cap: "Washington"},"India": %{cap: "New Delhi"}}

   {:ok, dat} = "concap.csv" |> File.read()
   capdat = CapcsvParser.parse_string(dat) 
#         |> Enum.take(5)
         |> Enum.reduce(%{}, fn [co,ca,la,lo,cd,cont],acc -> Map.put(acc, co, %{"cap"=>ca,"lat"=>la,"long"=>lo,"code"=>cd,"cont"=>cont,"score" => 0}) end)
#        |> Enum.reduce([], fn [co,ca,la,lo,cd,cont],acc -> [%{"country"=>co,"cap"=>ca,"lat"=>stof(la),"long"=>stof(lo),"code"=>cd,"cont"=>cont,"score" => 0} |acc] end)

   {:ok, capdat}
 end

 def handle_call(:show,_from,capdat) do
   {:reply,capdat,capdat}
 end

 def incscore(co) do
   GenServer.cast(:mname,{:incscore,co})
 end

 def showdat() do
   GenServer.call(:mname,:show) 
 end

 def handle_cast({:incscore,co},capdat) do
  score = get_in(capdat,[co,"score"]) + 1
  {:noreply,put_in(capdat,[co,"score"],score)}
 end

 def minscore() do
  Enum.minshowdat
 end

 def startq() do


 end

 def qme("x") do
   IO.puts(" Game ended by user")
 end



 def qme(inp) do
    d = 
   {co,codat} = Enum.min_by(d,fn {c,n} -> n["score"] end)

   case Enum String.trim(IO.gets("capital of #{co}:")) do

   case "x" ->
    




   with inp when inp != "x" <- String.trim(IO.gets("")) do
     IO.puts(inp)
   end

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
