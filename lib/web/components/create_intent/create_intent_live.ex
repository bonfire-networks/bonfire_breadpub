defmodule Bonfire.UI.BreadPub.CreateIntentLive do
  use Bonfire.Web, :stateless_component

  prop intent_url, :string, required: false, default: ""
  prop action, :string, required: false
  prop output_of_id, :string, required: false
  prop title, :string, default: "Create a new intent"
end
