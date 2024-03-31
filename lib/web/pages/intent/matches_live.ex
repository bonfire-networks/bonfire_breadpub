defmodule Bonfire.Breadpub.MatchesLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop hits, :list, default: []

  def render(assigns) do
    ~F"""
    <StatelessComponent
      module={maybe_component(Bonfire.Search.Web.ResultsLive, @__context__)}
      search_limit="10"
      show_more_link={false}
    />
    """
  end
end
