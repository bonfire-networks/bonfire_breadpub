defmodule Bonfire.Breadpub.Routes do
  defmacro __using__(_) do

    quote do

      # pages anyone can view
      scope "/bread", Bonfire.Breadpub do
        pipe_through :browser

      end

      # pages you need an account to view
      scope "/bread", Bonfire.Breadpub do
        pipe_through :browser
        pipe_through :account_required

      end

      # VF pages you need to view as a user
      scope "/bread", Bonfire.Breadpub do
        pipe_through :browser
        pipe_through :user_required

        live "/", HomeLive
        live "/:tab", HomeLive
        live "/intent/:id", IntentLive
        # live "/lists", ProcessesLive
        # live "/list/:milestone_id", ProcessLive
        # live "/create-intent", CreateIntentLive
        # live "/discover", DiscoverLive
        # live "/intent/:intent_id", ProposalLive
        # live "/proposal/:proposal_id", ProposalLive
        # live "/proposed_intent/:proposed_intent_id", ProposalLive

        # live "/map/", MapLive
        # live "/map/:id", MapLive

      end
    end
  end
end
