defmodule LoadCap do
  use GenServer

  NimbleCSV.define(CapcsvParser, separator: ",", escape: "\"")

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :loadcap)
  end

  def stof(s), do: with({f, _} <- Float.parse(s), do: f)

  def init(_state) do
    #    capdat = %{"USA": %{cap: "Washington"},"India": %{cap: "New Delhi"}}

    with :undefined <- :ets.whereis(:capdat),
         do: :ets.new(:capdat, [:set, :named_table, :protected])

    with {:ok, capdat} <- loadcapcsv(),
         do: Enum.each(capdat, fn ea -> :ets.insert(:capdat, ea) end)

    {:ok, :success}
  end

  def loadcapcsv do
    {:ok, dat} = "concap.csv" |> File.read()

    capdat =
      CapcsvParser.parse_string(dat)
      |> Enum.take(15)
      |> Enum.reduce(%{}, fn [co, ca, la, lo, cd, cont], acc ->
        Map.put(acc, co, %{
          "cap" => ca,
          "lat" => stof(la),
          "long" => stof(lo),
          "code" => cd,
          "cont" => cont
        })
      end)

    {:ok, capdat}
  end

  def gcap(co) do
    [{_c, %{"cap" => cap}}] = :ets.lookup(:capdat, co)
    cap
  end

  def getlst do
    fst = :ets.first(:capdat)
    getlst(fst, [fst])
  end

  def getlst(:"$end_of_table", lst) do
    lst
  end

  def getlst(nxt, lst) do
    lst = [nxt | lst]
    nxt = :ets.next(:capdat, nxt)
    getlst(nxt, lst)
  end
end
