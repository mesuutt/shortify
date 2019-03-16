defmodule CorePublic do

  def add_url(url, hash \\ nil) do
    Core.URL.add(url, hash)
  end

end
