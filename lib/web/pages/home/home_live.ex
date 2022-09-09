defmodule Bonfire.Breadpub.Web.HomeLive do
  use Bonfire.UI.Common.Web, :surface_live_view

  use AbsintheClient, schema: Bonfire.API.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.UI.Me.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.UI.Me.CreateUserLive

  prop selected_tab, :string, default: "publish"


  declare_extension("BreadPub", icon: "mingcute:bread-fill")

  def mount(params, session, socket) do
    live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      Bonfire.UI.Common.LivePlugs.StaticChanged,
      Bonfire.UI.Common.LivePlugs.Csrf,
      Bonfire.UI.Common.LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(params, session, socket) do
    {:ok, socket
    |> assign(
      page_title: "Create a new intent",
      page: "publish",
      action_id: "work",
      intent_type: "need",
      intent_url: "/breadpub/intent/",
      without_sidebar: true
    )}
  end



  def do_handle_params(%{"tab" => "publish" = tab} = _params, _url, socket) do
    current_user = current_user(socket)

    {:noreply,
     assign(socket,
       selected_tab: tab,
     )}
  end

  def do_handle_params(%{"tab" => "discover" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(socket)
    # debug(intents)

    {:noreply,
     assign(socket,
        selected_tab: tab,
        intents: intents
     )}
  end

  def do_handle_params(%{"tab" => "my-needs" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(%{receiver: "me"}, socket)
    # debug(intents)

    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents
     )}
  end

  def do_handle_params(%{"tab" => "my-offers" = tab} = _params, _url, socket) do
    current_user = current_user(socket)
    intents = intents(%{provider: "me"}, socket)
    # debug(intents)
    {:noreply,
     assign(socket,
       selected_tab: tab,
       intents: intents
     )}
  end


  def do_handle_params(%{"tab" => "bookmarked" = tab} = _params, _url, socket) do
    current_user = current_user(socket)

    # TODO

    {:noreply,
     assign(socket,
       selected_tab: tab,
     )}
  end


  def do_handle_params(%{"tab" => tab} = _params, _url, socket) do

    {:noreply,
     assign(socket,
       selected_tab: tab,
     )}
  end

  def do_handle_params(%{} = _params, _url, socket) do

    current_user = current_user(socket)

    {:noreply,
     assign(socket,
     selected_tab: "publish",
     )}
  end

  def handle_params(params, uri, socket) do
    # poor man's hook I guess
    with {_, socket} <- Bonfire.UI.Common.LiveHandlers.handle_params(params, uri, socket) do
      undead_params(socket, fn ->
        do_handle_params(params, uri, socket)
      end)
    end
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
    {:noreply,
      socket |> assign(intent_type: id)}
    end

    # defdelegate handle_params(params, attrs, socket), to: Bonfire.UI.Common.LiveHandlers

    def handle_event(action, attrs, socket), do: Bonfire.UI.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
    def handle_info(info, socket), do: Bonfire.UI.Common.LiveHandlers.handle_info(info, socket, __MODULE__)
end
