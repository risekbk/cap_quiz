defmodule CapQuiz do
  @moduledoc """
  Documentation for `CapQuiz`.
  """
  use GenServer
  import LoadCap

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: :capquiz)
  end

  def init(_state) do
    #    LoadCap.createets(:capquiz)
    state = Enum.reduce(getlst(), %{}, fn i, acc -> Map.put(acc, i, %{rgt: 0, tq: 0}) end)
    {:ok, state}
  end

  def handle_call(:show, _from, capdat) do
    {:reply, capdat, capdat}
  end

  def incscore(co) do
    GenServer.cast(:capquiz, {:incscore, co})
  end

  def handle_cast({:incscore, co}, capdat) do
    {_curr, capdat} =
      case co do
        {ct, true} ->
          Map.get_and_update(capdat, ct, fn x -> {x, %{rgt: x[:rgt] + 1, tq: x[:tq] + 1}} end)

        {ct, false} ->
          Map.get_and_update(capdat, ct, fn x -> {x, %{rgt: x[:rgt], tq: x[:tq] + 1}} end)
      end

    {:noreply, capdat}
  end

  def showdat() do
    GenServer.call(:capquiz, :show)
  end

  def qmin(n) do
    ques = showdat()

    ques
    |> Map.keys()
    |> Enum.sort_by(fn x -> ques[x][:rgt] end)
    |> Enum.take(n)
  end

  def qupdate(c) do
    ques = showdat()

    nq =
      ques
      |> Map.keys()
      |> Enum.sort_by(fn x -> ques[x][:rgt] end)
      |> Enum.take(1)
      |> hd()

    IO.puts("got min")

    a =
      Map.take(ques, c)
      |> Enum.map(fn
        {co, %{rgt: n}} when n < 4 -> co
        _ -> nq
      end)

    IO.inspect(a)
    a
  end

  def gi(inp) do
    gi2 = &String.trim(IO.gets("Capital of #{&1}: "))
    gi2.(inp)
  end

  def qme() do
    qlist = qmin(5)
    qloop("start", qlist, 0)
  end

  def qloop("x", _c, _n) do
    IO.puts("Exiting thanks for playing")
  end

  def qloop(_inp, c, n) do
    ct = Enum.at(c, n)
    ginp = gi(ct)
    cap = gcap(ct)

    if cap == ginp do
      incscore({ct, true})
    else
      incscore({ct, false})
      IO.puts("Answer is #{cap} Enter x to exit")
    end

    case n do
      4 ->
        qloop(ginp, qupdate(c), 0)

      _ ->
        qloop(ginp, c, n + 1)
    end
  end
end
