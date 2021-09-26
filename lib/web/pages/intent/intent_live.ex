defmodule Bonfire.Breadpub.IntentLive do
  use Bonfire.Web, {:surface_view, [layout: {Bonfire.UI.Social.Web.LayoutView, "without_sidebar.html"}]}

  use AbsintheClient, schema: Bonfire.GraphQL.Schema, action: [mode: :internal]

  alias Bonfire.UI.ValueFlows.{IntentCreateActivityLive, CreateMilestoneLive, ProposalFeedLive, FiltersLive}
  alias Bonfire.Web.LivePlugs
  alias Bonfire.Me.Users
  alias Bonfire.Me.Web.{CreateUserLive, LoggedDashboardLive}


  def mount(params, session, socket) do
    LivePlugs.live_plug params, session, socket, [
      LivePlugs.LoadCurrentAccount,
      LivePlugs.LoadCurrentUser,
      LivePlugs.StaticChanged,
      LivePlugs.Csrf, LivePlugs.Locale,
      &mounted/3,
    ]
  end

  defp mounted(%{"id"=> id} = _params, _session, socket) do
    intent = intent(%{id: id}, socket)
    if !intent || intent == %{intent: nil} do
      {:error, :not_found}
    else
    {:ok, socket
    |> assign(
      page_title: "Intent",
      intent: intent,
    )}
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


def handle_event(action, attrs, socket), do: Bonfire.Common.LiveHandlers.handle_event(action, attrs, socket, __MODULE__)
    def handle_info(info, socket), do: Bonfire.Common.LiveHandlers.handle_info(info, socket, __MODULE__)


  end
