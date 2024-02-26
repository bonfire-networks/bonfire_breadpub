defmodule Bonfire.Breadpub.MapLive do
  use Bonfire.UI.Common.Web, :live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(params, session, socket) do
    # intents = Bonfire.Breadpub.ProposalLive.all_intents(socket)
    # debug(intents)

    {:ok,
     assign(
       socket,
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
        Enum.map(
          things,
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
  def handle_event("map_" <> _action = event, params, socket) do
    debug(proxy_event: event)
    debug(proxy_params: params)
    Bonfire.Geolocate.MapLive.handle_event(event, params, socket, true)
  end
end
