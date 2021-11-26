defmodule Bonfire.Breadpub.MatchesLive do
  use Bonfire.Web, :stateless_component

  prop hits, :list, default: []

  def render(assigns) do
    if module_enabled?(Bonfire.Search.Web.ResultsLive) do
      ~F"""
      <Bonfire.Search.Web.ResultsLive
        search_limit=10
        show_more_link={false}
      />
      """
    else
      ~F"""
      """
    end
  end
end