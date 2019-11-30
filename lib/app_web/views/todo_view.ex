defmodule AppWeb.TodoView do
  use AppWeb, :view

  # pattern is from https://github.com/bryanwoods/autolink-js/blob/master/autolink.js
  @url_pattern ~r/(^|[\s\n]|<[A-Za-z]*\/?>)((?:https?|ftp):\/\/[\-A-Za-z0-9+@#\/%?=()~_|!:,.;]*[\-A-Za-z0-9+@#\/%=~()_|])/

  def url_to_safelink(_all, prev, url) do
    link = Phoenix.HTML.Link.link(url, to: url, target: "_blank")
    |> Phoenix.HTML.safe_to_string()
    prev <> link
  end

  def autolinker(text) do
    safe_text = text
    |> Phoenix.HTML.html_escape()
    |> Phoenix.HTML.safe_to_string()
    @url_pattern
    |> Regex.replace(safe_text, &url_to_safelink/3)
  end
end
