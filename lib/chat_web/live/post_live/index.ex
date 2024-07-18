defmodule ChatWeb.PostLive.Index do
  use ChatWeb, :live_view

  alias Chat.Content
  alias Chat.Content.Post
  alias Chat.Accounts
  alias Chat.Content

  @impl true
  def mount(_params, session, socket) do

    user = Accounts.get_user_by_session_token(session["user_token"])
    IO.inspect(user)
  {:ok,
     socket
     |> stream(:posts, Content.list_posts())
      |> assign(:user, user)
  }

  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Content.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_info({ChatWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Content.get_post!(id)
    {:ok, _} = Content.delete_post(post)

    {:noreply, stream_delete(socket, :posts, post)}
  end
end
