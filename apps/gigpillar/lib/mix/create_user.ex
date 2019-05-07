defmodule Mix.Tasks.Gigpillar.CreateUser do
  use Mix.Task
  import Mix.Ecto
  import Mix.EctoSQL

  alias Gigpillar.Accounts.User

  @shortdoc "Creates a new user"

  @moduledoc """
    Creates a user
  """

  def run(args) do
    [repo] = parse_repo(args)

    ensure_repo(repo, args)
    ensure_started(repo, [])

    username = "Username:" |> Mix.shell().prompt |> String.trim()
    email = "Email:" |> Mix.shell().prompt |> String.trim()
    password = "Password:" |> password_get |> String.trim()
    confirm = "Password (confirm):" |> password_get |> String.trim()

    if password != confirm do
      Mix.raise("Entered passwords do not match")
    end

    changeset =
      User.register_changeset(%User{}, %{
        username: username,
        email: email,
        password: password,
        password_confirmation: confirm
      })

    repo.insert!(changeset)
  end

  # Password prompt that hides input by every 1ms
  # clearing the line with stderr
  def password_get(prompt) do
    if Hex.State.fetch!(:clean_pass) do
      password_clean(prompt)
    else
      Mix.shell().prompt(prompt <> " ")
    end
  end

  defp password_clean(prompt) do
    pid = spawn_link(fn -> loop(prompt) end)
    ref = make_ref()
    value = IO.gets(prompt <> " ")

    send(pid, {:done, self(), ref})
    receive do: ({:done, ^pid, ^ref} -> :ok)

    value
  end

  defp loop(prompt) do
    receive do
      {:done, parent, ref} ->
        send(parent, {:done, self(), ref})
        IO.write(:standard_error, "\e[2K\r")
    after
      1 ->
        IO.write(:standard_error, "\e[2K\r#{prompt} ")
        loop(prompt)
    end
  end
end
