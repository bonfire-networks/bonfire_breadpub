defmodule Bonfire.UI.Breadpub.CreateIntentLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop intent_url, :string, required: false, default: ""
  prop action_id, :string, required: false, default: "work"
  prop in_scope_of, :string, required: false
  prop output_of_id, :string, required: false
  prop title, :string, default: "Create a new intent"
  prop intent_type, :string, default: "need"
end
