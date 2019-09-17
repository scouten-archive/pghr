\set random_item_id random(1,5000)
\set mumble_random random(1,100000000000000)

UPDATE items
    SET mumble3 = 'New Mumble ' || :mumble_random
    WHERE id = :random_item_id;
