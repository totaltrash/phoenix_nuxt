defmodule Web.Encoder do
  @moduledoc """
  Encoder adapted from https://elixirforum.com/t/serializing-ash-structs-with-jason/58654/3
  """
  def encode(resources, opts \\ []) do
    sanitize(resources, opts)
  end

  defp sanitize(records, opts) when is_list(records) do
    Enum.map(records, &sanitize(&1, opts))
  end

  defp sanitize(%resource{} = record, opts) do
    if Ash.Resource.Info.resource?(resource) do
      fields = opts[:fields] || public_attributes(record)

      Map.new(fields, fn
        {field, further} ->
          {field, sanitize(Map.get(record, String.to_existing_atom(field)), further)}

        field ->
          {field, sanitize(Map.get(record, String.to_existing_atom(field)), [])}
      end)
    else
      record
    end
  end

  defp sanitize(value, _), do: value

  defp public_attributes(%resource{}) do
    resource
    |> Ash.Resource.Info.public_attributes()
    |> Enum.map(& &1.name)
  end
end
