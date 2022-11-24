defmodule Bonfire.Breadpub.IntentLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive
  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  def mount(params, session, socket) do
    live_plug(params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3
    ])
  end

  defp mounted(%{"id" => id} = _params, _session, socket) do
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

  def handle_event(
        action,
        attrs,
        socket
      ),
      do:
        Bonfire.UI.Common.LiveHandlers.handle_event(
          action,
          attrs,
          socket,
          __MODULE__
          # &do_handle_event/3
        )

  def handle_params(params, uri, socket),
    do:
      Bonfire.UI.Common.LiveHandlers.handle_params(
        params,
        uri,
        socket,
        __MODULE__
      )

  def handle_info(info, socket),
    do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
