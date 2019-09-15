defmodule Pghr.Migrations.AddItemsTable do
  use Ecto.Migration

  def change do
    create table(:items) do
      add(:mumble1, :string, null: false)
      add(:mumble2, :string, null: false)
      add(:mumble3, :string, null: false)
    end
  end
end
