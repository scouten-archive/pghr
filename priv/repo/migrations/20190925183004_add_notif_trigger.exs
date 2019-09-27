defmodule Pghr.Migrations.AddNotifTrigger do
  use Ecto.Migration

  def up do
    execute("""
    CREATE OR REPLACE FUNCTION send_pool_change_notice()
      RETURNS trigger
      AS $function$
      BEGIN
        PERFORM pg_notify('change', 'pools|' || text(NEW.mumble1) || '|' || text(NEW.id));
        RETURN NEW;
      END
      $function$
      LANGUAGE plpgsql;
    """)

    execute("""
    CREATE TRIGGER pool_change_trigger
    AFTER INSERT OR UPDATE
    ON items
    FOR EACH ROW
    EXECUTE PROCEDURE send_pool_change_notice();
    """)
  end
end
