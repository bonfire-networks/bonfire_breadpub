defmodule Bonfire.Breadpub.MapLive do
  use Bonfire.Web, {:live_view, [layout: {Bonfire.Breadpub.LayoutView, "live.html"}]}

  use AbsintheClient, schema: Bonfire.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.Web.LivePlugs

  def mount(params, session, socket) do
    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf, LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(params, session, socket) do
    # intents = Bonfire.Breadpub.ProposalLive.all_intents(socket)
    #debug(intents)

    {:ok, socket
    |> assign(
      page_title: "Map",
      selected_tab: "about",
      markers: [],
      points: [],
      place: nil,
      main_labels: []
    )}
  end

  def fetch_place_things(filters, socket) do
    with {:ok, things} <-
           ValueFlows.Planning.Intent.Intents.many(filters) do
      debug(things)

      things =
        things
        |> Enum.map(
          &Map.merge(
            Bonfire.Geolocate.Geolocations.populate_coordinates(Map.get(&1, :at_location)),
            &1 || %{}
          )
        )

      debug(things)

      things
    else
      e ->
        debug(error: e)
        nil
    end
  end

  # proxy relevent events to the map component
  def handle_event("map_"<>_action = event, params, socket) do
    debug(proxy_event: event)
    debug(proxy_params: params)
    Bonfire.Geolocate.MapLive.handle_event(event, params, socket, true)
  end

end
