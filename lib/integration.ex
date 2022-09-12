defmodule Bonfire.Breadpub.Integration do
  def repo, do: Bonfire.Common.Config.get!(:repo_module)

  def mailer, do: Bonfire.Common.Config.get!(:mailer_module)

  def remote_tag_id, do: nil

  # def remote_tag_id, do: "https://bonjour.bonfire.cafe/pub/actors/Needs_Offers" # TODO: put in config
end
