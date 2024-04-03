defmodule Bonfire.Breadpub.Web.HomeLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient,
    schema: Bonfire.API.GraphQL.Schema,
    action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.IntentCreateActivityLive
  alias Bonfire.UI.ValueFlows.CreateMilestoneLive
  alias Bonfire.UI.ValueFlows.FiltersLive

  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  prop selected_tab, :any, default: "publish"

  declare_extension("BreadPub",
    icon: "mdi:baguette",
    emoji: "🥖",
    description:
      l("Tools for co-operative production, distribution, and exchange of economic resources.")
  )

  on_mount {LivePlugs, [Bonfire.UI.Me.LivePlugs.LoadCurrentUser]}

  def mount(params, session, socket) do
    {:ok,
     assign(
       socket,
       page_title: "Create a new intent",
       selected_tab: nil,
       page: "publish",
       action_id: "work",
       intent_type: "need",
       intent_url: "/breadpub/intent/",
       without_sidebar: true
     )}
  end

  def handle_params(%{"tab" => "publish" = tab} = _params, _url, socket) do
    current_user = current_user_required!(socket)

    {:noreply,
     assign(socket,
       selected_tab: tab
     )}
  end

  def handle_params(%{"tab" => "discover" = tab} = _params, _url, socket) do
    current_user = current_user(socket.assigns)
    intents = intents(socket)

    # debug(intents)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents
     )}
  end

  def handle_params(%{"tab" => "my-needs" = tab} = _params, _url, socket) do
    current_user = current_user_required!(socket)
    intents = intents(%{receiver: "me"}, socket)

    # debug(intents)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents
     )}
  end

  def handle_params(%{"tab" => "my-offers" = tab} = _params, _url, socket) do
    current_user = current_user_required!(socket)
    intents = intents(%{provider: "me"}, socket)
    # debug(intents)
    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents
     )}
  end

  def handle_params(%{"tab" => "bookmarked" = tab} = _params, _url, socket) do
    current_user = current_user_required!(socket)

    # TODO

    {:noreply,
     assign(socket,
       selected_tab: tab
     )}
  end

  def handle_params(%{"tab" => tab} = _params, _url, socket) do
    {:noreply,
     assign(socket,
       selected_tab: tab
     )}
  end

  def handle_params(%{} = _params, _url, socket) do
    # current_user = current_user(socket.assigns)

    {:noreply,
     assign(socket,
       selected_tab: "publish"
     )}
  end

  # TODO: filer only for breadpub offers/needs?
  # classified_as: "#{Bonfire.Breadpub.Integration.remote_tag_id}"

  @graphql """
  query($provider: ID, $receiver: ID) {
    intents(
      filter:{
        provider: $provider,
        receiver: $receiver,
        status: "open",
      },
      limit: 200
    ) {
        id
        name
        has_point_in_time
        note
        provider {
          name
          id
          display_username
        }
        receiver {
          name
          id
          display_username
        }
      }
  }
  """
  def intents(params \\ %{}, socket), do: liveql(socket, :intents, params)

  def handle_event("toggle_intent_type", %{"id" => id}, socket) do
    debug(id)
    {:noreply, assign(socket, intent_type: id)}
  end
end
