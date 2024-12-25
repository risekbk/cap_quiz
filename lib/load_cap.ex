defmodule LoadCap do

 NimbleCSV.define(CapcsvParser, separator: ",", escape: "\"")
 def stof(s), do: with {f,_} <- Float.parse(s), do: f

 def loadcapcsv() do
#    capdat = %{"USA": %{cap: "Washington"},"India": %{cap: "New Delhi"}}

   {:ok, dat} = "concap.csv" |> File.read()
   capdat = CapcsvParser.parse_string(dat) 
#         |> Enum.take(5)
         |> Enum.reduce(%{}, fn [co,ca,la,lo,cd,cont],acc -> Map.put(acc, co, %{"cap"=>ca,"lat"=>stof(la),"long"=>stof(lo),"code"=>cd,"cont"=>cont}) end)

   {:ok, capdat}
 end



 def createets() do
  with :undefined <- :ets.whereis(:captable), do: :ets.new(:captable,[:set,:named_table,:protected])
  with {:ok,capdat} <-loadcapcsv(), do: Enum.each(capdat, fn ea -> :ets.insert(:captable,ea) end)
  

 end

end
