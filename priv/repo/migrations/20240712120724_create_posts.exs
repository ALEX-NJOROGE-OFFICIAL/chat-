defmodule Chat.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :body, :string
      add :user_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
