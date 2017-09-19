defmodule StreamDemo do

  defp start do
    File.open!("file.txt")
  end

  defp next(resource) do
    case IO.read(resource, :line) do
      data when is_binary(data) -> {[data], resource}
      _ -> {:halt, resource}
    end
  end

  defp finish(resource) do
    File.close(resource)
  end

  def stream do
    Stream.resource(&start/0, &next/1, &finish/1)
  end
end
