defmodule Tinyrul.Deleter do

  def process() do
    :timer.sleep(10000)
    try do
      Tinyrul.Repository.Url.delete_links()
      |> IO.inspect(label: "deleter")
    rescue
      _ ->
        IO.inspect("deleter dropped")
        :timer.sleep(86390000)
        process()
    else
      _ ->
        :timer.sleep(86390000)
        process()
    end
  end

end
