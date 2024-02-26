defmodule Bonfire.Breadpub.IntentLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive
  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(%{"id" => id} = _params, _session, socket) do
    intent = intent(%{id: id}, socket)

    if !intent || intent == %{intent: nil} do
      {:error, :not_found}
    else
      intent =
        intent
        |> Map.put(:is_offer, e(intent, :provider, nil) != nil)
        |> Map.put(:is_need, e(intent, :receiver, nil) != nil)

      {:ok,
       assign(
         socket,
         page_title: "Intent",
         intent: intent,
         matches: ValueFlows.Util.search_for_matches(intent),
         without_sidebar: true,
         showing_within: :intent
       )}

      # |> IO.inspect
    end
  end

  @graphql """
    query($id: ID) {
      intent(id: $id) {
        id
        name
        note
        due
        finished
        context: in_scope_of
        provider {
          id
          name
          display_username
          image
        }
        receiver {
          id
          name
          display_username
          image
        }
      }
    }
  """
  def intent(params \\ %{}, socket), do: liveql(socket, :intent, params)
end
