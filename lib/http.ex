defmodule StreamDemo.HTTP do

  @api_key Application.get_env(:streamdemo, :github_key)

  defp start do
    "https://api.github.com/repos/elixir-lang/elixir/issues"
  end

  defp next(nil) do
    {:halt, nil}
  end

  defp next(url) do
    IO.puts("Calling: #{url}")
    data = get_url(url)
    body = data.body |> Poison.Parser.parse!
    link = data.headers |> Enum.find(&(elem(&1, 0) == "Link"))

    {body, parse_links(link, url)}
  end

  defp finish(_) do
  end

  def stream do
    Stream.resource(&start/0, &next/1, &finish/1)
    |> Stream.map(&(&1["id"]))
  end

  def get_url(url) do
    headers = ["Authorization": "Bearer #{@api_key}"]
    HTTPoison.get!(url, headers, [])
  end

  def parse_links({"Link", links}, current_url) do
    regex = ~r/<(?<next_url>.+)>; rel=\"next\", <(?<last_url>.+)>; rel=\"last\"/
    captures = Regex.named_captures(regex, links)

    cond do
      captures["next_url"] === current_url -> nil
      true -> captures["next_url"]
    end
  end
end
