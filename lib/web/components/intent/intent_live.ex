defmodule Bonfire.UI.Breadpub.IntentLive do
  use Bonfire.UI.Common.Web, :stateless_component

  prop name, :string, default: ""
  prop note, :string, default: ""
  prop intent, :any
end
